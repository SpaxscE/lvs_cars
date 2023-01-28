AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "Wheel"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable		= true

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "TireModel" )
	self:NetworkVar( "Float", 0, "TireRadius" )
	self:NetworkVar( "Entity", 0, "Base" )
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
		self:SetModel("models/diggercars/nissan_bluebird910/bluebird_tire.mdl")
		self:DrawShadow( false )

		debugoverlay.Cross( self:GetPos(), 5, 1, Color(150,150,150) )
	end

	function ENT:Define( radius, mass )
		local bbox = Vector(radius,radius,radius)

		self:PhysicsInitSphere( radius, "default_silent" )
		self:SetCollisionBounds( -bbox, bbox )

		local PhysObj = self:GetPhysicsObject()

		PhysObj:SetMass( mass )
		--PhysObj:EnableMotion( )

		debugoverlay.Sphere( self:GetPos(), radius, 1, Color(150,150,150), true )

		local base = self:GetBase()

		if not IsValid( base ) then return end

		local nocollide = constraint.NoCollide(base,self,0,0)
		nocollide.DoNotDuplicate = true
	end

	function ENT:Think()	
		return false
	end

	function ENT:PhysicsCollide( data )
	end

	function ENT:OnTakeDamage( dmginfo )	
	end

	--[[
	function ENT:PhysicsSimulate( phys, deltatime )
		phys:Wake()

		local ForceLinear = Vector(0,0,0)

		local angvel = phys:GetAngleVelocity()

		self:SetSpeed( angvel.x )

		local ForceAngle = Vector(self:GetTargetSpeed() - angvel.x,0,0)

		return ForceAngle, ForceLinear, SIM_LOCAL_ACCELERATION
	end
	]]
else
	function ENT:Initialize()
	end

	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:Think()
	end

	function ENT:OnRemove()
	end
end