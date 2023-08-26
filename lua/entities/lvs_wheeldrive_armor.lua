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

		if Force:Length() <= 1000 then return false end

		local CurHealth = self:GetHP()

		local NewHealth = math.Clamp( CurHealth - Damage, 0, self:GetMaxHP() )

		self:SetHP( NewHealth )

		local pos = dmginfo:GetDamagePosition()
		local dir = Force:GetNormalized() * 20

		local trace = util.TraceLine( {
			start = pos - dir,
			endpos = pos + dir,
			filter = function( ent ) return ent == self:GetBase() end
		} )

		if trace.Entity == self:GetBase() then
			local hit_decal = ents.Create( "lvs_wheeldrive_armor_impact" )
			hit_decal:SetPos( trace.HitPos )
			hit_decal:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
			hit_decal:Spawn()
			hit_decal:Activate()
			hit_decal:SetParent( trace.Entity )
		end

		if NewHealth <= 0 then
			local Attacker = dmginfo:GetAttacker() 
			if IsValid( Attacker ) and Attacker:IsPlayer() then
				net.Start( "lvs_car_markers" )
				net.Send( Attacker )
			end

			self:SetDestroyed( true )
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
