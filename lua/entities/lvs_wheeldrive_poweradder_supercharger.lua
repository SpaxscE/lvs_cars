AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "Supercharger"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars - Items"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.DoNotDuplicate = true

ENT._LVS = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )
end

if SERVER then
	function ENT:Initialize()	
		self:SetModel("models/diggercars/dodge_charger/blower.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:PhysWake()
	end

	function ENT:Think()
		return false
	end

	function ENT:PhysicsCollide( data )
		local ent = data.HitEntity

		if not IsValid( ent ) or not ent.LVS or not ent.AllowSuperCharger or IsValid( ent.SuperChargerEnt ) then return end

		local engine = ent:GetEngine()

		if not IsValid( engine ) then return end

		self:PhysicsDestroy()
		self:SetSolid( SOLID_NONE )
		self:SetMoveType( MOVETYPE_NONE )

		self:SetPos( engine:GetPos() )
		self:SetAngles( engine:LocalToWorldAngles( Angle(0,-90,0) ) )

		self:SetParent( engine )

		self:SetBase( ent )

		ent:OnSuperCharged( true )
	
		ent.SuperChargerEnt = self
	end

	function ENT:OnRemove()
		local base = self:GetBase()

		if not IsValid( base ) or base.ExplodedAlready then return end

		base:OnSuperCharged( false )
	end

	return
end

function ENT:Initialize()
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:StartSounds()
	else
		self:StopSounds()
	end
end

function ENT:StartSounds()
	if self.snd then return end

	self.snd = CreateSound( self, "lvs/vehicles/generic/supercharger_loop.wav" )
	self.snd:PlayEx(0,100)
end

function ENT:StopSounds()
	if not self.snd then return end

	self.snd:Stop()
	self.snd = nil
end

function ENT:HandleSounds( vehicle, engine )
	if not self.snd then return end

	local throttle = engine:GetClutch() and 0 or vehicle:GetThrottle()
	local volume = (0.2 + math.max( math.sin( math.rad( ((engine:GetRPM() - vehicle.EngineIdleRPM) / (vehicle.EngineMaxRPM - vehicle.EngineIdleRPM)) * 90 ) ), 0 ) * 0.8) * throttle
	local pitch = engine:GetRPM() / vehicle.EngineMaxRPM

	local ply = LocalPlayer()
	local doppler = vehicle:CalcDoppler( ply )

	self.snd:ChangeVolume( volume * LVS.EngineVolume )
	self.snd:ChangePitch( (60 + pitch * 85) * doppler )
end

function ENT:Think()
	local vehicle = self:GetBase()

	if not IsValid( vehicle ) then return end

	local EngineActive = vehicle:GetEngineActive()

	if self._oldEnActive ~= EngineActive then
		self._oldEnActive = EngineActive

		self:OnEngineActiveChanged( EngineActive )
	end

	if EngineActive then
		local engine = vehicle:GetEngine()

		if not IsValid( engine ) then return end

		self:HandleSounds( vehicle, engine )
	end
end

function ENT:OnRemove()
	self:StopSounds()
end

function ENT:Draw()
	if IsValid( self:GetBase() ) then return end

	self:DrawModel()
end
