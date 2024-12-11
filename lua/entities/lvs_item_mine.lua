AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName		= "Mine"
ENT.Author		= "Blu-x92"
ENT.Information		= "Immobilize Tanks"
ENT.Category = "[LVS]"

ENT.Spawnable       = false
ENT.AdminSpawnable  = false

if SERVER then
	function ENT:SetDamage( num ) self._dmg = num end
	function ENT:SetForce( num ) self._force = num end
	function ENT:SetRadius( num ) self._radius = num end
	function ENT:SetAttacker( ent ) self._attacker = ent end

	function ENT:GetAttacker() return self._attacker or NULL end
	function ENT:GetDamage() return (self._dmg or 2000) end
	function ENT:GetForce() return (self._force or 8000) end
	function ENT:GetRadius() return (self._radius or 150) end

	function ENT:SpawnFunction( ply, tr, ClassName )

		if not tr.Hit then return end

		local ent = ents.Create( ClassName )
		ent.Attacker = ply
		ent:SetPos( tr.HitPos + tr.HitNormal )
		ent:Spawn()
		ent:Activate()

		return ent

	end

	function ENT:Initialize()	
		self:SetModel( "models/blu/lvsmine.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON  )

		self.First = true
	end

	function ENT:Use( ply )
	end

	function ENT:Detonate()
		if self.IsExploded then return end

		self.IsExploded = true

		local Pos = self:GetPos()

		local effectdata = EffectData()
		effectdata:SetOrigin( Pos )

		if self:WaterLevel() >= 2 then
			util.Effect( "WaterSurfaceExplosion", effectdata, true, true )
		else
			util.Effect( "lvs_defence_explosion", effectdata )
		end

		local attacker = self:GetAttacker()

		LVS:BlastDamage( Pos, Vector(0,0,1), IsValid( attacker ) and attacker or game.GetWorld(), self, self:GetDamage(), DMG_BLAST, self:GetRadius(), self:GetForce() )

		SafeRemoveEntityDelayed( self, FrameTime() )
	end

	function ENT:Think()
		if self.ShouldDetonate then
			self:Detonate()
		end

		self:NextThink( CurTime() + 0.1 )

		return true
	end

	function ENT:OnRemove()
	end

	function ENT:PhysicsCollide( data, PhysObj )
		local HitEnt = data.HitEntity

		if self.First then
			self.First = nil
			self.IgnoreEnt = HitEnt
		end

		if HitEnt == self.IgnoreEnt then
			if data.Speed > 60 and data.DeltaTime > 0.1 then
				self:EmitSound( "weapon.ImpactHard" )
			end

			return
		end

		PhysObj:SetVelocity( data.OurOldVelocity * 0.5 )

		if not IsValid( HitEnt ) or HitEnt:IsWorld() then 
			if data.Speed > 60 and data.DeltaTime > 0.1 then
				self:EmitSound( "weapon.ImpactHard" )
			end
			
			return
		end

		if not HitEnt:IsPlayer() and PhysObj:GetStress() > 10 and HitEnt:GetClass() ~= self:GetClass() then
			self.ShouldDetonate = true
		else
			if data.Speed > 60 and data.DeltaTime > 0.1 then
				self:EmitSound( "weapon.ImpactHard" )
			end
		end
	end

	function ENT:OnTakeDamage( dmginfo )
		self:Detonate()
	end
else
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:Think()
		return false
	end

	function ENT:OnRemove()
	end
end