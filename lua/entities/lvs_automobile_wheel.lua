AddCSLuaFile()

ENT.Type            = "anim"

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "Radius" )
	self:NetworkVar( "Entity", 0, "Base" )
end

if SERVER then
	util.AddNetworkString( "lvs_wheel_info_networker" )

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
	end

	function ENT:Define( radius, mass )
		self:PhysicsInit( SOLID_VPHYSICS )

		local PhysObj = self:GetPhysicsObject()

		if not IsValid( PhysObj ) then
			self:Remove()

			print("LVS: Wheel model has no physics. Vehicle terminated.")

			return
		end

		PhysObj:SetMass( mass )

		local Base = self:GetBase()

		if not IsValid( Base ) then return end

		local nocollide = constraint.NoCollide(Base,self,0,0)
		nocollide.DoNotDuplicate = true

		local mins = self:OBBMins()
		mins.x = math.abs( mins.x )
		mins.y = math.abs( mins.y )
		mins.z = math.abs( mins.z )

		local maxs = self:OBBMaxs()
		maxs.x = math.abs( maxs.x )
		maxs.y = math.abs( maxs.y )
		maxs.z = math.abs( maxs.z )

		local OBBRadius = math.max( mins.x, mins.y, mins.z, maxs.x, maxs.y, maxs.z )

		self:SetOBBRadius( math.min( OBBRadius, radius ) )
		self:SetRadius( math.max( OBBRadius, radius ) )

		self:StartMotionController()
	end

	function ENT:SetOBBRadius( n )
		self._OBBRadius = n
	end

	function ENT:GetOBBRadius()
		return (self._OBBRadius or 0)
	end

	function ENT:SetAxle( n )
		self._Axle = n
	end

	function ENT:GetAxleData()
		local Base = self:GetBase()

		if not IsValid( Base ) or not isnumber( self._Axle  ) then return end

		return Base._WheelAxles[ self._Axle ]
	end

	function ENT:SendAxleDataTo( ply )
		if not IsValid( ply ) then return end

		local AxleData = self:GetAxleData()

		if not AxleData then
			-- retry sending every second
			timer.Simple( 1, function()
				if not IsValid( self ) then return end

				self:SendAxleDataTo( ply )
			end )

			return
		end

		net.Start("lvs_wheel_info_networker")
			net.WriteEntity( self )
			net.WriteUInt( AxleData.Axle.SteerType, 3 )
			net.WriteAngle( AxleData.Axle.ForwardAngle )
			net.WriteFloat( AxleData.Axle.SteerAngle or 0 )
		net.Send( ply )
	end

	net.Receive( "lvs_wheel_info_networker", function( length, ply )
		local Wheel = net.ReadEntity()

		if not IsValid( Wheel ) then return end

		Wheel:SendAxleDataTo( ply )
	end)

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

		local WheelRadius = self:GetRadius()

		local Ang = Base:LocalToWorldAngles( Axle.ForwardAngle )

		if SteerType >= LVS.WHEEL_STEER_FRONT then
			local Swap = (LVS.WHEEL_STEER_FRONT == SteerType) and -1 or 1

			Ang:RotateAroundAxis( Ang:Up(), Base:GetSteer() * Axle.SteerAngle * Swap )
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

		local ForceLinear = Up * Fz + (Right * -Fy * 25 + Forward * -Fx * 1) * Mul + Forward * Base:GetThrottle() * 2000 * Mul

		local ForceAngle = Vector(0,0,0)

		return ForceAngle, ForceLinear, SIM_GLOBAL_ACCELERATION
	end
else

	net.Receive( "lvs_wheel_info_networker", function( length )
		local Wheel = net.ReadEntity()

		if not IsValid( Wheel ) then return end

		Wheel._AxleData = {
			SteerType = net.ReadUInt( 3 ),
			ForwardAngle = net.ReadAngle(),
			SteerAngle = net.ReadFloat(),
		}
	end)

	function ENT:GetAxleData()
		if self._AxleData then
			return self._AxleData
		end

		if self._AxleDataRequested then return end

		self._AxleDataRequested = true

		net.Start( "lvs_wheel_info_networker" )
			net.WriteEntity( self )
		net.SendToServer()
	end

	function ENT:Initialize()
	end

	function ENT:GetSteer()
		local Axle = self:GetAxleData()

		local SteerType = Axle.SteerType

		if SteerType < LVS.WHEEL_STEER_FRONT then return 0 end

		local Swap = (LVS.WHEEL_STEER_FRONT == SteerType) and -1 or 1

		return self:GetBase():GetSteer() * Axle.SteerAngle * Swap
	end

	function ENT:GetRotation()
		local Base = self:GetBase()

		local Axle = self:GetAxleData()

		local Vel = self:GetVelocity()
		local VelForward = Vel:GetNormalized()

		local Ang = Base:LocalToWorldAngles( Axle.ForwardAngle )
		Ang:RotateAroundAxis( Ang:Up(), self:GetSteer() )

		local Forward = Ang:Forward()

		local Ax = math.acos( math.Clamp( Forward:Dot(VelForward) ,-1,1) )

		local F = Vel:Length()
		local Fx = math.cos( Ax ) * F

		self._WheelRotation = (self._WheelRotation or 0) - (Fx * RealFrameTime() / math.pi) * self:GetRadius() * 2

		return self._WheelRotation
	end

	function ENT:Draw()
		local Base = self:GetBase()

		if not IsValid( Base ) then return end

		local Axle = self:GetAxleData()

		if not Axle then return end

		local AxleAng = Base:LocalToWorldAngles( Axle.ForwardAngle )

		local WheelAng = self:GetAngles()
		WheelAng:RotateAroundAxis( AxleAng:Right(), self:GetRotation() )
		WheelAng:RotateAroundAxis( AxleAng:Up(), self:GetSteer() )

		self:SetRenderAngles( WheelAng )
		self:DrawModel()
		self:SetRenderAngles( nil )
	end

	function ENT:Think()
	end

	function ENT:OnRemove()
	end
end