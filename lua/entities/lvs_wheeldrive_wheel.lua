
AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "Radius")

	self:NetworkVar( "Float", 1, "Camber" )
	self:NetworkVar( "Float", 2, "Caster" )
	self:NetworkVar( "Float", 3, "Toe" )

	self:NetworkVar( "Angle", 0, "AlignmentAngle" )

	if SERVER then
		self:SetCamber( 0 )
		self:SetCaster( 0 )
		self:SetToe( 0 )
	end
end

if SERVER then
	AccessorFunc(ENT, "axle", "Axle", FORCE_NUMBER)

	function ENT:Initialize()
		self:SetUseType( SIMPLE_USE )
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		self:AddEFlags( EFL_NO_PHYSCANNON_INTERACTION )
	end

	function ENT:SetHandbrake( enable )
		if enable then

			self:EnableHandbrake()

			return
		end

		self:ReleaseHandbrake()
	end

	function ENT:IsHandbrakeActive()
		return self._handbrakeActive == true
	end

	function ENT:EnableHandbrake()
		if self._handbrakeActive then return end

		self._handbrakeActive = true

		self:LockRotation()
	end

	function ENT:ReleaseHandbrake()
		if not self._handbrakeActive then return end

		self._handbrakeActive = nil

		self:ReleaseRotation()
	end

	function ENT:LockRotation()
		if self:IsRotationLocked() then return end

		local Master = self:GetMaster()

		if not IsValid( Master ) then return end

		self.bsLock = constraint.AdvBallsocket(self,Master,0,0,vector_origin,vector_origin,0,0,-0.1,-0.1,-0.1,0.1,0.1,0.1,0,0,0,1,1)
		self.bsLock.DoNotDuplicate = true
	end

	function ENT:ReleaseRotation()
		if not self:IsRotationLocked() then return end

		self.bsLock:Remove()
	end

	function ENT:IsRotationLocked()
		return IsValid( self.bsLock )
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

	function ENT:MakeSpherical( radius )
		if not radius or radius <= 0 then
			radius = (self:OBBMaxs() - self:OBBMins()) * 0.5
			radius = math.max( radius.x, radius.y, radius.z )
		end

		self:PhysicsInitSphere( radius, "default_silent" )

		self:SetRadius( radius )
	end
end

if CLIENT then
	function ENT:Draw()
		self:SetRenderAngles( self:LocalToWorldAngles( self:GetAlignmentAngle() ) )
		self:DrawModel()
	end
end