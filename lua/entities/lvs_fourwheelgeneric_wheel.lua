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
		self:SetModel("models/diggercars/NISSAN_BLUEBIRD910/bluebird_rim.mdl")
		self:DrawShadow( false )

		debugoverlay.Cross( self:GetPos(), 5, 1, Color(150,150,150) )
	end

	function ENT:Define( rRim, rTire, mass )
		local bbox = Vector(rRim,rRim,rRim)

		self:PhysicsInitSphere( rRim, "default_silent" )
		self:SetCollisionBounds( -bbox, bbox )

		local PhysObj = self:GetPhysicsObject()

		PhysObj:SetMass( mass )

		debugoverlay.Sphere( self:GetPos(), rRim, 1, Color(150,150,150), true )

		local Base = self:GetBase()

		if not IsValid( Base ) then return end

		local nocollide = constraint.NoCollide(Base,self,0,0)
		nocollide.DoNotDuplicate = true

		self:SetRimRadius( rRim )
		self:SetTireRadius( rTire )

		self:StartMotionController()
	end

	function ENT:SetRimRadius( n )
		self._RimRadius = n
	end

	function ENT:GetRimRadius()
		return (self._RimRadius or 0)
	end
	
	function ENT:SetAxle( n )
		self._Axle = n
	end

	function ENT:GetAxleData()
		local Base = self:GetBase()

		if not IsValid( Base ) or not isnumber( self._Axle  ) then return end

		return Base._WheelAxles[ self._Axle ]
	end

	function ENT:Think()	
		return false
	end

	function ENT:PhysicsCollide( data )
	end

	function ENT:OnTakeDamage( dmginfo )	
	end

	function ENT:PhysicsSimulate( phys, deltatime )
		phys:Wake()

		local Base = self:GetBase()
		local Pos = phys:GetPos()
		local Vel = phys:GetVelocity()
		local VelL = phys:WorldToLocal( Pos + Vel )
		local Axle = self:GetAxleData().Axle

		local WheelRadius = self:GetTireRadius()

		local Ang = Base:LocalToWorldAngles( Axle.ForwardAngle )

		local Up = Ang:Up()

		local Len = WheelRadius

		local traceLine = util.TraceHull( {
			start = Pos,
			endpos = Pos - Up * Len,
			filter = Base:GetCrosshairFilterEnts()
		} )

		local HitPos = traceLine.HitPos
		local Mul = math.Clamp( (1 - traceLine.Fraction) * Len,0,1.5)

		local ForceLinear = phys:WorldToLocal( Pos + ((HitPos + Up * WheelRadius - Pos) * 100 - Vel * 10) * 5 )
		ForceLinear.z = ForceLinear.z * Mul
		ForceLinear.x = 0
		ForceLinear.y = 0

		local LocalForward = phys:WorldToLocal( Pos + Ang:Forward() )
		local LocalRight = phys:WorldToLocal( Pos + Ang:Right() )
		local LocalVelForward = VelL:GetNormalized()

		local Ax = math.acos( math.Clamp( LocalForward:Dot(LocalVelForward) ,-1,1) )
		local Ay = math.asin( math.Clamp( LocalRight:Dot(LocalVelForward) ,-1,1) )

		local F = VelL:Length()
		local Fx = math.cos( Ax ) * F
		local Fy = math.sin( Ay ) * F

		ForceLinear = ForceLinear + (LocalRight * -Fy * 100 + LocalForward * -Fx * 10) * Mul

		local ForceAngle = Vector(0,0,0)

		return ForceAngle, ForceLinear, SIM_LOCAL_ACCELERATION
	end
else
	function ENT:Initialize()
	end

	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:Think()
		if not IsValid( self.asdf ) then
			local asdf = ents.CreateClientProp()
			asdf:SetPos( self:GetPos() )
			asdf:SetAngles( self:GetAngles() )
			asdf:SetModel( "models/diggercars/NISSAN_BLUEBIRD910/bluebird_tire.mdl" )
			asdf:SetParent( self )
			asdf:Spawn()
			
			self.asdf = asdf
		end

		if not IsValid( self.asdf:GetParent() ) then
			self.asdf:SetPos( self:GetPos() )
			self.asdf:SetAngles( self:GetAngles() )
			self.asdf:SetParent( self )
		end
	end

	function ENT:OnRemove()
		if IsValid( self.asdf ) then
			self.asdf:Remove()
		end
	end
end