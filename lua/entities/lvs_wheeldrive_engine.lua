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

	local sound = CreateSound( self, "lvs/vehicles/kuebelwagen/engine_mid.wav" )
	sound:SetSoundLevel( 75 )
	sound:PlayEx(0,100)
	self._ActiveSounds[ 1 ] = sound

	local sound = CreateSound( self, "acf_extra/vehiclefx/engines/flat4/vw.wav" )
	sound:SetSoundLevel( 75 )
	sound:PlayEx(0,100)
	self._ActiveSounds[ 2 ] = sound
end


function ENT:HandleEngineSounds( vehicle )
	local ply = LocalPlayer()

	local Throttle = vehicle:GetThrottle()
	local Doppler = vehicle:CalcDoppler( ply )

	local DrivingMe = ply:lvsGetVehicle() == vehicle

	local T = CurTime()

	local Vel = vehicle:GetVelocity():Length()
	local MaxVel = vehicle.MaxVelocity

	local NumGears = 4

	local VelStuff = MaxVel / NumGears

	local CurGear = 1
	local VelTheoretical = Vel

	while (VelTheoretical > VelStuff) and CurGear< NumGears  do
		VelTheoretical = VelTheoretical - VelStuff

		CurGear = CurGear + 1
	end

	local Ratio = math.Clamp(Vel - (self._oldGear - 1) * VelStuff,0,VelStuff) / VelStuff

	local PitchAdd = CurGear * (100 / NumGears * 0.6)

	if self._oldGear ~= CurGear then

		if (self._NextShift or 0) < T then
			self._NextShift = T + 1

			if (self._oldGear or 0) < CurGear then
				self._ShiftTime = T + 0.2

				vehicle:Test()
			else
				if CurGear <= 2 then
					self._GoIdle = true
				end
			end

			self._oldGear = CurGear
		end
	end

	if Throttle ~= 0 then
		self._GoIdle = nil
	else
		if CurGear == 1 and Throttle == 0 then
			self._GoIdle = true
		end
	end

	local Wobble = 0
	if CurGear < (1 + (NumGears - 1) * Throttle) then
		Wobble = math.cos( T * (20 + CurGear * 10) * Throttle ) * math.max(1 -Ratio,0) * Throttle * 60
	end

	local FadeSpeed = 0.15

	if (self._ShiftTime or 0) > T then
		PitchAdd = 0
		Ratio = 0
		Wobble = 0
		Throttle = 0.1
		FadeSpeed = 3
	end

	local Pitch = 100 + PitchAdd + (100 - PitchAdd) * Ratio + Wobble

	local Mul = DrivingMe and 1 or 0.5

	local Volume = (0.3 + 0.2 * Ratio + (0.2 * Ratio + 0.3) * Throttle) * Mul

	if self._GoIdle then
		Pitch = 100
		Volume = 0
	end

	for id, sound in pairs( self._ActiveSounds ) do
		if not sound then continue end
		if id == 1 then
			sound:ChangeVolume( Volume, 0.15 )
			sound:ChangePitch( Pitch, FadeSpeed )
		else
			local ASDF = self._GoIdle and 1 or 0
			sound:ChangeVolume( ASDF, 0.25 )
			sound:ChangePitch( 40, 0.15 )
		end
	end
end

function ENT:Think()
	local vehicle = self:GetBase()

	if not IsValid( vehicle ) then return end

	self:DamageFX( vehicle )

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

