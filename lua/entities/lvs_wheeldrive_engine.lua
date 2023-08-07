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

	for id, data in pairs( self.EngineSounds ) do
		if not isstring( data.sound ) then continue end

		self.EngineSounds[ id ].Pitch = data.Pitch or 100
		self.EngineSounds[ id ].PitchMul = data.PitchMul or 100
		self.EngineSounds[ id ].Volume = data.Volume or 1
		self.EngineSounds[ id ].SoundType = data.SoundType or LVS.SOUNDTYPE_NONE
		self.EngineSounds[ id ].UseDoppler = data.UseDoppler ~= false
		self.EngineSounds[ id ].SoundLevel = data.SoundLevel or 85

		if data.sound_int and data.sound_int ~= data.sound then
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
			local sound = CreateSound( self, data.sound )
			sound:SetSoundLevel( data.SoundLevel )
			sound:PlayEx(0,100)

			self._ActiveSounds[ id ] = sound
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

	local FT = RealFrameTime()
	local T = CurTime()

	local Reverse = vehicle:GetReverse()
	local vehVel = vehicle:GetVelocity():Length()
	local wheelVel = vehicle:GetWheelVelocity()

	local Vel = 0
	local Wobble = 0

	if vehVel / wheelVel <= 0.8 then
		Vel = wheelVel
		Wobble = -1
	else
		Vel = vehVel
	end

	local NumGears = vehicle.TransGears

	local VolumeValue = (DrivingMe and 1 or 0.4) * LVS.EngineVolume
	local PitchValue = vehicle.MaxVelocity / NumGears

	local DesiredGear = 1

	local subGeared = vehVel - (self._smVelGeared or 0)
	local VelocityGeared = vehVel


	--[[ workaround ]]-- TODO: Fix it properly
	if vehicle:Sign( subGeared ) < 0 then
		self._smVelGeared = (self._smVelGeared or 0) + subGeared * FT * 5
		VelocityGeared = self._smVelGeared
	else
		self._smVelGeared = VelocityGeared 
	end
	--[[ workaround ]]--


	while (VelocityGeared > PitchValue) and DesiredGear< NumGears do
		VelocityGeared = VelocityGeared - PitchValue

		DesiredGear = DesiredGear + 1
	end

	DesiredGear = math.Clamp( DesiredGear, 1, Reverse and vehicle.TransGearsReverse or NumGears )

	local CurrentGear = math.Clamp(self._CurGear or 1,1,NumGears)

	local Ratio = (math.Clamp(Vel - (CurrentGear - 1) * PitchValue,0, PitchValue) / PitchValue) * (0.5 + (Throttle ^ 2) * 0.5)

	if self._CurGear ~= DesiredGear then
		if (self._NextShift or 0) < T then
			self._NextShift = T + vehicle.TransMinGearHoldTime

			if (self._CurGear or 0) < DesiredGear then
				self._ShiftTime = T + vehicle.TransShiftSpeed
			end

			vehicle:OnChangeGear( (self._CurGear or 0), DesiredGear )

			self._CurGear = DesiredGear
		end
	end

	if Wobble == 0 and Throttle >= 0.75 and CurrentGear < math.floor( NumGears * 0.75 ) then
		Wobble = (math.cos( T * (20 + CurrentGear * 10) * Throttle * vehicle.TransWobbleFrequencyMultiplier ) * math.max(1 - Ratio,0) * Throttle * vehicle.TransWobble * math.max(1 - vehicle:AngleBetweenNormal( vehicle:GetUp(), Vector(0,0,1) ) / 5,0) ^ 2)
	end

	local FadeSpeed = 0.15

	local PlayIdleSound = CurrentGear == 1 and Throttle == 0 and Ratio < 0.5
	local rpmRate = PlayIdleSound and 1 or 5

	self._smIdleVolume = self._smIdleVolume and self._smIdleVolume + ((PlayIdleSound and 1 or 0) - self._smIdleVolume) * FT or 0
	self._smRPMVolume = self._smRPMVolume and self._smRPMVolume + ((PlayIdleSound and 0 or 1) - self._smRPMVolume) * FT * rpmRate or 0

	if (self._ShiftTime or 0) > T or PlayIdleSound then
		PitchAdd = 0
		Ratio = 0
		Wobble = 0
		Throttle = 0
		FadeSpeed = PlayIdleSound and 0.25 or 3
	end

	for id, sound in pairs( self._ActiveSounds ) do
		if not sound then continue end

		local data = self.EngineSounds[ id ]

		local Vol03 = data.Volume * 0.3
		local Vol02 = data.Volume * 0.2

		local Volume = (Vol02 + Vol03 * Ratio + (Vol02 * Ratio + Vol03) * Throttle) * VolumeValue * self._smRPMVolume

		local PitchAdd = CurrentGear * (data.PitchMul / NumGears * 0.6)

		local Pitch = data.Pitch + PitchAdd + (data.PitchMul - PitchAdd) * Ratio + Wobble
		local PitchMul = data.UseDoppler and Doppler or 1

		if data.SoundType ~= LVS.SOUNDTYPE_NONE then
			if data.SoundType == LVS.SOUNDTYPE_IDLE_ONLY then
				Volume = self._smIdleVolume * data.Volume * VolumeValue
				Pitch = data.Pitch + data.PitchMul * Ratio
			end

			if data.SoundType == LVS.SOUNDTYPE_REV_UP then
				Volume = Throttle == 0 and 0 or Volume
			end

			if data.SoundType == LVS.SOUNDTYPE_REV_DOWN then
				Volume =  Throttle == 0 and Volume or 0
			end
		end

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

