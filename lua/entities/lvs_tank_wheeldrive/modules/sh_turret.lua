ENT.TurretAimRate = 25

ENT.TurretRotationSound = "vehicles/tank_turret_loop1.wav"

ENT.TurretFakeBarrel = false
ENT.TurretRotationCenter = vector_origin

ENT.TurretPitchPoseParameterName = "turret_pitch"
ENT.TurretPitchMin = -15
ENT.TurretPitchMax = 15
ENT.TurretPitchMul = 1
ENT.TurretPitchOffset = 0

ENT.TurretYawPoseParameterName = "turret_yaw"
ENT.TurretYawMul = 1
ENT.TurretYawOffset = 0

function ENT:TurretSystemDT()
	self:AddDT( "Float", "TurretPitch" )
	self:AddDT( "Float", "TurretYaw" )
	self:AddDT( "Bool", "TurretEnabled" )

	if SERVER then
		self:SetTurretEnabled( true )
		self:SetTurretPitch( self.TurretPitchOffset )
		self:SetTurretYaw( self.TurretYawOffset )
	end
end

if CLIENT then
	function ENT:UpdatePoseParameters( steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter )
		self:CalcTurret()
	end

	function ENT:CalcTurret()
		local pod = self:GetDriverSeat()

		if not IsValid( pod ) then return end

		local plyL = LocalPlayer()
		local ply = pod:GetDriver()

		if ply ~= plyL then return end

		self:AimTurret()
	end
else
	function ENT:CalcTurretSound( Pitch, Yaw, AimRate )
		local DeltaPitch = Pitch - self:GetTurretPitch()
		local DeltaYaw = Yaw - self:GetTurretYaw()

		local PitchVolume = math.abs( DeltaPitch ) / AimRate
		local YawVolume = math.abs( DeltaYaw ) / AimRate

		local PlayPitch = PitchVolume > 0.95
		local PlayYaw = YawVolume > 0.95

		if  PlayPitch or PlayYaw then
			self:DoTurretSound()
		end

		local T = self:GetTurretSoundTime()

		if T > 0 then
			local sound = self:StartTurretSound()
			local volume = math.max( PitchVolume, YawVolume )
			local pitch = 90 + 10 * (1 - volume)

			sound:ChangeVolume( volume * 0.25, 0.25 )
			sound:ChangePitch( pitch, 0.25 ) 
		else
			self:StopTurretSound()
		end
	end

	function ENT:DoTurretSound()
		if not self._TurretSound then self._TurretSound = 0 end

		self._TurretSound = CurTime() + 1.1
	end

	function ENT:GetTurretSoundTime()
		if not self._TurretSound then return 0 end

		return math.max(self._TurretSound - CurTime(),0) / 1
	end

	function ENT:StopTurretSound()
		if not self._turretSND then return end
		self._turretSND:Stop()
		self._turretSND = nil
	end

	function ENT:StartTurretSound()
		if self._turretSND then return self._turretSND end

		self._turretSND = CreateSound( self, self.TurretRotationSound  )
		self._turretSND:PlayEx(0,100)

		return self._turretSND
	end

	function ENT:OnRemoved()
		self:StopTurretSound()
	end

	function ENT:OnTick()
		self:AimTurret()
	end
end

function ENT:IsTurretEnabled()
	if self:GetHP() <= 0 then return false end

	if not self:GetTurretEnabled() then return false end

	return IsValid( self:GetDriver() ) or self:GetAI()
end

function ENT:AimTurret()
	if not self:IsTurretEnabled() then if SERVER then self:StopTurretSound() end return end

	local AimAngles = self:WorldToLocalAngles( self:GetAimVector():Angle() )

	if self.TurretFakeBarrel then
		AimAngles = self:WorldToLocalAngles( (self:LocalToWorld( self.TurretRotationCenter ) - self:GetEyeTrace().HitPos):Angle() )
	end

	local AimRate = self.TurretAimRate * FrameTime() 

	local Pitch = math.Clamp( math.ApproachAngle( self:GetTurretPitch(), AimAngles.p, AimRate ), self.TurretPitchMin, self.TurretPitchMax )
	local Yaw = math.ApproachAngle( self:GetTurretYaw(), AimAngles.y, AimRate )

	if SERVER then
		self:CalcTurretSound( Pitch, Yaw, AimRate )
	end

	self:SetTurretPitch( Pitch )
	self:SetTurretYaw( Yaw )

	self:SetPoseParameter(self.TurretPitchPoseParameterName, self.TurretPitchOffset + self:GetTurretPitch() * self.TurretPitchMul )
	self:SetPoseParameter(self.TurretYawPoseParameterName, self.TurretYawOffset + self:GetTurretYaw() * self.TurretYawMul )
end
