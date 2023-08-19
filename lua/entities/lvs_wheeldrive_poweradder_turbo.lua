AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "Turbro"
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
		self:SetModel("models/diggercars/dodge_charger/turbo.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:PhysWake()
	end

	function ENT:Think()
		return false
	end

	function ENT:PhysicsCollide( data )
		local ent = data.HitEntity

		if not IsValid( ent ) or not ent.LVS or not ent.AllowTurbo or IsValid( ent.TurboEnt ) then return end

		local engine = ent:GetEngine()

		if not IsValid( engine ) then return end

		self:PhysicsDestroy()
		self:SetSolid( SOLID_NONE )
		self:SetMoveType( MOVETYPE_NONE )

		self:SetPos( engine:GetPos() )
		self:SetAngles( engine:LocalToWorldAngles( Angle(0,-90,0) ) )

		self:SetParent( engine )

		self:SetBase( ent )

		ent.TurboEnt = self
	end

	return
end

function ENT:Initialize()
end

function ENT:Think()
end

function ENT:OnRemove()
end

function ENT:Draw()
	self:DrawModel()
end
