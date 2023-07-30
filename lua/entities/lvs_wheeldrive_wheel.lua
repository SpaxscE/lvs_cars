AddCSLuaFile()

ENT.Type            = "anim"

ENT.lvsWheel = true

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

	function ENT:MakeSpherical( radius, mass )
		self:SetRadius( radius )

		--self:PhysicsInit( SOLID_VPHYSICS )
		self:PhysicsInitSphere( math.max( radius - 10, 1 ), "default_silent" )

		local PhysObj = self:GetPhysicsObject()

		if not IsValid( PhysObj ) then
			self:Remove()

			print("LVS: Wheel model has no physics. Vehicle terminated.")

			return
		end

		--PhysObj:SetMaterial( "default_silent" )
		PhysObj:SetMass( mass )
		PhysObj:EnableDrag( false )

		local Base = self:GetBase()

		if not IsValid( Base ) then return end

		local nocollide = constraint.NoCollide(Base,self,0,0)
		nocollide.DoNotDuplicate = true
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

		return self:GetBase():GetSteerPercent() * Axle.SteerAngle * Swap
	end

	function ENT:IsInitialized()
		local T = CurTime()

		if (self._TimeInit or T) < T then return true end

		local Base = self:GetBase()

		if not IsValid( Base ) then return false end

		if not Base:IsInitialized() then return false end

		if not self._TimeInit then
			self._TimeInit = T + 0.1

			return false
		end

		return false
	end

	function ENT:GetRotation()
		return self._WheelRotation or 0
	end

	function ENT:Draw()
		if not self:IsInitialized() then return end

		local Axle = self:GetAxleData()

		if not Axle then return end

		local base = self:GetBase()

		if not IsValid( base ) then return end

		local AxleAng = base:LocalToWorldAngles( Axle.ForwardAngle )

		local WheelAng = self:LocalToWorldAngles( Angle(0,0,0) )

		WheelAng:RotateAroundAxis( AxleAng:Right(), self:GetRotation() )
		WheelAng:RotateAroundAxis( AxleAng:Up(), self:GetSteer() )

		local Pos = self:GetPos()
		local Up = self:GetUp()
		local WheelRadius = self:GetRadius()

		local trace = util.TraceLine( {
			start = Pos,
			endpos = Pos - Up * WheelRadius,
			mask = MASK_SOLID_BRUSHONLY,
		} )

		self:SetRenderAngles( WheelAng )
		self:SetPos( trace.HitPos + Up * WheelRadius )
	
		self:DrawModel()
		self:SetRenderAngles( nil )
	end

	function ENT:Think()
		local Axle = self:GetAxleData()

		if not Axle then return end

		local Base = self:GetBase()

		if not IsValid( Base ) then return end

		local Vel = self:GetVelocity()
		local VelForward = Vel:GetNormalized()

		local Ang = Base:LocalToWorldAngles( Axle.ForwardAngle )
		Ang:RotateAroundAxis( Ang:Up(), self:GetSteer() )

		local Forward = Ang:Forward()

		local Ax = math.acos( math.Clamp( Forward:Dot(VelForward) ,-1,1) )

		local F = Vel:Length()
		local Fx = math.cos( Ax ) * F

		local AngleStepPerFrame = (Fx * FrameTime()) / ((self:GetRadius() * 2) * math.pi) * 360
		self._WheelRotation = (self._WheelRotation or 0) - AngleStepPerFrame

		if self._WheelRotation > 360 then self._WheelRotation = self._WheelRotation - 360 end
		if self._WheelRotation < -360 then self._WheelRotation = self._WheelRotation + 360 end
	end

	function ENT:OnRemove()
	end
end