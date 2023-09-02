
function ENT:OnCreateAI()
	self:StartEngine()

	self.LVSFireBullet = function( self, data )
		local Dir1 = (self:GetEyeTrace().HitPos - data.Src):GetNormalized()
		local Dir2 = data.Dir

		if self:AngleBetweenNormal( Dir1, Dir2 ) < 15 then
			data.Dir = Dir1
		end

		data.Entity = self
		data.Velocity = data.Velocity + self:GetVelocity():Length()
		data.SrcEntity = self:WorldToLocal( data.Src )

		LVS:FireBullet( data )
	end
end

function ENT:OnRemoveAI()
	self:StopEngine()
end

function ENT:AIGetMovementTarget()
	local Pod = self:GetDriverSeat()

	if not IsValid( Pod ) then return (self._MovmentTarget or self:GetPos()) end

	return (self._MovmentTarget or Pod:LocalToWorld( Pod:OBBCenter() + Vector(0,100,0)))
end

function ENT:AISetMovementTarget( pos )
	self._MovmentTarget = pos
end

function ENT:RunAI()
	local Pod = self:GetDriverSeat()

	if not IsValid( Pod ) then self:SetAI( false ) return end

	local RangerLength = 25000

	local Target = self:AIGetTarget()

	local StartPos = Pod:LocalToWorld( Pod:OBBCenter() )

	local MovementTargetPos = self:AIGetMovementTarget()

	local TargetPos = MovementTargetPos

	if IsValid( Target ) then
		MovementTargetPos = Target:GetPos()
	end

	local TargetPosLocal = Pod:WorldToLocal( MovementTargetPos )
	local Throttle = math.min( math.max( TargetPosLocal:Length() - 750, 0 ) / 10, 1 )

	self:PhysWake()
	self:SetThrottle( Throttle )

	if Throttle == 0 then
		self:SetBrake( 1 )
	else
		self:SetBrake( 0 )
	end

	self:ReleaseHandbrake()
	self:SetReverse( TargetPosLocal.y < 0 )

	self:SteerTo( math.Clamp(TargetPosLocal.x / 750,-1,1), self:GetMaxSteerAngle() )

	self._AIFireInput = false

	if IsValid( self:GetHardLockTarget() ) then
		Target = self:GetHardLockTarget()

		TargetPos = Target:LocalToWorld( Target:OBBCenter() )

		self._AIFireInput = true
	else
		if IsValid( Target ) then
			local PhysObj = Target:GetPhysicsObject()
			if IsValid( PhysObj ) then
				TargetPos = Target:LocalToWorld( PhysObj:GetMassCenter() )
			else
				TargetPos = Target:LocalToWorld( Target:OBBCenter() )
			end

			if self:AIHasWeapon( 1 ) or self:AIHasWeapon( 2 ) then
				self._AIFireInput = true
			end

			local CurHeat = self:GetNWHeat()
			local CurWeapon = self:GetSelectedWeapon()

			if CurWeapon > 2 then
				self:AISelectWeapon( 1 )
			else
				if Target.LVS and CurHeat < 0.9 then
					if CurWeapon == 1 and self:AIHasWeapon( 2 ) then
						self:AISelectWeapon( 2 )

					elseif CurWeapon == 2 then
						self:AISelectWeapon( 1 )
					end
				else
					if CurHeat == 0 and math.cos( CurTime() ) > 0 then
						self:AISelectWeapon( 1 )
					end
				end
			end
		end
	end

	self:SetAIAimVector( (TargetPos - StartPos):GetNormalized() )
end

function ENT:OnAITakeDamage( dmginfo )
	local attacker = dmginfo:GetAttacker()

	if not IsValid( attacker ) then return end

	if not self:AITargetInFront( attacker, IsValid( self:AIGetTarget() ) and 120 or 45 ) then
		self:SetHardLockTarget( attacker )
	end
end

function ENT:SetHardLockTarget( target )
	if not self:IsEnemy( target ) then return end

	self._HardLockTarget =  target
	self._HardLockTime = CurTime() + 4
end

function ENT:GetHardLockTarget()
	if (self._HardLockTime or 0) < CurTime() then return NULL end

	return self._HardLockTarget
end

function ENT:AISelectWeapon( ID )
	if ID == self:GetSelectedWeapon() then return end

	local T = CurTime()

	if (self._nextAISwitchWeapon or 0) > T then return end

	self._nextAISwitchWeapon = T + math.random(3,6)

	self:SelectWeapon( ID )
end
