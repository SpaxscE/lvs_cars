AddCSLuaFile()

ENT.Type            = "anim"

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )
		if not tr.Hit then return end

		local ent = ents.Create( ClassName )
		ent:SetPos( tr.HitPos + tr.HitNormal * 5 )
		ent:Spawn()
		ent:Activate()

		return ent
	end

	ENT.LifeTime = 30

	function ENT:Initialize()	
		self:SetModel( "models/props_debris/shellcasing_single1.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:PhysWake()
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self:SetRenderMode( RENDERMODE_TRANSALPHA )

		self.DieTime = CurTime() + self.LifeTime

		timer.Simple( self.LifeTime - 0.5, function()
			if not IsValid( self ) then return end

			self:SetRenderFX( kRenderFxFadeFast  ) 
		end)
	end

	function ENT:Think()
		if self.DieTime < CurTime() then
			self:Remove()
		end

		self:NextThink( CurTime() + 1 )

		return true
	end

	function ENT:PhysicsCollide( data, physobj )
		if data.Speed > 30 and data.DeltaTime > 0.2 then
			self:EmitSound( "lvs/vehicles/pak40/shell_impact"..math.random(1,2)..".wav" )
		end
	end

	return
end

function ENT:Draw()
	self:DrawModel()
end
