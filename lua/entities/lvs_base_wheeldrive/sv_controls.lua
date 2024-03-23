
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

	local MinSpeed = math.min(self.MaxVelocity,self.MaxVelocityReverse)

	local ForwardVel = self:Sign( math.Round( self:VectorSplitNormal( self:LocalToWorldAngles( self.ForwardAngle ):Forward(), self:GetVelocity() ) / MinSpeed, 0 ) )
	local DesiredVel = self:GetReverse() and -1 or 1

	return ForwardVel == DesiredVel * math.abs( ForwardVel )
end

function ENT:LerpThrottle( Throttle )
	if not self:GetEngineActive() then self:SetThrottle( 0 ) return end

	local Rate = FrameTime() * self.ThrottleRate
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

	if self:GetReverse() then
		KeyThrottle = ply:lvsKeyDown( "CAR_BRAKE" )
		KeyBrakes = ply:lvsKeyDown( "CAR_THROTTLE" )
	end

	local ThrottleValue = ply:lvsKeyDown( "CAR_THROTTLE_MOD" ) and self:GetMaxThrottle() or 0.5
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
	if ply:lvsKeyDown( "CAR_HANDBRAKE" ) then
		self:EnableHandbrake()
	else
		self:ReleaseHandbrake()
	end
end

function ENT:CalcTransmission( ply )
	if not self.ForwardAngle then return end

	local ForwardVelocity = self:VectorSplitNormal( self:LocalToWorldAngles( self.ForwardAngle ):Forward(), self:GetVelocity() )

	local KeyForward = ply:lvsKeyDown( "CAR_THROTTLE" )
	local KeyBackward = ply:lvsKeyDown( "CAR_BRAKE" )

	local ReverseVelocity = self.AutoReverseVelocity

	if KeyForward and KeyBackward then return end

	if not KeyForward and not KeyBackward then
		if ForwardVelocity > ReverseVelocity then
			self:SetReverse( false )
		end

		if ForwardVelocity < -ReverseVelocity then
			self:SetReverse( true )
		end

		return
	end

	local T = CurTime()

	if KeyForward and ForwardVelocity > -ReverseVelocity then
		self:SetReverse( false )
	end

	if KeyBackward and ForwardVelocity < ReverseVelocity then

		if not self._toggleReverse then
			self._toggleReverse = true

			self._KeyBackTime = T + 0.4
		end

		if (self._KeyBackTime or 0) < T then
			self:SetReverse( true )
		end
	else
		self._toggleReverse = nil
	end

	local Reverse = self:GetReverse()

	if Reverse ~= self._oldKeyReverse then
		self._oldKeyReverse = Reverse

		self:EmitSound( self.TransShiftSound, 75 )
	end
end

function ENT:CalcLights( ply )
	local LightsHandler = self:GetLightsHandler()

	if not IsValid( LightsHandler ) then return end

	local lights = ply:lvsKeyDown( "CAR_LIGHTS_TOGGLE" )

	local T = CurTime()

	if self._lights ~= lights then
		self._lights = lights

		if lights then
			self._LightsUnpressTime = T
		else
			self._LightsUnpressTime = nil
		end
	end

	if self._lights and (T - self._LightsUnpressTime) > 0.4 then
		lights = false
	end

	if lights ~= self._oldlights then
		if not isbool( self._oldlights ) then self._oldlights = lights return end

		if lights then
			self._LightsPressedTime = T
		else
			if LightsHandler:GetActive() then
				if self:HasHighBeams() then
					if (T - (self._LightsPressedTime or 0)) >= 0.4 then
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

				if self:HasFogLights() and (T - (self._LightsPressedTime or T)) >= 0.4 then
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

		if self:PivotSteer() then
			self:LerpBrake( 0 )
		else
			self:CalcThrottle( ply )
		end
	else
		self:CalcThrottle( ply )
	end

	self:CalcHandbrake( ply )
	self:CalcTransmission( ply )
	self:CalcLights( ply )
	self:CalcSiren( ply )
end

function ENT:CalcSiren( ply )
	local horn = ply:lvsKeyDown( "ATTACK" )

	if istable( self.SirenSound ) and IsValid( self.SirenSND ) then
		local mode = self:GetSirenMode()
		local siren = ply:lvsKeyDown( "CAR_SIREN" )

		if mode ~= -1 then
			if horn then
				if self.SirenSound[ mode ].horn then
					self:SetSirenSound( self.SirenSound[ mode ].horn )
				end

				horn = false
				siren = false
			else
				if not siren then
					if self.SirenSound[ mode ].siren then
						self:SetSirenSound( self.SirenSound[ mode ].siren )
					end
				end
			end
		end

		local T = CurTime()

		if self._siren ~= siren then
			self._siren = siren

			if siren then
				self._sirenUnpressTime = T
			else
				self._sirenUnpressTime = nil
			end
		end

		if self._siren and (T - self._sirenUnpressTime) > 0.4 then
			siren = false
		end

		if siren ~= self._oldsiren then
			if not isbool( self._oldsiren ) then self._oldsiren = siren return end

			if siren then
				self._SirenPressedTime = T
			else
				if (T - (self._SirenPressedTime or 0)) >= 0.4 then
					self:StopSiren()
				else
					self:StartSiren()
				end
			end

			self._oldsiren = siren
		end
	end

	if self.HornSound and IsValid( self.HornSND ) then
		if horn then
			self.HornSND:Play()
		else
			self.HornSND:Stop()
		end
	end
end

function ENT:SetSirenSound( sound )
	if sound then 
		if sound ~= self._OldSirenSound then
			if self._PreventSiren then return end

			self._OldSirenSound = sound

			self._PreventSiren = true

			self.SirenSND:Stop()
			self.SirenSND:SetSound( sound )
			self.SirenSND:SetSoundInterior( sound )

			timer.Simple( 0.1, function()
				if not IsValid( self.SirenSND ) then return end

				self.SirenSND:Play()
	
				self._PreventSiren = false
			end )
		end
	else
		self._OldSirenSound = nil

		self.SirenSND:Stop()
	end
end

function ENT:StartSiren()
	local Mode = self:GetSirenMode()
	local Max = #self.SirenSound

	local Next = Mode + 1

	if Mode <= -1 or Next > Max then
		Next = 1
	end

	self:SetSirenMode( Next )
	self:SetSirenSound( self.SirenSound[ Next ].siren )
end

function ENT:StopSiren()
	self:SetSirenMode( -1 )
	self.SirenSND:Stop()
end

function ENT:SetRoadkillAttacker( ply )
	local T = CurTime()

	if (self._nextSetAttacker or 0) > T then return end

	self._nextSetAttacker = T + 1

	self:SetPhysicsAttacker( ply, 1.1 )
end
