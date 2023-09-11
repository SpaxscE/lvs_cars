
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

function ENT:IsLegalInput()
	if not self.ForwardAngle then return true end

	local ForwardVel = self:Sign( math.Round( self:VectorSplitNormal( self:LocalToWorldAngles( self.ForwardAngle ):Forward(), self:GetVelocity() ) / 100, 0 ) )
	local DesiredVel = self:GetReverse() and -1 or 1

	return ForwardVel == DesiredVel * math.abs( ForwardVel )
end

function ENT:LerpThrottle( Throttle )
	if not self:GetEngineActive() then self:SetThrottle( 0 ) return end

	local Rate = FrameTime() * 3.5
	local Cur = self:GetThrottle()
	local New = Cur + math.Clamp(Throttle - Cur,-Rate,Rate)

	self:SetThrottle( New )
end

function ENT:LerpBrake( Brake )
	local Rate = FrameTime() * 3.5
	local Cur = self:GetBrake()
	local New = Cur + math.Clamp(Brake - Cur,-Rate,Rate)

	self:SetBrake( New )
end

function ENT:CalcThrottle( ply )
	local KeyThrottle = ply:lvsKeyDown( "CAR_THROTTLE" )
	local KeyBrakes = ply:lvsKeyDown( "CAR_BRAKE" )

	local ThrottleValue = ply:lvsKeyDown( "CAR_THROTTLE_MOD" ) and 1 or 0.5
	local Throttle = KeyThrottle and ThrottleValue or 0

	if not self:IsLegalInput() then
		self:LerpThrottle( 0 )
		self:LerpBrake( (KeyThrottle or KeyBrakes) and 1 or 0 )

		return
	end

	self:LerpThrottle( Throttle )
	self:LerpBrake( KeyBrakes and 1 or 0 )
end

function ENT:CalcHandbrake( ply )
	if self:GetParkingBrake() or ply:lvsKeyDown( "CAR_HANDBRAKE" ) then
		self:EnableHandbrake()
	else
		self:ReleaseHandbrake()
	end
end

function ENT:CalcTransmission( ply )
	local KeyReverse = ply:lvsKeyDown( "CAR_REVERSE" )

	if KeyReverse and self._KeyReversePressedTime then
		local ForceHandbrake = (CurTime() - self._KeyReversePressedTime) > 1 and self:GetThrottle() == 0

		if self._oldForceHandbrake ~= ForceHandbrake then
			self._oldForceHandbrake = ForceHandbrake

			if ForceHandbrake then
				self:SetParkingBrake( not self:GetParkingBrake() )

				if self:GetParkingBrake() then
					self:SetReverse( false )
				end
			end
		end
	end

	if KeyReverse ~= self._oldKeyReverse then
		self._oldKeyReverse = KeyReverse

		if KeyReverse then
			self._KeyReversePressedTime = CurTime()
		else
			self._KeyReversePressedTime = nil

			return
		end

		if self:GetParkingBrake() then return end

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

	self:SetRoadkillAttacker( ply )

	if ply:lvsKeyDown( "CAR_MENU" ) then
		self:LerpBrake( 0 )
		self:LerpThrottle( 0 )

		return
	end

	if ply:lvsMouseAim() then
		if ply:lvsKeyDown( "FREELOOK" ) or ply:lvsKeyDown( "CAR_STEER_LEFT" ) or ply:lvsKeyDown( "CAR_STEER_RIGHT" ) then
			self:CalcSteer( ply )
		else
			self:CalcMouseSteer( ply )
		end
	else
		self:CalcSteer( ply )
	end

	if self.PivotSteerEnable then
		self:CalcPivotSteer( ply )

		if not self:PivotSteer() then
			self:CalcThrottle( ply )
		end
	else
		self:CalcThrottle( ply )
	end

	self:CalcHandbrake( ply )
	self:CalcTransmission( ply )
	self:CalcLights( ply )

	if not self.HornSound or not IsValid( self.HornSND ) then return end

	if ply:lvsKeyDown( "ATTACK" ) then
		self.HornSND:Play()
	else
		self.HornSND:Stop()
	end
end

function ENT:SetRoadkillAttacker( ply )
	local T = CurTime()

	if (self._nextSetAttacker or 0) > T then return end

	self._nextSetAttacker = T + 1

	self:SetPhysicsAttacker( ply, 1.1 )
end