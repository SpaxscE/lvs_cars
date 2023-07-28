ENT._WheelEnts = {}
ENT._WheelAxleID = 0
ENT._WheelAxleData = {}

function ENT:GetWheels()
	for id, ent in pairs( self._WheelEnts ) do
		if IsValid( ent ) then continue end

		self._WheelEnts[ id ] = nil
	end

	return self._WheelEnts
end

function ENT:GetAxleData( ID )
	if not self._WheelAxleData[ ID ] then return {} end

	return self._WheelAxleData[ ID ]
end

function ENT:CreateSteerMaster( TargetEntity )
	if not IsValid( TargetEntity ) then return end

	local Master = ents.Create( "prop_physics" )

	if not IsValid( Master ) then
		self:Remove()

		print("LVS: Failed to create steermaster entity. Vehicle terminated.")

		return
	end

	Master:SetModel( "models/dav0r/hoverball.mdl" )
	Master:SetPos( TargetEntity:GetPos() )
	Master:SetAngles( Angle(0,90,0) )
	Master:Spawn()
	Master:Activate()

	self:DeleteOnRemove( Master )
	self:TransferCPPI( Master )

	local PhysObj = Master:GetPhysicsObject()

	if not IsValid( PhysObj ) then
		self:Remove()

		print("LVS: Failed to create steermaster physics. Vehicle terminated.")

		return
	end

	PhysObj:SetMass( 1 )
	PhysObj:EnableMotion( false )
	PhysObj:EnableDrag( false )

	Master:SetNotSolid( true )
	Master:SetColor( Color( 255, 255, 255, 0 ) ) 
	Master:SetRenderMode( RENDERMODE_TRANSALPHA )
	Master:DrawShadow( false )
	Master:SetNoDraw( true )

	Master.DoNotDuplicate = true

	return Master
end

function ENT:AddWheel( data )-- pos, ang, model )
	if not istable( data ) or not isvector( data.pos ) then return end

	local Wheel = ents.Create( "lvs_wheeldrive_wheel" )

	if not IsValid( Wheel ) then
		self:Remove()

		print("LVS: Failed to create wheel entity. Vehicle terminated.")

		return
	end

	Wheel:SetModel( data.mdl or "models/props_vehicles/tire001c_car.mdl" )
	Wheel:SetPos( self:LocalToWorld( data.pos ) )
	Wheel:SetAngles( Angle(0,0,0) )
	Wheel:Spawn()
	Wheel:Activate()

	Wheel:SetBase( self )

	Wheel:SetAlignmentAngle( data.mdl_ang or Angle(0,0,0) )

	Wheel:MakeSpherical()

	Wheel:SetCamber( data.camber or 0 )
	Wheel:SetCaster( data.caster or 0 )
	Wheel:SetToe( data.toe or 0 )

	self:DeleteOnRemove( Wheel )
	self:TransferCPPI( Wheel )

	local PhysObj = Wheel:GetPhysicsObject()

	if not IsValid( PhysObj ) then
		self:Remove()

		print("LVS: Failed to create wheel physics. Vehicle terminated.")

		return
	end

	local mass = self:GetPhysicsObject():GetMass() / 10

	PhysObj:SetMass( mass )
	PhysObj:SetInertia( Vector(0.1,0.1,0.1) * mass )
	PhysObj:EnableDrag( false )

	local nocollide_constraint = constraint.NoCollide(self,Wheel,0,0)
	nocollide_constraint.DoNotDuplicate = true

	debugoverlay.Line( self:GetPos(), self:LocalToWorld( data.pos ), 5, Color(150,150,150), true )

	table.insert( self._WheelEnts, Wheel )

	local Master = self:CreateSteerMaster( Wheel )

	local Lock = 0.0001

	local B1 = constraint.AdvBallsocket( Wheel, Master,0,0,Vector(0,0,0),Vector(0,0,0),0,0, -180, -Lock, -Lock, 180, Lock, Lock, 0, 0, 0, 1, 1)
	B1.DoNotDuplicate = true

	local B2 = constraint.AdvBallsocket( Master, Wheel,0,0,Vector(0,0,0),Vector(0,0,0),0,0, -180, Lock, Lock, 180, -Lock, -Lock, 0, 0, 0, 1, 1)
	B2.DoNotDuplicate = true

	Wheel:SetMaster( Master )

	timer.Simple(0, function()
		if not IsValid( self ) or not IsValid( Wheel ) or not IsValid( PhysObj ) then return end

		self:AddToMotionController( PhysObj )
	end )

	return Wheel
end

function ENT:DefineAxle( data )
	if not istable( data ) then print("LVS: couldn't define axle: no axle data") return end

	if not istable( data.Axle ) or not istable( data.Wheels ) or not istable( data.Suspension ) then print("LVS: couldn't define axle: no axle/wheel/suspension data") return end

	self._WheelAxleID = self._WheelAxleID + 1

	-- defaults
	data.Axle.ForwardAngle = data.Axle.ForwardAngle or Angle(0,0,0)
	data.Axle.SteerType = data.Axle.SteerType or LVS.WHEEL_STEER_NONE
	data.Axle.SteerAngle = data.Axle.SteerAngle or 20
	data.Axle.TorqueFactor = data.Axle.TorqueFactor or 1
	data.Axle.BrakeFactor = data.Axle.BrakeFactor or 1

	self._WheelAxleData[ self._WheelAxleID ] = {
		ForwardAngle = data.Axle.ForwardAngle,
		SteerType = data.Axle.SteerType,
		SteerAngle = data.Axle.SteerAngle,
		TorqueFactor = data.Axle.TorqueFactor,
		BrakeFactor = data.Axle.BrakeFactor,
	}

	data.Suspension.Height = data.Suspension.Height or 20
	data.Suspension.MaxTravel = data.Suspension.MaxTravel or data.Suspension.Height
	data.Suspension.ControlArmLength = data.Suspension.ControlArmLength or 25
	data.Suspension.SpringConstant = data.Suspension.SpringConstant or 20000
	data.Suspension.SpringDamping = data.Suspension.SpringDamping or 2000
	data.Suspension.SpringRelativeDamping = data.Suspension.SpringRelativeDamping or 2000

	local AxleCenter = Vector(0,0,0)
	for _, Wheel in ipairs( data.Wheels ) do
		if not IsEntity( Wheel ) then print("LVS: !ERROR!, given wheel is not a entity!") return end

		AxleCenter = AxleCenter + Wheel:GetPos()

		if not Wheel.SetAxle then continue end

		Wheel:SetAxle( self._WheelAxleID )
	end
	AxleCenter = AxleCenter / #data.Wheels

	debugoverlay.Text( AxleCenter, "Axle "..self._WheelAxleID.." Center ", 5, true )
	debugoverlay.Cross( AxleCenter, 5, 5, Color( 255, 0, 0 ), true )
	debugoverlay.Line( AxleCenter, AxleCenter + self:LocalToWorldAngles( data.Axle.ForwardAngle ):Forward() * 25, 5, Color(255,0,0), true )
	debugoverlay.Text( AxleCenter + self:LocalToWorldAngles( data.Axle.ForwardAngle ):Forward() * 25, "Axle "..self._WheelAxleID.." Forward", 5, true )

	data.Axle.CenterPos = self:WorldToLocal( AxleCenter )

	for id, Wheel in ipairs( data.Wheels ) do
		local Elastic = self:CreateSuspension( Wheel, AxleCenter, self:LocalToWorldAngles( data.Axle.ForwardAngle ), data.Suspension )

		debugoverlay.Line( AxleCenter, Wheel:GetPos(), 5, Color(150,0,0), true )
		debugoverlay.Text( Wheel:GetPos(), "Axle "..self._WheelAxleID.." Wheel "..id, 5, true )

		local AngleStep = 15
		for ang = 15, 360, AngleStep do
			if not Wheel.GetRadius then continue end

			local radius = Wheel:GetRadius()
			local X1 = math.cos( math.rad( ang ) ) * radius
			local Y1 = math.sin( math.rad( ang ) ) * radius

			local X2 = math.cos( math.rad( ang + AngleStep ) ) * radius
			local Y2 = math.sin( math.rad( ang + AngleStep ) ) * radius

			local P1 = Wheel:GetPos() + self:LocalToWorldAngles( data.Axle.ForwardAngle ):Up() * Y1 + self:LocalToWorldAngles( data.Axle.ForwardAngle ):Forward() * X1
			local P2 = Wheel:GetPos() + self:LocalToWorldAngles( data.Axle.ForwardAngle ):Up() * Y2 + self:LocalToWorldAngles( data.Axle.ForwardAngle ):Forward() * X2

			debugoverlay.Line( P1, P2, 5, Color( 150, 150, 150 ), true )
		end

		-- nocollide them with each other
		for i = id, #data.Wheels do
			local Ent = data.Wheels[ i ]
			if Ent == Wheel then continue end

			local nocollide_constraint = constraint.NoCollide(Ent,Wheel,0,0)
			nocollide_constraint.DoNotDuplicate = true
		end
	end
end

function ENT:CreateSuspension( Wheel, CenterPos, DirectionAngle, data )
	if not IsValid( Wheel ) or not IsEntity( Wheel ) then return end

	local height = data.Height
	local maxtravel = data.MaxTravel
	local constant = data.SpringConstant
	local damping = data.SpringDamping
	local rdamping = data.SpringRelativeDamping

	local LimiterLength = 60
	local LimiterRopeLength = math.sqrt( maxtravel ^ 2 + LimiterLength ^ 2 )

	local Pos = Wheel:GetPos()

	local PosL, _ = WorldToLocal( Pos, DirectionAngle, CenterPos, DirectionAngle )

	local Forward = DirectionAngle:Forward()
	local Right = DirectionAngle:Right() * (PosL.y > 0 and 1 or -1)
	local Up = DirectionAngle:Up()

	local RopeSize = 0
	local RopeLength = data.ControlArmLength

	local P1 = Pos + Forward * RopeLength * 0.5 + Right * RopeLength
	local P2 = Pos
	local Rope1 = constraint.Rope(self, Wheel,0,0,self:WorldToLocal( P1 ), Vector(0,0,0), Vector(RopeLength * 0.5,RopeLength,0):Length(), 0, 0, RopeSize,"cable/cable2", true )
	Rope1.DoNotDuplicate = true
	debugoverlay.Line( P1, P2, 5, Color(0,255,0), true )

	P1 = Pos - Forward * RopeLength * 0.5 + Right * RopeLength
	local Rope2 = constraint.Rope(self, Wheel,0,0,self:WorldToLocal( P1 ), Vector(0,0,0), Vector(RopeLength * 0.5,RopeLength,0):Length(), 0, 0, RopeSize,"cable/cable2", true )
	Rope2.DoNotDuplicate = true
	debugoverlay.Line( P1, P2, 5, Color(0,255,0), true )

	local Offset = Up * height

	Wheel:SetPos( Pos - Offset )

	local Limiter = constraint.Rope(self,Wheel,0,0,self:WorldToLocal( Pos - Up * height * 0.5 - Right * LimiterLength), Vector(0,0,0),LimiterRopeLength, 0, 0, RopeSize,"cable/cable2", false )
	Limiter.DoNotDuplicate = true

	P1 = Wheel:GetPos() + Up * height * 2
	local Elastic = constraint.Elastic( Wheel, self, 0, 0, Vector(0,0,0), self:WorldToLocal( P1 ), constant, damping, rdamping,"cable/cable2", RopeSize, false ) 
	Elastic.DoNotDuplicate = true
	debugoverlay.SweptBox( P1, P2,- Vector(0,1,1), Vector(0,1,1), (P1 - P2):Angle(), 5, Color( 255, 255, 0 ), true )

	Wheel:SetPos( Pos )

	return Elastic
end

function ENT:AlignWheel( Wheel )
	if not IsValid( Wheel ) then return end

	if not isfunction( Wheel.GetMaster ) then Wheel:Remove() return end

	local Master = Wheel:GetMaster()

	if not IsValid( Master ) then Wheel:Remove() return end

	local Steer = self:GetSteer()

	local PhysObj = Master:GetPhysicsObject()

	if PhysObj:IsMotionEnabled() then PhysObj:EnableMotion( false ) return end

	local ID = Wheel:GetAxle()

	local Axle = self:GetAxleData( ID )

	local AxleAng = self:LocalToWorldAngles( Axle.ForwardAngle )

	AxleAng:RotateAroundAxis( AxleAng:Right(), Wheel:GetCaster() )
	AxleAng:RotateAroundAxis( AxleAng:Forward(), Wheel:GetCamber() )
	AxleAng:RotateAroundAxis( AxleAng:Up(), Wheel:GetToe() )

	if Axle.SteerType == LVS.WHEEL_STEER_REAR then
		AxleAng:RotateAroundAxis( AxleAng:Up(), math.Clamp(Steer,-Axle.SteerAngle,Axle.SteerAngle) )
	else
		if Axle.SteerType == LVS.WHEEL_STEER_FRONT then
			AxleAng:RotateAroundAxis( AxleAng:Up(), math.Clamp(-Steer,-Axle.SteerAngle,Axle.SteerAngle) )
		end
	end

	Master:SetAngles( AxleAng )

	return Axle, AxleAng
end

function ENT:WheelsOnGround()

	for _, ent in pairs( self:GetWheels() ) do
		if not IsValid( ent ) then continue end

		local phys = ent:GetPhysicsObject()

		local EntLoad,_ = phys:GetStress()

		if EntLoad == 0 then return false end
	end

	return true
end