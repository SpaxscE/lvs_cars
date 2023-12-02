ENT.TurretAimRate = 25

ENT.TurretRotationSound = "vehicles/tank_turret_loop1.wav"
ENT.TurretRotationSoundDamaged = "physics/metal/metal_box_scrape_rough_loop1.wav"

ENT.TurretFakeBarrel = false
ENT.TurretFakeBarrelRotationCenter = vector_origin

ENT.TurretPitchPoseParameterName = "turret_pitch"
ENT.TurretPitchMin = -15
ENT.TurretPitchMax = 15
ENT.TurretPitchMul = 1
ENT.TurretPitchOffset = 0

ENT.TurretYawPoseParameterName = "turret_yaw"
ENT.TurretYawMul = 1
ENT.TurretYawOffset = 0

function ENT:TurretSystemDT()
	self:AddDT( "Bool", "TurretEnabled" )
	self:AddDT( "Bool", "TurretDestroyed" )
	self:AddDT( "Entity", "TurretArmor" )

	if SERVER then
		self:SetTurretEnabled( true )
		self:SetTurretPitch( self.TurretPitchOffset )
		self:SetTurretYaw( self.TurretYawOffset )
	end
end

function ENT:SetTurretPitch( num )
	self._turretPitch = num
end

function ENT:SetTurretYaw( num )
	self._turretYaw = num
end

function ENT:GetTurretPitch()
	return (self._turretPitch or self.TurretPitchOffset)
end

function ENT:GetTurretYaw()
	return (self._turretYaw or self.TurretYawOffset)
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

	net.Receive( "lvs_turret_sync_other", function( len )
		local veh = net.ReadEntity()

		if not IsValid( veh ) then return end

		veh:SetTurretPitch( net.ReadFloat() )
		veh:SetTurretYaw( net.ReadFloat() )
	end )
else
	util.AddNetworkString( "lvs_turret_sync_other" )

	function ENT:OnDriverExitVehicle( ply )
		net.Start( "lvs_turret_sync_other" )
			net.WriteEntity( self )
			net.WriteFloat( self:GetTurretPitch() )
			net.WriteFloat( self:GetTurretYaw() )
		net.Broadcast()
	end

	function ENT:CalcTurretSound( Pitch, Yaw, AimRate )
		local DeltaPitch = Pitch - self:GetTurretPitch()
		local DeltaYaw = Yaw - self:GetTurretYaw()

		local PitchVolume = math.abs( DeltaPitch ) / AimRate
		local YawVolume = math.abs( DeltaYaw ) / AimRate

		local PlayPitch = PitchVolume > 0.95
		local PlayYaw = YawVolume > 0.95

		local TurretArmor = self:GetTurretArmor()
		local Destroyed = self:GetTurretDestroyed()

		if Destroyed and (PlayPitch or PlayYaw) and IsValid( TurretArmor ) then
			local T = CurTime()

			if (self._NextTurDMGfx or 0) < T then
				self._NextTurDMGfx = T + 0.1

				local effectdata = EffectData()
				effectdata:SetOrigin( TurretArmor:GetPos() )
				effectdata:SetNormal( self:GetUp() )
				effectdata:SetRadius( 0 )
				util.Effect( "cball_bounce", effectdata, true, true )
			end
		end

		if PlayPitch or PlayYaw then
			self:DoTurretSound()

			if Destroyed then self:StartTurretSoundDMG() end
		else
			self:StopTurretSoundDMG()
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

	function ENT:StartTurretSoundDMG()
		if self._turretSNDdmg then return self._turretSNDdmg end

		self._turretSNDdmg = CreateSound( self, self.TurretRotationSoundDamaged  )
		self._turretSNDdmg:PlayEx(0.5, 100)

		return self._turretSNDdmg
	end

	function ENT:StopTurretSoundDMG()
		if not self._turretSNDdmg then return end

		self._turretSNDdmg:Stop()
		self._turretSNDdmg = nil
	end

	function ENT:StartTurretSound()
		if self._turretSND then return self._turretSND end

		self._turretSND = CreateSound( self, self.TurretRotationSound  )
		self._turretSND:PlayEx(0,100)

		return self._turretSND
	end

	function ENT:OnRemoved()
		self:StopTurretSound()
		self:StopTurretSoundDMG()
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
	if not self:IsTurretEnabled() then if SERVER then self:StopTurretSound() self:StopTurretSoundDMG() end return end

	local AimAngles = self:WorldToLocalAngles( self:GetAimVector():Angle() )

	if self.TurretFakeBarrel then
		AimAngles = self:WorldToLocalAngles( (self:LocalToWorld( self.TurretFakeBarrelRotationCenter ) - self:GetEyeTrace().HitPos):Angle() )
	end

	local AimRate = self.TurretAimRate * FrameTime() 

	if self:GetTurretDestroyed() then
		AimRate = AimRate * 0.25
	end

	local Pitch = math.Clamp( math.ApproachAngle( self:GetTurretPitch(), AimAngles.p, AimRate ), self.TurretPitchMin, self.TurretPitchMax )
	local Yaw = math.ApproachAngle( self:GetTurretYaw(), AimAngles.y, AimRate )

	if self.TurretYawMin and self.TurretYawMax then
		Yaw = math.Clamp( Yaw, self.TurretYawMin, self.TurretYawMax )
	end

	if SERVER then
		self:CalcTurretSound( Pitch, Yaw, AimRate )
	end

	self:SetTurretPitch( Pitch )
	self:SetTurretYaw( Yaw )

	self:SetPoseParameter(self.TurretPitchPoseParameterName, self.TurretPitchOffset + self:GetTurretPitch() * self.TurretPitchMul )
	self:SetPoseParameter(self.TurretYawPoseParameterName, self.TurretYawOffset + self:GetTurretYaw() * self.TurretYawMul )
end
