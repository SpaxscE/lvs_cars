AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "Supercharger"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars - Items"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.DoNotDuplicate = true

ENT._LVS = true

ENT.Editable = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )

	self:NetworkVar( "Float",0, "EngineCurve", { KeyName = "addpower", Edit = { type = "Float",	 order = 1,min = 0, max = 0.5, category = "Upgrade Settings"} } )
	self:NetworkVar( "Int",1, "EngineTorque", { KeyName = "addtorque", Edit = { type = "Int", order = 2,min = 0, max = 100, category = "Upgrade Settings"} } )

	self:NetworkVar( "Bool",0, "Visible", { KeyName = "modelvisible",	 Edit = { type = "Boolean",	order = 0,	category = "Visuals"} } )

	if SERVER then
		self:SetEngineCurve( 0.25 )
		self:SetEngineTorque( 50 )

		self:NetworkVarNotify( "EngineCurve", self.OnEngineCurveChanged )
		self:NetworkVarNotify( "EngineTorque", self.OnEngineTorqueChanged )
	end
end

function ENT:GetBoost()
	if not self._smBoost then return 0 end

	return self._smBoost
end

if SERVER then
	function ENT:Initialize()	
		self:SetModel("models/diggercars/dodge_charger/blower_animated.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:PhysWake()
	end

	function ENT:Think()
		return false
	end

	function ENT:LinkTo( ent )
		if not IsValid( ent ) or not ent.LVS or not ent.AllowSuperCharger or IsValid( ent:GetCompressor() ) then return end

		local engine = ent:GetEngine()

		if not IsValid( engine ) then return end

		self:PhysicsDestroy()
		self:SetSolid( SOLID_NONE )
		self:SetMoveType( MOVETYPE_NONE )

		self:SetPos( engine:GetPos() )
		self:SetAngles( engine:GetAngles() )

		self:SetParent( engine )

		self:SetBase( ent )

		ent.EngineCurve = ent.EngineCurve + self:GetEngineCurve()
		ent.EngineTorque = ent.EngineTorque + self:GetEngineTorque()
		self:UpdateVehicle()

		ent:OnSuperCharged( true )
	
		ent:SetCompressor( self )
	end

	function ENT:PhysicsCollide( data )
		self:LinkTo( data.HitEntity )
	end

	function ENT:OnRemove()
		local base = self:GetBase()

		if not IsValid( base ) or base.ExplodedAlready then return end

		base.EngineCurve = base.EngineCurve - self:GetEngineCurve()
		base.EngineTorque = base.EngineTorque - self:GetEngineTorque()
		self:UpdateVehicle()

		base:OnSuperCharged( false )
	end

	function ENT:OnEngineCurveChanged( name, old, new )
		if old == new then return end

		local ent = self:GetBase()

		if not IsValid( ent ) then return end

		ent.EngineCurve = ent.EngineCurve - old + new

		self:UpdateVehicle()
	end

	function ENT:OnEngineTorqueChanged( name, old, new )
		if old == new then return end

		local ent = self:GetBase()

		if not IsValid( ent ) then return end

		ent.EngineTorque = ent.EngineTorque - old + new

		self:UpdateVehicle()
	end

	function ENT:UpdateVehicle()
		local ent = self:GetBase()

		if not IsValid( ent ) then return end

		net.Start( "lvs_car_performanceupdates" )
			net.WriteEntity( ent )
			net.WriteFloat( ent.EngineCurve )
			net.WriteInt( ent.EngineTorque, 14 )
		net.Broadcast()
	end

	return
end

function ENT:Initialize()
end

function ENT:OnEngineActiveChanged( Active, soundname )
	if Active then
		self:StartSounds( soundname )
	else
		self:StopSounds()
	end
end

function ENT:StartSounds( soundname )
	if self.snd then return end

	self.snd = CreateSound( self, soundname )
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
	local volume = (0.2 + math.max( math.sin( math.rad( ((engine:GetRPM() - vehicle.EngineIdleRPM) / (vehicle.EngineMaxRPM - vehicle.EngineIdleRPM)) * 90 ) ), 0 ) * 0.8) * throttle * vehicle.SuperChargerVolume
	local pitch = engine:GetRPM() / vehicle.EngineMaxRPM

	local ply = LocalPlayer()
	local doppler = vehicle:CalcDoppler( ply )

	self._smBoost = self._smBoost and self._smBoost + (volume - self._smBoost) * FrameTime() * 5 or 0

	self.snd:ChangeVolume( volume * LVS.EngineVolume )
	self.snd:ChangePitch( (60 + pitch * 85) * doppler )
end

function ENT:Think()
	local vehicle = self:GetBase()

	if not IsValid( vehicle ) then return end

	local EngineActive = vehicle:GetEngineActive()

	if self._oldEnActive ~= EngineActive then
		self._oldEnActive = EngineActive

		self:OnEngineActiveChanged( EngineActive, vehicle.SuperChargerSound )
	end

	if EngineActive then
		local engine = vehicle:GetEngine()

		if not IsValid( engine ) then return end

		self:SetPoseParameter( "throttle_pedal", math.max( vehicle:GetThrottle() - (engine:GetClutch() and 1 or 0), 0 ) )
		self:InvalidateBoneCache()

		self:HandleSounds( vehicle, engine )
	end
end

function ENT:OnRemove()
	self:StopSounds()
end

function ENT:Draw()
	local vehicle = self:GetBase()

	if not IsValid( vehicle ) then
		self:DrawModel()

		return
	end

	if not vehicle.SuperChargerVisible then return end

	if not self:GetVisible() then return end

	self:DrawModel()
end
