AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "Explosive"
ENT.Author = "Luna"
ENT.Category = "[LVS] - Cars - Items"

ENT.Spawnable		= true
ENT.AdminOnly		= false

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )
		if not tr.Hit then return end

		local ent = ents.Create( ClassName )
		ent:SetPos( tr.HitPos + tr.HitNormal * 5 )
		ent:Spawn()
		ent:Activate()

		return ent
	end

	function ENT:Initialize()	
		self:SetModel( "models/Items/grenadeAmmo.mdl" )

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		self:SetCollisionGroup( COLLISION_GROUP_NONE )
	end

	function ENT:Think()	
		return false
	end

	function ENT:PhysicsCollide( data, physobj )
		if data.Speed > 60 and data.DeltaTime > 0.2 then
			local VelDif = data.OurOldVelocity:Length() - data.OurNewVelocity:Length()

			if VelDif > 200 then
				self:EmitSound( "Grenade.ImpactHard" )
			else
				self:EmitSound( "Grenade.ImpactSoft" )
			end

			physobj:SetVelocity( data.OurOldVelocity * 0.5 )
		end
	end
else
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:Think()
	end

	function ENT:OnRemove()
	end
end