AddCSLuaFile()

ENT.Type            = "anim"

ENT.AutomaticFrameAdvance = true
ENT.DoNotDuplicate = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )
end

if SERVER then
	function ENT:Initialize()	
		self:SetUseType( SIMPLE_USE )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:AddEFlags( EFL_NO_PHYSCANNON_INTERACTION )
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		self:DrawShadow( false )

		self:SetMaterial( "models/wireframe" )

		local PhysObj = self:GetPhysicsObject()

		if not IsValid( PhysObj ) then return end

		PhysObj:SetMass( 1 )
		PhysObj:EnableDrag( false )
		PhysObj:EnableGravity( false ) 
		PhysObj:EnableMotion( true )
		PhysObj:SetMaterial( "friction_00" )
	end

	function ENT:Think()
		return false
	end

	function ENT:OnTakeDamage( dmginfo )
		local base = self:GetBase()

		if not IsValid( base ) then return end

		local startpos = dmginfo:GetDamagePosition()
		local endpos = startpos + dmginfo:GetDamageForce():GetNormalized() * 50000

		local trace = util.TraceLine( {
			start = startpos,
			endpos = endpos,
			whitelist = true,
			ignoreworld = true,
			filter = base,
		} )

		if not trace.Hit then
			dmginfo:SetDamageType( dmginfo:GetDamageType() + DMG_PREVENT_PHYSICS_FORCE )
		end

		base:OnTakeDamage( dmginfo )
	end

	function ENT:PhysicsCollide( data, phys )
	end

	function ENT:Use( ply )
		if (ply._lvsNextUse or 0) > CurTime() then return end

		local base = self:GetBase()

		if not IsValid( base ) then return end

		base:Use( ply )
	end

	return
end

function ENT:Draw()
	if not LVS.DeveloperEnabled then return end

	self:DrawModel()
end

function ENT:Think()
end

function ENT:OnRemove()
end