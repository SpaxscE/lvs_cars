AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )
	self:NetworkVar( "Entity",1, "Master" )
end

if SERVER then
	function ENT:SetFollowAttachment( id )
		self._attidFollow = id
	end

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
	end

	function ENT:Think()
		local T = CurTime()

		self:NextThink( T )

		local Base = self:GetBase()
		local Master = self:GetMaster()

		if not self._attidFollow or not IsValid( Base ) or not IsValid( Master ) then return true end

		local PhysObj = Master:GetPhysicsObject()

		if not IsValid( PhysObj ) then return true end

		if PhysObj:IsMotionEnabled() then PhysObj:EnableMotion( false ) end

		local att = Base:GetAttachment( self._attidFollow )

		if not att then self:NextThink( T + 1 ) return true end

		local OldAng = Master:GetAngles()
		local NewAng = att.Ang

		if OldAng ~= NewAng then
			Master:SetAngles( att.Ang )
			self:PhysWake()
		end

		return true
	end

	function ENT:OnTakeDamage( dmginfo )
		local base = self:GetBase()

		if not IsValid( base ) then return end

		base:OnTakeDamage( dmginfo )
	end

	function ENT:PhysicsCollide( data, phys )
		local base = self:GetBase()

		if not IsValid( base ) then return end

		base:PhysicsCollide( data, phys )
	end

	function ENT:Use( ply )
		if (ply._lvsNextUse or 0) > CurTime() then return end

		local base = self:GetBase()

		if not IsValid( base ) then return end

		base:Use( ply )
	end

	function ENT:OnRemove()
	end

	return
end

function ENT:Initialize()
end

function ENT:OnRemove()
end

function ENT:Draw()
	if not LVS.DeveloperEnabled then return end

	self:DrawModel()
end
