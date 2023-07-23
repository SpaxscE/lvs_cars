
AddCSLuaFile()

ENT.Type            = "anim"

ENT.Editable = true

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "Radius")

	self:NetworkVar( "Float", 1, "Camber", { KeyName = "camber", Edit = { type = "Float", order = 1,min = -15, max = 15, category = "Alignment"} } )
	self:NetworkVar( "Float", 2, "Caster", { KeyName = "caster", Edit = { type = "Float", order = 2,min = -15, max = 15, category = "Alignment"} } )
	self:NetworkVar( "Float", 3, "Toe", { KeyName = "toe", Edit = { type = "Float", order = 3,min = -15, max = 15, category = "Alignment"} } )

	if SERVER then
		self:SetCamber( 0 )
		self:SetCaster( 5 )
		self:SetToe( 0 )
	end
end

if SERVER then
	function ENT:Initialize()
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
	end

	function ENT:Use( ply )
	end

	function ENT:Think()
		return false
	end

	function ENT:OnRemove()
	end

	function ENT:OnTakeDamage( dmginfo )
	end

	function ENT:PhysicsCollide( data )
	end

	function ENT:SetAxle( ID )
		self._AxleID = ID
	end

	function ENT:SetBase( base )
		self._Base = base
	end

	function ENT:SetMaster( master )
		self._Master = master
	end

	function ENT:GetBase()
		return self._Base
	end

	function ENT:GetMaster()
		return self._Master
	end

	function ENT:GetAxle()
		return (self._AxleID or 0)
	end

	function ENT:MakeSpherical()
		local radius = (self:OBBMaxs() - self:OBBMins()) * 0.5

		radius = math.max( radius.x, radius.y, radius.z )

		self:PhysicsInitSphere( radius, "default_silent" )

		self:SetRadius( radius )
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:Think()
	end

	function ENT:OnRemove()
	end
end