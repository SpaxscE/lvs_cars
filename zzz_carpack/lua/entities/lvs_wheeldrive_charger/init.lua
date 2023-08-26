AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(-7,15.5,-3), Angle(0,-90,8) )
	local PassengerSeat = self:AddPassengerSeat( Vector(4,-15,9), Angle(0,-90,28) )

	self:AddEngine( Vector(64.5,0,20.24) )
	--self:AddSuperCharger()

	local DoorHandler = self:AddDoorHandler( "left_door", Vector(0,33,20), Angle(0,0,0), Vector(-15,-6,-16), Vector(38,6,8), Vector(-15,-20,-16), Vector(38,42,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "right_door", Vector(0,-33,20), Angle(0,0,0), Vector(-15,-6,-16), Vector(38,6,8), Vector(-15,-42,-16), Vector(38,20,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat )

	local DoorHandler = self:AddDoorHandler( "trunk", Vector(-83,0,30), Angle(-8,0,0), Vector(-20,-28,-3), Vector(10,28,3), Vector(-10,-28,-3), Vector(10,28,30) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_trunk_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )

	local DoorHandler = self:AddDoorHandler( "hood", Vector(75,0,26), Angle(5,0,0), Vector(-30,-30,-3), Vector(29,30,3), Vector(-30,-30,-3), Vector(0,30,50) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

	local LightsHandler = self:GetLightsHandler()
	if IsValid( LightsHandler ) then
		local DoorHandler = self:AddDoorHandler( "lights", Vector(103,0,15), Angle(0,0,0), Vector(-5,-35,-5), Vector(5,35,5) )
		DoorHandler:SetRate( 1 )
		DoorHandler:SetRateExponent( 2 )

		LightsHandler:SetDoorHandler( DoorHandler )
	end

	self:AddFuelTank( Vector(-86,0,19.5), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL )

	local WheelModel = "models/diggercars/dodge_charger/wh.mdl"

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
			TorqueFactor = 0,
			BrakeFactor = 1,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(66.5,32,1),
				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),
			} ),

			self:AddWheel( {
				pos = Vector(66.5,-32,1),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),
		},
		Suspension = {
			Height = 6,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )

	local RearAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 1,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-53,32,6),
				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),
			} ),

			self:AddWheel( {
				pos = Vector(-53,-32,6),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),
		},
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )
end

function ENT:OnSuperCharged( enable )
	if enable then
		self:SetBodygroup(10,1)
		self:SetBodygroup(2,3)
	else
		self:SetBodygroup(10,0)
		self:SetBodygroup(2,0)
	end
end


