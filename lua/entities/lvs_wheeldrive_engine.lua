AddCSLuaFile()

ENT.Type            = "anim"

ENT.Spawnable       = false
ENT.AdminSpawnable  = false
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

	--PrintChat("runs")

	if true then return end

	for id, data in pairs( self.EngineSounds ) do
		if not isstring( data.sound ) then continue end

		self.EngineSounds[ id ].Pitch = data.Pitch or 80
		self.EngineSounds[ id ].PitchMin = data.PitchMin or 0
		self.EngineSounds[ id ].PitchMax = data.PitchMax or 255
		self.EngineSounds[ id ].PitchMul = data.PitchMul or 100
		self.EngineSounds[ id ].UseDoppler = data.UseDoppler ~= false
		self.EngineSounds[ id ].FadeIn = data.FadeIn or 0
		self.EngineSounds[ id ].FadeOut = data.FadeOut or 1
		self.EngineSounds[ id ].FadeSpeed = data.FadeSpeed or 1.5
		self.EngineSounds[ id ].SoundLevel = data.SoundLevel or 85

		local sound = CreateSound( self, data.sound )
		sound:SetSoundLevel( data.SoundLevel )
		sound:PlayEx(0,100)

		self._ActiveSounds[ id ] = sound
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

	--if EngineActive then
	--	self:HandleEngineSounds( vehicle )
	--end
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

