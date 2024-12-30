AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "Spike Strip"
ENT.Author = "Luna"
ENT.Information = "Pops Tires"
ENT.Category = "[LVS]"

ENT.Spawnable		= true
ENT.AdminOnly		= false

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )
		if not tr.Hit then return end

		local ent = ents.Create( ClassName )
		ent:SetPos( tr.HitPos + tr.HitNormal )
		ent:Spawn()
		ent:Activate()

		return ent
	end

	function ENT:OnTakeDamage( dmginfo )
	end

	function ENT:Initialize()	
		self:SetModel( "models/diggercars/shared/spikestrip_static.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetTrigger( true )

		local PhysObj = self:GetPhysicsObject()

		if not IsValid( PhysObj ) then return end

		PhysObj:EnableMotion( false )
	end

	function ENT:Think()
		local PhysObj = self:GetPhysicsObject()

		if IsValid( PhysObj ) and PhysObj:IsMotionEnabled() then
			if PhysObj:IsAsleep() then
				PhysObj:EnableMotion( false )
			end
		end

		self:NextThink( CurTime() + 1 )

		return true
	end

	function ENT:Use( ply )
	end

	function ENT:OnRemove()
	end

	function ENT:PhysicsCollide( data, physobj )
	end

	function ENT:StartTouch( entity )
	end

	function ENT:EndTouch( entity )
	end

	
	function ENT:Touch( entity )
		if not IsValid( entity ) or entity:GetClass() ~= "lvs_wheeldrive_wheel" then return end

		local Destroy = entity:GetVelocity():Length() > 200

		if not Destroy then
			for i = -1,1 do
				local trace = util.TraceLine( {
					start = self:LocalToWorld( Vector(5 * i,-109,12) ),
					endpos = self:LocalToWorld( Vector(5 * i,109,12) ),
					filter = entity,
					whitelist = true,
				} )

				if trace.Hit then
					Destroy = true

					break
				end
			end
		end

		if not Destroy then return end

		local T = CurTime()

		if (entity._LastSpikeStripPop or 0) > T then return end

		entity._LastSpikeStripPop = T + 2

		local dmginfo = DamageInfo()
		dmginfo:SetDamage( entity:GetHP() )
		dmginfo:SetAttacker( self )
		dmginfo:SetDamageType( DMG_PREVENT_PHYSICS_FORCE ) 

		entity:TakeDamageInfo( dmginfo )

		local base = entity:GetBase()

		if not IsValid( base ) then return end

		local PhysObj = base:GetPhysicsObject()

		if not IsValid( PhysObj ) then return end

		PhysObj:ApplyTorqueCenter( Vector(0,0, PhysObj:GetVelocity():Length() * 250 * (PhysObj:GetAngleVelocity().z > 0 and 1 or -1) ) )
	end

end

if CLIENT then
	function ENT:Think()
	end

	function ENT:Draw( flags )
		self:DrawModel( flags )
	end

	function ENT:OnRemove()
	end
end