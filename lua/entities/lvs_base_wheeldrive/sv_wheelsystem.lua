ENT._WheelEnts = {}

ENT._WheelAxleID = 0
ENT._WheelAxles = {}

include("sv_wheelsystem_masscenter.lua")

function ENT:GetWheels()
	for id, ent in pairs( self._WheelEnts ) do
		if IsValid( ent ) then continue end

		self._WheelEnts[ id ] = nil
	end

	return self._WheelEnts
end

function ENT:AddWheel( pos, ang, model, radius )
	local Wheel = ents.Create( "lvs_wheeldrive_wheel" )

	if not IsValid( Wheel ) then
		self:Remove()

		print("LVS: Failed to create wheel entity. Vehicle terminated.")

		return
	end
	Wheel:SetModel( model )
	Wheel:SetPos( self:LocalToWorld( pos ) )
	Wheel:SetAngles( self:LocalToWorldAngles( ang ) )
	Wheel:Spawn()
	Wheel:Activate()

	self:DeleteOnRemove( Wheel )
	self:TransferCPPI( Wheel )

	Wheel:SetBase( self )
	Wheel:Define( radius, self:GetPhysicsObject():GetMass() / 10 )

	debugoverlay.Line( self:GetPos(), self:LocalToWorld( pos ), 5, Color(150,150,150), true )

	table.insert( self._WheelEnts, Wheel )

	return Wheel
end

function ENT:DefineAxle( data )
	if not istable( data ) then print("LVS: couldn't define axle: no axle data") return end

	if not istable( data.Axle ) or not istable( data.Wheels ) or not istable( data.Suspension ) then print("LVS: couldn't define axle: no axle/wheel/suspension data") return end

	self._WheelAxleID = self._WheelAxleID + 1

	data.Axle.ForwardAngle = data.Axle.ForwardAngle or Angle(0,0,0)
	data.Axle.SteerType = data.Axle.SteerType or LVS.WHEEL_STEER_NONE
	data.Axle.SteerAngle = data.Axle.SteerAngle or 20

	data.Suspension.Height = data.Suspension.Height or 20
	data.Suspension.MaxTravel = data.Suspension.MaxTravel or data.Suspension.Height
	data.Suspension.ControlArmLength = data.Suspension.ControlArmLength or 25
	data.Suspension.SpringConstant = data.Suspension.SpringConstant or 20000
	data.Suspension.SpringDamping = data.Suspension.SpringDamping or 2000
	data.Suspension.SpringRelativeDamping = data.Suspension.SpringRelativeDamping or 2000
	data.Suspension.ElasticConstraints = {}

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
			local radius = Wheel:GetRadius()
			local X1 = math.cos( math.rad( ang ) ) * radius
			local Y1 = math.sin( math.rad( ang ) ) * radius

			local X2 = math.cos( math.rad( ang + AngleStep ) ) * radius
			local Y2 = math.sin( math.rad( ang + AngleStep ) ) * radius

			local P1 = Wheel:GetPos() + self:LocalToWorldAngles( data.Axle.ForwardAngle ):Up() * Y1 + self:LocalToWorldAngles( data.Axle.ForwardAngle ):Forward() * X1
			local P2 = Wheel:GetPos() + self:LocalToWorldAngles( data.Axle.ForwardAngle ):Up() * Y2 + self:LocalToWorldAngles( data.Axle.ForwardAngle ):Forward() * X2

			debugoverlay.Line( P1, P2, 5, Color( 150, 150, 150 ), true )
		end

		table.insert( data.Suspension.ElasticConstraints, Elastic )

		-- nocollide them with each other
		for i = id, #data.Wheels do
			local Ent = data.Wheels[ i ]
			if Ent == Wheel then continue end

			local nocollide = constraint.NoCollide(Ent,Wheel,0,0)
			nocollide.DoNotDuplicate = true
		end
	end

	self._WheelAxles[ self._WheelAxleID ] = data

	return self._WheelAxleID
end

function ENT:CreateSuspension( Wheel, CenterPos, DirectionAngle, data )
	if not IsValid( Wheel ) or not IsEntity( Wheel ) then return end

	if self:GetSolid() ~= SOLID_NONE then
		self:SetSolid( SOLID_NONE )
	end

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
	local Lock = 0.0001

	local Ballsocket = constraint.AdvBallsocket( Wheel, self,0,0,Vector(0,0,0),Vector(0,0,0),0,0, -Lock, -Lock, -Lock, Lock, Lock, Lock, 0, 0, 0, 1, 1)
	Ballsocket.DoNotDuplicate = true

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

	Wheel:SetSolid( SOLID_NONE )

	local Limiter = constraint.Rope(self,Wheel,0,0,self:WorldToLocal( Pos - Up * height * 0.5 - Right * LimiterLength), Vector(0,0,0),LimiterRopeLength, 0, 0, RopeSize,"cable/cable2", false )
	Limiter.DoNotDuplicate = true

	P1 = Wheel:GetPos() + Up * height * 2
	local Elastic = constraint.Elastic( Wheel, self, 0, 0, Vector(0,0,0), self:WorldToLocal( P1 ), constant, damping, rdamping,"cable/cable2", RopeSize, false ) 
	Elastic.DoNotDuplicate = true
	debugoverlay.SweptBox( P1, P2,- Vector(0,1,1), Vector(0,1,1), (P1 - P2):Angle(), 5, Color( 255, 255, 0 ), true )

	Wheel:SetPos( Pos )

	return Elastic
end
