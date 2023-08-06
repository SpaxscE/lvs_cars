
AddCSLuaFile()

ENT.PrintName = "Wheel"

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

ENT.RenderGroup = RENDERGROUP_BOTH 

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "Radius")

	self:NetworkVar( "Float", 1, "Camber" )
	self:NetworkVar( "Float", 2, "Caster" )
	self:NetworkVar( "Float", 3, "Toe" )

	self:NetworkVar( "Float", 4, "RPM" )

	self:NetworkVar( "Angle", 0, "AlignmentAngle" )

	self:NetworkVar( "Entity", 0, "Base" )
end

function ENT:VelToRPM( speed )
	if not speed then return 0 end

	return speed * 60 / math.pi / (self:GetRadius() * 2)
end

function ENT:RPMToVel( rpm )
	if not rpm then return 0 end

	return (math.pi * rpm * self:GetRadius() * 2) / 60
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
		local base = self:GetBase()

		if not IsValid( base ) then return end

		base:Use( ply )
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

	function ENT:SetMaster( master )
		self._Master = master
	end

	function ENT:GetMaster()
		return self._Master
	end

	function ENT:MakeSpherical( radius )
		if not radius or radius <= 0 then
			radius = (self:OBBMaxs() - self:OBBMins()) * 0.5
			radius = math.max( radius.x, radius.y, radius.z )
		end

		self:PhysicsInitSphere( radius, "jeeptire" )

		self:SetRadius( radius )
	end

	function ENT:GetDirectionAngle()
		local master = self:GetMaster()

		if not IsValid( master ) then return self:GetAngles() end

		return master:GetAngles()
	end

	function ENT:GetRotationAxis()
		local base = self:GetBase()

		if not IsValid( base ) then return vector_origin end

		local Axle = base:GetAxleData( self:GetAxle() )

		local WorldAngleDirection = -self:WorldToLocalAngles( self:GetDirectionAngle() )

		return WorldAngleDirection:Right()
	end

	function ENT:GetTorqueFactor()
		if self._torqueFactor then return self._torqueFactor end

		local base = self:GetBase()

		if not IsValid( base ) then return 0 end

		self._torqueFactor = base:GetAxleData( self:GetAxle() ).TorqueFactor or 0

		return self._torqueFactor
	end

	function ENT:GetBrakeFactor()
		if self._brakeFactor then return self._brakeFactor end

		local base = self:GetBase()

		if not IsValid( base ) then return 0 end

		self._brakeFactor = base:GetAxleData( self:GetAxle() ).BrakeFactor or 0

		return self._brakeFactor
	end

	function ENT:PhysicsOnGround( PhysObj )
		if not PhysObj then
			PhysObj = self:GetPhysicsObject()
		end

		local EntLoad,_ = PhysObj:GetStress()

		return EntLoad > 0
	end
end

if CLIENT then
	function ENT:Draw()
		self:SetRenderAngles( self:LocalToWorldAngles( self:GetAlignmentAngle() ) )
		self:DrawModel()
	end

	function ENT:DrawTranslucent()
	end

	ENT.DustEffectSurfaces = {
		["sand"] = true,
		["dirt"] = true,
		["grass"] = true,
	}

	function ENT:Test()
		local Base = self:GetBase()

		if not IsValid( Base ) then return end

		local Vel = self:GetVelocity()
		local VelLength = Vel:Length()

		local rpmTheoretical = self:VelToRPM( VelLength )
		local rpm = math.abs( self:GetRPM() )

		local WheelSlip = math.max( rpm - rpmTheoretical, 0 ) ^ 2 + math.abs( Base:VectorSplitNormal( self:GetForward(), Vel * 2 ) )

		if WheelSlip < 500 then return end

		local SkidValue = VelLength + WheelSlip

		local Radius = self:GetRadius()
		local StartPos = self:GetPos()
		local EndPos = StartPos - Base:GetUp() * (Radius + 1)

		local trace = util.TraceLine( {
			start = StartPos,
			endpos = EndPos,
			filter = Base:GetCrosshairFilterEnts(),
		} )

		if not trace.Hit or not self.DustEffectSurfaces[ util.GetSurfacePropName( trace.SurfaceProps ) ] then return end

		local Scale = math.min( 0.3 + (SkidValue - 100) / 4000, 1 ) ^ 2

		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetEntity( Base )
		effectdata:SetNormal( trace.HitNormal )
		effectdata:SetMagnitude( Scale )
		util.Effect( "lvs_physics_wheeldust", effectdata, true, true )
	end

	function ENT:Think()
		self:SetNextClientThink( CurTime() + 0.05 )

		self:Test()

		return true
	end
end