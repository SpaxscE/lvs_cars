
function ENT:CalcSteer( ply, cmd )
	local KeyLeft = cmd:KeyDown( IN_MOVELEFT )
	local KeyRight = cmd:KeyDown( IN_MOVERIGHT )

	local MaxSteer = self:GetMaxSteerAngle()

	local Vel = self:GetVelocity()

	local TargetValue = (KeyRight and 1 or 0) - (KeyLeft and 1 or 0)

	if Vel:Length() > self.FastSteerActiveVelocity then
		local Forward = self:GetForward()
		local Right = self:GetRight()

		local Axle = self:GetAxleData( 1 )

		if Axle then
			local Ang = self:LocalToWorldAngles( self:GetAxleData( 1 ).ForwardAngle )

			Forward = Ang:Forward()
			Right = Ang:Right()
		end

		local VelNormal = Vel:GetNormalized()

		local DriftAngle = self:AngleBetweenNormal( Forward, VelNormal )

		if DriftAngle < self.FastSteerDeactivationDriftAngle then
			MaxSteer = math.min( MaxSteer, self.FastSteerAngleClamp )
		end

		if DriftAngle > self.SteerAssistDeadZoneAngle then
			if not KeyLeft and not KeyRight then
				local Cur = self:GetSteer() / MaxSteer

				local HelpAng = math.min( MaxSteer, self.SteerAssistMaxAngle )

				TargetValue = math.Clamp( -(self:AngleBetweenNormal( Right, VelNormal ) - 90) * self.SteerAssistMultiplier,-HelpAng,HelpAng) / MaxSteer
			end
		end
	end

	local Cur = self:GetSteer() / MaxSteer

	local Diff = TargetValue - Cur

	local Returning = (Diff > 0 and Cur < 0) or (Diff < 0 and Cur > 0)

	local Rate = FrameTime() * (Returning and self.SteerReturnSpeed or self.SteerSpeed)

	local New = (Cur + math.Clamp(Diff,-Rate,Rate)) * MaxSteer

	self:SetSteer( New )
end

function ENT:CalcThrottle( ply, cmd )
	if not self:GetEngineActive() then self:SetThrottle( 0 ) return end

	local ThrottleValue = cmd:KeyDown( IN_SPEED ) and 1 or 0.5

	local Throttle = cmd:KeyDown( IN_FORWARD ) and ThrottleValue or 0

	local Rate = FrameTime() * 3.5
	local Cur = self:GetThrottle()
	local New = Cur + math.Clamp(Throttle - Cur,-Rate,Rate)

	self:SetThrottle( New )
end

function ENT:CalcHandbrake( ply, cmd )
	if cmd:KeyDown( IN_JUMP ) then
		self:EnableHandbrake()
	else
		self:ReleaseHandbrake()
	end
end

function ENT:CalcBrake( ply, cmd )
	local KeyBrake = cmd:KeyDown( IN_BACK )

	if KeyBrake == self:GetBrake() then return end

	self:SetBrake( KeyBrake )
end

function ENT:StartCommand( ply, cmd )
	if self:GetDriver() ~= ply then return end

	self:CalcSteer( ply, cmd )
	self:CalcThrottle( ply, cmd )
	self:CalcHandbrake( ply, cmd )
	self:CalcBrake( ply, cmd )
end
