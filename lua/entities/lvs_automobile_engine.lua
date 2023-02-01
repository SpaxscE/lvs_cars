AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "Engine"
ENT.Author = "Luna"
ENT.Category = "[LVS]"

ENT.Spawnable       = true
ENT.AdminSpawnable  = false
ENT.DoNotDuplicate = true

ENT._LVS = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 0, "Base" )

	--[[
	self:NetworkVar( "Int",1, "HP" )

	if SERVER then
		self:SetHP( 100 )
	end
	]]
end

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )
		if not tr.Hit then return end

		local ent = ents.Create( ClassName )
		ent:SetPos( tr.HitPos + tr.HitNormal * 15 )
		ent:Spawn()
		ent:Activate()

		return ent
	end

	function ENT:Initialize()
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		self:DrawShadow( false )

		debugoverlay.Cross( self:GetPos(), 15, 5, Color( 0, 255, 255 ) )
	end

	function ENT:Think()	
		return false
	end

	function ENT:PhysicsCollide( data )
	end

	function ENT:OnTakeDamage( dmginfo )	
	end
else
	function ENT:Initialize()
	end

	function ENT:Think()
	end

	function ENT:OnRemove()
	end

	function ENT:Draw()
	end

	function ENT:DrawTranslucent()
	end
end