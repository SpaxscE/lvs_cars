AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

ENT._LVS = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )
end

if SERVER then
	function ENT:Initialize()	
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		self:DrawShadow( false )
		debugoverlay.Cross( self:GetPos(), 50, 5, Color( 0, 255, 255 ) )
	end

	function ENT:Think()
		return false
	end

	function ENT:OnTakeDamage( dmginfo )
	end

	function ENT:UpdateTransmitState() 
		return TRANSMIT_ALWAYS
	end

	return
end

ENT._oldEnActive = false
ENT._ActiveSounds = {}

function ENT:Initialize()
end

function ENT:StopSounds()
	for id, sound in pairs( self._ActiveSounds ) do
		if istable( sound ) then
			for _, snd in pairs( sound ) do
				if snd then
					snd:Stop()
				end
			end
		else
			sound:Stop()
		end
		self._ActiveSounds[ id ] = nil
	end
end

function ENT:OnEngineActiveChanged( Active )
	if not Active then self:StopSounds() return end

	local ply = LocalPlayer()
	local ViewPos = ply:GetViewEntity():GetPos()
	local veh = ply:lvsGetVehicle()

	local ActiveCarsInRange = 0

	if IsValid( veh ) then
		ActiveCarsInRange = 999
	else
		for _, ent in pairs( LVS:GetVehicles() ) do
			if ent.Base ~= "lvs_base_wheeldrive" or not ent:GetEngineActive() then continue end

			if ent:GetAI() then
				ActiveCarsInRange = ActiveCarsInRange + 1

				continue
			end

			if (ent:GetPos() - ViewPos):Length() > 1000 then continue end

			ActiveCarsInRange = ActiveCarsInRange + 1
		end
	end

	local DrivingMe = veh == self:GetBase() or ActiveCarsInRange <= 1

	for id, data in pairs( self.EngineSounds ) do
		if not isstring( data.sound ) then continue end

		self.EngineSounds[ id ].Pitch = data.Pitch or 100
		self.EngineSounds[ id ].Volume = data.Volume or 1
		self.EngineSounds[ id ].UseDoppler = data.UseDoppler ~= false
		self.EngineSounds[ id ].SoundLevel = data.SoundLevel or 85

		if data.sound_int and data.sound_int ~= data.sound and DrivingMe then
			local sound = CreateSound( self, data.sound )
			sound:SetSoundLevel( data.SoundLevel )
			sound:PlayEx(0,100)

			if data.sound_int == "" then
				self._ActiveSounds[ id ] = {
					ext = sound,
					int = false,
				}
			else
				local sound_interior = CreateSound( self, data.sound_int )
				sound_interior:SetSoundLevel( data.SoundLevel )
				sound_interior:PlayEx(0,100)

				self._ActiveSounds[ id ] = {
					ext = sound,
					int = sound_interior,
				}
			end
		else
			if DrivingMe or data.SoundLevel >= 90 then
				local sound = CreateSound( self, data.sound )
				sound:SetSoundLevel( data.SoundLevel )
				sound:PlayEx(0,100)

				self._ActiveSounds[ id ] = sound
			end
		end
	end
end

function ENT:HandleEngineSounds( vehicle )
	local ply = LocalPlayer()
	local pod = ply:GetVehicle()
	local Throttle = vehicle:GetThrottle()
	local Doppler = vehicle:CalcDoppler( ply )

	local DrivingMe = ply:lvsGetVehicle() == vehicle

	local VolumeSetNow = false

	local FirstPerson = false
	if IsValid( pod ) then
		local ThirdPerson = pod:GetThirdPersonMode()

		if ThirdPerson ~= self._lvsoldTP then
			self._lvsoldTP = ThirdPerson
			VolumeSetNow = DrivingMe
		end

		FirstPerson = DrivingMe and not ThirdPerson
	end

	if DrivingMe ~= self._lvsoldDrivingMe then
		self._lvsoldDrivingMe = DrivingMe

		self:StopSounds()

		self._oldEnActive = nil

		return
	end

	local T = CurTime()

	local Vel = vehicle:GetVelocity():Length()
	local wheelVel = vehicle:GetWheelVelocity()

	local Wobble = 0

	if Vel / wheelVel <= 0.8 then
		Vel = wheelVel
		Wobble = -1
	end

	local MaxVel = vehicle.MaxVelocity

	local NumGears = vehicle.TransmissionGears

	local VolumeValue = (DrivingMe and 1 or 0.5) * LVS.EngineVolume
	local PitchValue = MaxVel / NumGears

	local DesiredGear = 1
	local VelocityGeared = Vel

	while (VelocityGeared > PitchValue) and DesiredGear< NumGears  do
		VelocityGeared = VelocityGeared - PitchValue

		DesiredGear = DesiredGear + 1
	end

	local CurrentGear = math.Clamp(self._CurGear or 1,1,NumGears)

	local Ratio = math.Clamp(Vel - (CurrentGear - 1) * PitchValue,0,PitchValue) / PitchValue

	if self._CurGear ~= DesiredGear then
		if (self._NextShift or 0) < T then
			self._NextShift = T + 1

			if (self._CurGear or 0) < DesiredGear then
				self._ShiftTime = T + 0.2

				vehicle:SuppressViewPunch( 0.2 )
			end
			self._CurGear = DesiredGear
		end
	end

	if Wobble == 0 and CurrentGear < (1 + (NumGears - 1) * Throttle) then
		Wobble = math.cos( T * (20 + CurrentGear * 10) * Throttle ) * math.max(1 - Ratio,0) * Throttle * 60
	end

	local FadeSpeed = 0.15

	if (self._ShiftTime or 0) > T then
		PitchAdd = 0
		Ratio = 0
		Wobble = 0
		Throttle = 0.1
		FadeSpeed = 3
	end

	for id, sound in pairs( self._ActiveSounds ) do
		if not sound then continue end

		local data = self.EngineSounds[ id ]

		local Vol03 = data.Volume * 0.3
		local Vol02 = data.Volume * 0.2

		local Volume = (Vol03 + Vol02 * Ratio + (Vol02 * Ratio + Vol03) * Throttle) * VolumeValue

		local PitchAdd = CurrentGear * (data.Pitch / NumGears * 0.6)

		local Pitch = data.Pitch + PitchAdd + (data.Pitch - PitchAdd) * Ratio + Wobble
		local PitchMul = data.UseDoppler and Doppler or 1

		if istable( sound ) then
			sound.ext:ChangePitch( math.Clamp( Pitch * PitchMul, 0, 255 ), FadeSpeed )
	
			if sound.int then
				sound.int:ChangePitch( math.Clamp( Pitch, 0, 255 ), FadeSpeed )
			end

			local fadespeed = VolumeSetNow and 0 or 0.15

			if FirstPerson then
				sound.ext:ChangeVolume( 0, 0 )

				if vehicle:HasActiveSoundEmitters() then
					Volume = Volume * 0.25
					fadespeed = fadespeed * 0.5
				end

				if sound.int then sound.int:ChangeVolume( Volume, fadespeed ) end
			else
				sound.ext:ChangeVolume( Volume, fadespeed )
				if sound.int then sound.int:ChangeVolume( 0, 0 ) end
			end
		else
			sound:ChangePitch( math.Clamp( Pitch * PitchMul, 0, 255 ), FadeSpeed )
			sound:ChangeVolume( Volume, 0.15 )
		end
	end
end

function ENT:Think()
	local vehicle = self:GetBase()

	if not IsValid( vehicle ) then return end

	self:DamageFX( vehicle )

	if not self.EngineSounds then
		self.EngineSounds = vehicle.EngineSounds

		return
	end

	local EngineActive = vehicle:GetEngineActive()

	if self._oldEnActive ~= EngineActive then
		self._oldEnActive = EngineActive

		self:OnEngineActiveChanged( EngineActive )
	end

	if EngineActive then
		self:HandleEngineSounds( vehicle )
	end
end

function ENT:OnRemove()
	self:StopSounds()
end

function ENT:Draw()
end

function ENT:DrawTranslucent()
end

function ENT:DamageFX( vehicle )
	local T = CurTime()
	local HP = vehicle:GetHP()
	local MaxHP = vehicle:GetMaxHP() 

	if HP <= 0 or HP > MaxHP * 0.5 or (self.nextDFX or 0) > T then return end

	self.nextDFX = T + 0.05

	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		effectdata:SetEntity( vehicle )
	util.Effect( "lvs_engine_blacksmoke", effectdata )
end

