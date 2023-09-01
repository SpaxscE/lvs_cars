
function ENT:CalcMouseSteer( ply )
	self:ApproachTargetAngle( ply:EyeAngles() )
end

function ENT:CalcSteer( ply )
	local KeyLeft = ply:lvsKeyDown( "CAR_STEER_LEFT" )
	local KeyRight = ply:lvsKeyDown( "CAR_STEER_RIGHT" )

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

		if not KeyLeft and not KeyRight then
			local Cur = self:GetSteer() / MaxSteer

			local MaxHelpAng = math.min( MaxSteer, self.SteerAssistMaxAngle )

			local Ang = self:AngleBetweenNormal( Right, VelNormal ) - 90
			local HelpAng = ((math.abs( Ang ) / 90) ^ self.SteerAssistExponent) * 90 * self:Sign( Ang )

			TargetValue = math.Clamp( -HelpAng * self.SteerAssistMultiplier,-MaxHelpAng,MaxHelpAng) / MaxSteer
		end
	end

	self:SteerTo( TargetValue, MaxSteer  )
end

function ENT:CalcThrottle( ply )
	if not self:GetEngineActive() then self:SetThrottle( 0 ) return end

	local ThrottleValue = ply:lvsKeyDown( "CAR_THROTTLE_MOD" ) and 1 or 0.5

	local Throttle = ply:lvsKeyDown( "CAR_THROTTLE" ) and ThrottleValue or 0

	local Rate = FrameTime() * 3.5
	local Cur = self:GetThrottle()
	local New = Cur + math.Clamp(Throttle - Cur,-Rate,Rate)

	self:SetThrottle( New )
end

function ENT:CalcHandbrake( ply )
	if ply:lvsKeyDown( "CAR_HANDBRAKE" ) then
		self:EnableHandbrake()
	else
		self:ReleaseHandbrake()
	end
end

function ENT:CalcBrake( ply )
	local Brake = ply:lvsKeyDown( "CAR_BRAKE" ) and 1 or 0

	local Rate = FrameTime() * 3.5
	local Cur = self:GetBrake()
	local New = Cur + math.Clamp(Brake - Cur,-Rate,Rate)

	self:SetBrake( New )
end

function ENT:CalcTransmission( ply )
	local walk = ply:lvsKeyDown( "CAR_REVERSE" )

	if not self:GetReverse() and walk then
		if self:GetVelocity():Length() > self.MaxVelocityReverse then
			self:SetReverse( false )
			self:SetBrake( 1 )

			return
		end
	end

	if walk ~= self._oldwalk then
		self._oldwalk = walk

		if not walk then return end

		self:SetReverse( not self:GetReverse() )
		self:EmitSound( self.TransShiftSound, 75 )
	end
end

function ENT:CalcLights( ply )
	local LightsHandler = self:GetLightsHandler()

	if not IsValid( LightsHandler ) then return end

	local lights = ply:lvsKeyDown( "CAR_LIGHTS_TOGGLE" )

	local T = CurTime()

	if lights ~= self._oldlights then
		if not isbool( self._oldlights ) then self._oldlights = lights return end

		if lights then
			self._LightsPressedTime = T
		else
			if LightsHandler:GetActive() then
				if self:HasHighBeams() then
					if (T - (self._LightsPressedTime or 0)) > 0.5 then
						LightsHandler:SetActive( false )
						LightsHandler:SetHighActive( false )
						LightsHandler:SetFogActive( false )

						self:EmitSound( "items/flashlight1.wav", 75, 100, 0.25 )
					else
						LightsHandler:SetHighActive( not LightsHandler:GetHighActive() )

						self:EmitSound( "buttons/lightswitch2.wav", 75, 80, 0.25)
					end
				else
					LightsHandler:SetActive( false )
					LightsHandler:SetHighActive( false )
					LightsHandler:SetFogActive( false )

					self:EmitSound( "items/flashlight1.wav", 75, 100, 0.25 )
				end
			else
				self:EmitSound( "items/flashlight1.wav", 75, 100, 0.25 )

				if self:HasFogLights() and (T - (self._LightsPressedTime or T)) > 0.5 then
					LightsHandler:SetFogActive( not LightsHandler:GetFogActive() )
				else
					LightsHandler:SetActive( true )
				end
			end
		end

		self._oldlights = lights
	end
end

function ENT:StartCommand( ply, cmd )
	if self:GetDriver() ~= ply then return end

	if ply:lvsKeyDown( "CAR_MENU" ) then return end

	if ply:lvsMouseAim() then
		if ply:lvsKeyDown( "FREELOOK" ) or ply:lvsKeyDown( "CAR_STEER_LEFT" ) or ply:lvsKeyDown( "CAR_STEER_RIGHT" ) then
			self:CalcSteer( ply )
		else
			self:CalcMouseSteer( ply )
		end
	else
		self:CalcSteer( ply )
	end

	self:CalcThrottle( ply )
	self:CalcHandbrake( ply )
	self:CalcBrake( ply )
	self:CalcTransmission( ply )
	self:CalcLights( ply )
	self:SetRoadkillAttacker( ply )
end

function ENT:SetRoadkillAttacker( ply )
	local T = CurTime()

	if (self._nextSetAttacker or 0) > T then return end

	self._nextSetAttacker = T + 1

	self:SetPhysicsAttacker( ply, 1.1 )
end