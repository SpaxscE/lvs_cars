
function ENT:OnCreateAI()
	self:DisableManualTransmission()

	self:StartEngine()
end

function ENT:OnRemoveAI()
	self:StopEngine()
end

function ENT:AIGetMovementTarget()
	local Pod = self:GetDriverSeat()

	if not IsValid( Pod ) then return (self._MovmentTarget or self:GetPos()) end

	return (self._MovmentTarget or Pod:LocalToWorld( Pod:OBBCenter() + Vector(0,100,0))), (self._MovementDistance or 500)
end

function ENT:AISetMovementTarget( pos, dist )
	self._MovmentTarget = pos
	self._MovementDistance = (dist or 500)
end

function ENT:RunAI()
	local Pod = self:GetDriverSeat()

	if not IsValid( Pod ) then self:SetAI( false ) return end

	local RangerLength = 25000

	local Target = self:AIGetTarget( 180 )

	local StartPos = Pod:LocalToWorld( Pod:OBBCenter() )

	local GotoPos, GotoDist = self:AIGetMovementTarget()

	local TargetPos = GotoPos

	if IsValid( Target ) then
		GotoPos = Target:GetPos()
	else
		if self:GetAITEAM() ~= 0 then
			local TraceFilter = self:GetCrosshairFilterEnts()

			local Front = util.TraceLine( { start = StartPos, filter = TraceFilter, endpos = StartPos + Pod:GetForward() * RangerLength } )
			local FrontLeft = util.TraceLine( { start = StartPos, filter = TraceFilter, endpos = StartPos - Pod:LocalToWorldAngles( Angle(0,15,0) ):Right() * RangerLength } )
			local FrontRight = util.TraceLine( { start = StartPos, filter = TraceFilter, endpos = StartPos - Pod:LocalToWorldAngles( Angle(0,-15,0) ):Right() * RangerLength } )
			local FrontLeft1 = util.TraceLine( { start = StartPos, filter = TraceFilter, endpos = StartPos - Pod:LocalToWorldAngles( Angle(0,60,0) ):Right() * RangerLength } )
			local FrontRight1 = util.TraceLine( { start = StartPos, filter = TraceFilter, endpos = StartPos - Pod:LocalToWorldAngles( Angle(0,-60,0) ):Right() * RangerLength } )
			local FrontLeft2 = util.TraceLine( { start = StartPos, filter = TraceFilter, endpos = StartPos - Pod:LocalToWorldAngles( Angle(0,85,0) ):Right() * RangerLength } )
			local FrontRight2 = util.TraceLine( { start = StartPos, filter = TraceFilter, endpos = StartPos - Pod:LocalToWorldAngles( Angle(0,-85,0) ):Right() * RangerLength } )

			GotoPos = (Front.HitPos + FrontLeft.HitPos + FrontRight.HitPos + FrontLeft1.HitPos + FrontRight1.HitPos + FrontLeft2.HitPos + FrontRight2.HitPos) / 7

			if self:GetReverse() then
				if Front.Fraction < 0.03 then
					GotoPos = StartPos - Pod:GetForward() * 1000
				end
			else
				if Front.Fraction < 0.01 then
					GotoPos = StartPos - Pod:GetForward() * 1000
				end
			end
		end
	end

	local TargetPosLocal = Pod:WorldToLocal( GotoPos )
	local Throttle = math.min( math.max( TargetPosLocal:Length() - GotoDist, 0 ) / 10, 1 )

	self:PhysWake()

	if self:IsLegalInput() then
		self:LerpThrottle( Throttle )

		if Throttle == 0 then
			self:LerpBrake( 1 )
		else
			self:LerpBrake( 0 )
		end
	else
		self:LerpThrottle( 0 )
		self:LerpBrake( Throttle )
	end

	self:ReleaseHandbrake()

	self:SetReverse( TargetPosLocal.y < 0 )

	self:ApproachTargetAngle( Pod:LocalToWorldAngles( (GotoPos - self:GetPos()):Angle() ) )

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
