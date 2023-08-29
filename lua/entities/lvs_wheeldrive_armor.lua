AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )

	self:NetworkVar( "Float",0, "HP" )
	self:NetworkVar( "Float",1, "MaxHP" )

	self:NetworkVar( "Bool",0, "Destroyed" )

	if SERVER then
		self:SetMaxHP( 100 )
		self:SetHP( 100 )
	end
end

if SERVER then
	function ENT:Initialize()	
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		self:DrawShadow( false )
	end

	function ENT:Think()
		return false
	end

	function ENT:OnTakeDamage( dmginfo )
		local Damage = dmginfo:GetDamage()
		local Force = dmginfo:GetDamageForce()

		if Force:Length() <= (self.MinForce or 1000) then return false end

		local CurHealth = self:GetHP()

		local NewHealth = math.Clamp( CurHealth - Damage, 0, self:GetMaxHP() )

		self:SetHP( NewHealth )

		if not dmginfo:IsDamageType( DMG_AIRBOAT ) then return end

		local pos = dmginfo:GetDamagePosition()
		local dir = Force:GetNormalized()

		local trace = util.TraceLine( {
			start = pos - dir * 20,
			endpos = pos + dir * 20,
			filter = function( ent ) return ent == self:GetBase() end
		} )

		if trace.Entity == self:GetBase() then
			local Ax = math.acos( math.Clamp( trace.HitNormal:Dot( dir ) ,-1,1) )
			local Fx = math.cos( Ax )

			local HitAngle = 90 - (180 - math.deg( Ax ))

			if HitAngle > 10 then
				local hit_decal = ents.Create( "lvs_wheeldrive_armor_penetrate" )
				hit_decal:SetPos( trace.HitPos )
				hit_decal:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
				hit_decal:Spawn()
				hit_decal:Activate()
				hit_decal:SetParent( trace.Entity )
			else

				local NewDir = dir - trace.HitNormal * Fx * 2

				local hit_decal = ents.Create( "lvs_wheeldrive_armor_bounce" )
				hit_decal:SetPos( trace.HitPos )
				hit_decal:SetAngles( NewDir:Angle() )
				hit_decal:Spawn()
				hit_decal:Activate()
				hit_decal:EmitSound("lvs/armor_rico"..math.random(1,4)..".wav", 95, 100, math.min( dmginfo:GetDamage() / 1000, 1 ) )

				local PhysObj = hit_decal:GetPhysicsObject()
				if IsValid( PhysObj ) then
					PhysObj:EnableDrag( false )
					PhysObj:SetVelocityInstantaneous( NewDir * 2000 + Vector(0,0,250) )
					PhysObj:SetAngleVelocityInstantaneous( VectorRand() * 250 )
				end

				self:SetHP( CurHealth )

				return
			end
		end

		if NewHealth <= 0 then
			self:SetDestroyed( true )

			local Attacker = dmginfo:GetAttacker() 
			if IsValid( Attacker ) and Attacker:IsPlayer() then
				net.Start( "lvs_car_markers" )
				net.Send( Attacker )
			end
		end

		return true
	end

	return
end

function ENT:Initialize()
end

function ENT:OnRemove()
end

function ENT:Draw()
end

function ENT:Think()
end
