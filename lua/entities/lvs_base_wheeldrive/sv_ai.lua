
function ENT:OnCreateAI()
	self:StartEngine()
end

function ENT:OnRemoveAI()
	self:StopEngine()
end

function ENT:RunAI()
	local Pod = self:GetDriverSeat()

	if not IsValid( Pod ) then self:SetAI( false ) return end

	local RangerLength = 25000

	local Target = self:AIGetTarget()

	local StartPos = self:LocalToWorld( self:OBBCenter() )

	local TraceFilter = self:GetCrosshairFilterEnts()

	local Front = util.TraceLine( { start = StartPos, filter = TraceFilter, endpos = StartPos + self:GetForward() * RangerLength } )
	local FrontLeft = util.TraceLine( { start = StartPos, filter = TraceFilter, endpos = StartPos + self:LocalToWorldAngles( Angle(0,15,0) ):Forward() * RangerLength } )
	local FrontRight = util.TraceLine( { start = StartPos, filter = TraceFilter, endpos = StartPos + self:LocalToWorldAngles( Angle(0,-15,0) ):Forward() * RangerLength } )
	local FrontLeft1 = util.TraceLine( { start = StartPos, filter = TraceFilter, endpos = StartPos + self:LocalToWorldAngles( Angle(0,60,0) ):Forward() * RangerLength } )
	local FrontRight1 = util.TraceLine( { start = StartPos, filter = TraceFilter, endpos = StartPos + self:LocalToWorldAngles( Angle(0,-60,0) ):Forward() * RangerLength } )
	local FrontLeft2 = util.TraceLine( { start = StartPos, filter = TraceFilter, endpos = StartPos + self:LocalToWorldAngles( Angle(0,85,0) ):Forward() * RangerLength } )
	local FrontRight2 = util.TraceLine( { start = StartPos, filter = TraceFilter, endpos = StartPos + self:LocalToWorldAngles( Angle(0,-85,0) ):Forward() * RangerLength } )

	local MovementTargetPos = (Front.HitPos + FrontLeft.HitPos + FrontRight.HitPos + FrontLeft1.HitPos + FrontRight1.HitPos + FrontLeft2.HitPos + FrontRight2.HitPos) / 7

	if IsValid( Target ) then
		MovementTargetPos = (MovementTargetPos + Target:GetPos()) * 0.5
	end

	local TargetPosLocal = Pod:WorldToLocal( MovementTargetPos )
	local Throttle = math.min( math.max( TargetPosLocal:Length() - 500, 0 ) / 10, 1 )

	self:PhysWake()
	self:SetThrottle( Throttle )

	if Throttle == 0 then
		self:SetBrake( 1 )
	else
		self:SetBrake( 0 )
	end

	self:ReleaseHandbrake()
	self:SetReverse( TargetPosLocal.y < 0 )

	self:SteerTo( math.Clamp(TargetPosLocal.x / 500,-1,1), self:GetMaxSteerAngle() )

	self._AIFireInput = false

	if IsValid( self:GetHardLockTarget() ) then
		TargetPos = self:GetHardLockTarget():GetPos()

		if self:AITargetInFront( self:GetHardLockTarget(), 65 ) then
			self._AIFireInput = true
		end
	else
		if IsValid( Target ) then
			TargetPos = Target:LocalToWorld( Target:OBBCenter() )

			if self:AITargetInFront( Target, 65 ) then
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

				self._AIFireInput = true
			else
				self:AISelectWeapon( 1 )
			end
		end
	end

	local T = CurTime()
	local AimOffSet = Vector( math.cos( T ) * 50, math.sin( T ) * 50, math.cos( T * 0.25 ) * 50 )
	self:SetAIAimVector( (TargetPos + AimOffSet - StartPos):GetNormalized() )
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

