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

	function ENT:CheckWater( Base )
		if bit.band( util.PointContents( self:GetPos() ), CONTENTS_WATER ) ~= CONTENTS_WATER then
			if self.CountWater then
				self.CountWater = nil
			end

			return
		end

		if Base.WaterLevelAutoStop > 3 then return end

		self.CountWater = (self.CountWater or 0) + 1

		if self.CountWater < 4 then return end

		Base:StopEngine()
	end

	function ENT:Think()

		local Base = self:GetBase()

		if IsValid( Base ) and Base:GetEngineActive() then
			self:CheckWater( Base )
		end

		self:NextThink( CurTime() + 1 )

		return true
	end

	function ENT:OnTakeDamage( dmginfo )
	end

	function ENT:UpdateTransmitState() 
		return TRANSMIT_ALWAYS
	end

	function ENT:OnRemove()
		local base = self:GetBase()

		if not IsValid( base ) or base.ExplodedAlready then return end

		base:SetMaxThrottle( 1 )
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

function ENT:SetGear( newgear )
	self._CurGear = newgear
end

function ENT:GetGear()
	return (self._CurGear or 1)
end

function ENT:SetRPM( rpm )
	self._CurRPM = rpm
end

function ENT:GetRPM()
	return (self._CurRPM or 0)
end

function ENT:GetClutch()
	return self._ClutchActive == true
end

function ENT:SetEngineVolume( volume )
	self._engineVolume = volume

	return volume
end

function ENT:GetEngineVolume()
	return (self._engineVolume or 0)
end

function ENT:HandleEngineSounds( vehicle )
	local ply = LocalPlayer()
	local pod = ply:GetVehicle()
	local Throttle = vehicle:GetThrottle()
	local MaxThrottle = vehicle:GetMaxThrottle()
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

	local VolumeValue = self:SetEngineVolume( LVS.EngineVolume )
	local PitchValue = vehicle.MaxVelocity / NumGears

	local DesiredGear = 1

	local subGeared = vehVel - (self._smVelGeared or 0)
	local VelocityGeared = vehVel

	if wheelVel == 0 and vehicle:GetNWHandBrake() then
		VelocityGeared = PitchValue * Throttle
		Vel = VelocityGeared
	end

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

	local CurrentGear = math.Clamp(self:GetGear(),1,NumGears)

	local Ratio = (math.Clamp(Vel - (CurrentGear - 1) * PitchValue,0, PitchValue) / PitchValue) * (0.5 + (Throttle ^ 2) * 0.5)

	if CurrentGear ~= DesiredGear then
		if (self._NextShift or 0) < T then
			self._NextShift = T + vehicle.TransMinGearHoldTime

			if CurrentGear < DesiredGear then
				self._ShiftTime = T + vehicle.TransShiftSpeed
				self._WobbleTime = T + vehicle.TransWobbleTime
			end

			vehicle:OnChangeGear( CurrentGear, DesiredGear )

			self:SetGear( DesiredGear )
		end
	end

	if Throttle > 0.5 then
		local FullThrottle = Throttle >= 0.99

		if self._oldFullThrottle ~= FullThrottle then
			self._oldFullThrottle = FullThrottle

			if FullThrottle then
				self._WobbleTime = T + vehicle.TransWobbleTime
			end
		end

		if Wobble == 0 then
			local Mul = math.Clamp( (self._WobbleTime or 0) - T, 0, 1 )

			Wobble = (math.cos( T * (20 + CurrentGear * 10) * vehicle.TransWobbleFrequencyMultiplier ) * math.max(1 - Ratio,0) * vehicle.TransWobble * math.max(1 - vehicle:AngleBetweenNormal( vehicle:GetUp(), Vector(0,0,1) ) / 5,0) ^ 2) * Mul 
		end
	end

	local FadeSpeed = 0.15
	local PlayIdleSound = CurrentGear == 1 and Throttle == 0 and Ratio < 0.5
	local rpmSet = false
	local rpmRate = PlayIdleSound and 1 or 5

	self._smIdleVolume = self._smIdleVolume and self._smIdleVolume + ((PlayIdleSound and 1 or 0) - self._smIdleVolume) * FT or 0
	self._smRPMVolume = self._smRPMVolume and self._smRPMVolume + ((PlayIdleSound and 0 or 1) - self._smRPMVolume) * FT * rpmRate or 0

	if (self._ShiftTime or 0) > T or PlayIdleSound then
		PitchAdd = 0
		Ratio = 0
		Wobble = 0
		Throttle = 0
		FadeSpeed = PlayIdleSound and 0.25 or 3
		self._ClutchActive = true
	else
		self._ClutchActive = false
	end

	if not self.EnginePitchStep then
		self.EnginePitchStep = math.Clamp(vehicle.EngineMaxRPM / 10000, 0.6, 0.98)

		return
	end

	for id, sound in pairs( self._ActiveSounds ) do
		if not sound then continue end

		local data = self.EngineSounds[ id ]

		local Vol03 = data.Volume * 0.3
		local Vol02 = data.Volume * 0.2

		local Volume = (Vol02 + Vol03 * Ratio + (Vol02 * Ratio + Vol03) * Throttle) * VolumeValue

		local PitchAdd = CurrentGear * (data.PitchMul / NumGears * self.EnginePitchStep) * MaxThrottle

		local Pitch = data.Pitch + PitchAdd + (data.PitchMul - PitchAdd) * Ratio + Wobble
		local PitchMul = data.UseDoppler and Doppler or 1

		local SoundType = data.SoundType

		if SoundType ~= LVS.SOUNDTYPE_ALL then
			Volume = Volume  * self._smRPMVolume

			if SoundType == LVS.SOUNDTYPE_IDLE_ONLY then
				Volume = self._smIdleVolume * data.Volume * VolumeValue
				Pitch = data.Pitch + data.PitchMul * Ratio
			end

			if SoundType == LVS.SOUNDTYPE_REV_UP then
				Volume = Throttle == 0 and 0 or Volume
			end

			if SoundType == LVS.SOUNDTYPE_REV_DOWN then
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

		if rpmSet then continue end

		if PlayIdleSound then self:SetRPM( vehicle.EngineIdleRPM ) rpmSet = true continue end

		if data.SoundType == LVS.SOUNDTYPE_IDLE_ONLY then continue end

		if istable( sound ) then
			if sound.int then
				rpmSet = true
				self:SetRPM( ((sound.int:GetPitch() - data.Pitch) / data.PitchMul) * vehicle.EngineMaxRPM )
			else
				if not sound.ext then continue end

				rpmSet = true
				self:SetRPM( ((sound.ext:GetPitch() - data.Pitch) / data.PitchMul) * vehicle.EngineMaxRPM )
			end
		else
			rpmSet = true
			self:SetRPM( ((sound:GetPitch() - data.Pitch) / data.PitchMul) * vehicle.EngineMaxRPM )
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
		self:ExhaustFX( vehicle )
	end
end

function ENT:RemoveFireSound()
	if self.FireBurnSND then
		self.FireBurnSND:Stop()
		self.FireBurnSND = nil
	end

	self.ShouldStopFire = nil
end

function ENT:StopFireSound()
	if self.ShouldStopFire or not self.FireBurnSND then return end

	self.ShouldStopFire = true

	self:EmitSound("ambient/fire/mtov_flame2.wav")

	self.FireBurnSND:ChangeVolume( 0, 0.5 )

	timer.Simple( 1, function()
		if not IsValid( self ) then return end

		self:RemoveFireSound()
	end )
end

function ENT:StartFireSound()
	if self.ShouldStopFire or self.FireBurnSND then return end

	self.FireBurnSND = CreateSound( self, "ambient/fire/firebig.wav" )
	self.FireBurnSND:PlayEx(0,100)
	self.FireBurnSND:ChangeVolume( LVS.EngineVolume, 1 )

	self:EmitSound("ambient/fire/ignite.wav")
end

function ENT:OnRemove()
	self:StopSounds()
	self:RemoveFireSound()
end

function ENT:Draw()
end

function ENT:DrawTranslucent()
end

function ENT:ExhaustFX( vehicle )
	if not istable( vehicle.ExhaustPositions ) then return end

	local T = CurTime()

	if (self.nextEFX or 0) > T then return end

	self.nextEFX = T + 0.1

	vehicle:DoExhaustFX( (self:GetRPM() / vehicle.EngineMaxRPM) * 0.5 + 0.5 * vehicle:GetThrottle() )
end

function ENT:DamageFX( vehicle )
	local T = CurTime()
	local HP = vehicle:GetHP()
	local MaxHP = vehicle:GetMaxHP() 

	if HP <= 0 or HP > MaxHP * 0.5 then self:StopFireSound() return end

	if HP > MaxHP * 0.25 then
		self:StopFireSound()
	else
		self:StartFireSound()
	end

	if (self.nextDFX or 0) > T then return end

	self.nextDFX = T + 0.05

	if HP > MaxHP * 0.25 then
		local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
			effectdata:SetEntity( vehicle )
			effectdata:SetMagnitude( math.max(HP - MaxHP * 0.25,0) / (MaxHP * 0.25) )
		util.Effect( "lvs_carengine_smoke", effectdata )
	else
		local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
			effectdata:SetEntity( vehicle )
		util.Effect( "lvs_carengine_fire", effectdata )
	end
end

