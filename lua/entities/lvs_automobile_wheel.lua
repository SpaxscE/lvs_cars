AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "Wheel"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable		= true

function ENT:SetupDataTables()
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
		self:DrawShadow( false )
		--debugoverlay.Cross( self:GetPos(), 5, 1, Color(150,150,150) )
	end

	function ENT:Define( rRim, rTire, mass )
		local bbox = Vector(rRim,rRim,rRim)

		self:PhysicsInitSphere( rRim, "default_silent" )
		self:SetCollisionBounds( -bbox, bbox )

		local PhysObj = self:GetPhysicsObject()

		PhysObj:SetMass( mass )

		--debugoverlay.Sphere( self:GetPos(), rTire, 1, Color(150,150,150), true )

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
		local VelForward = Vel:GetNormalized()

		local VelL = phys:WorldToLocal( Pos + Vel )
		local data = self:GetAxleData()
		local Axle = data.Axle
		local SteerType = Axle.SteerType

		local WheelRadius = self:GetTireRadius()

		local Ang = Base:LocalToWorldAngles( Axle.ForwardAngle )

		if SteerType >= LVS.WHEEL_STEER_FRONT then
			local Swap = (LVS.WHEEL_STEER_FRONT == SteerType) and -1 or 1

			Ang:RotateAroundAxis( self:GetUp(), Base:GetSteer() * Axle.SteerAngle * Swap )
		end

		local Forward = Ang:Forward()
		local Right = Ang:Right()
		local Up = Ang:Up()

		local Len = WheelRadius

		local traceLine = util.TraceHull( {
			start = Pos,
			endpos = Pos - Up * Len,
			filter = function( entity )
				if Base:GetCrosshairFilterLookup()[ entity:EntIndex() ] or entity:IsPlayer() or entity:IsNPC() or entity:IsVehicle() or Base.CollisionFilter[ entity:GetCollisionGroup() ] then
					return false
				end

				return true
			end,
		} )

		local HitPos = traceLine.HitPos
		local Mul = math.Clamp( (1 - traceLine.Fraction) * Len,0,1.5)

		local Ax = math.acos( math.Clamp( Forward:Dot(VelForward) ,-1,1) )
		local Ay = math.asin( math.Clamp( Right:Dot(VelForward) ,-1,1) )

		local fUp = ((HitPos + traceLine.HitNormal * WheelRadius - Pos) * 100 - Vel * 10) * 5 * Mul
		local aUp = math.acos( math.Clamp( Up:Dot( fUp:GetNormalized() ) ,-1,1) )

		local F = Vel:Length()
		local Fx = math.cos( Ax ) * F
		local Fy = math.sin( Ay ) * F
		local Fz = math.cos( aUp ) * fUp:Length()

		local ForceLinear = Up * Fz + (Right * -Fy * 100 + Forward * -Fx * 1) * Mul + Forward * Base:GetThrottle() * 1000 * Mul

		local ForceAngle = Vector(0,0,0)

		return ForceAngle, ForceLinear, SIM_GLOBAL_ACCELERATION
	end
else
	function ENT:Initialize()
	end

	function ENT:Draw()
	end

	function ENT:Think()
	end

	function ENT:OnRemove()
	end
end