AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(-10,15,-1), Angle(0,-90,10) )
	local PassengerSeat = self:AddPassengerSeat( Vector(0,-15,8), Angle(0,-90,20) )
	local PassengerSeat1 = self:AddPassengerSeat( Vector(-33,15,8), Angle(0,-90,20) )
	local PassengerSeat2 = self:AddPassengerSeat( Vector(-33,-15,8), Angle(0,-90,20) )

	self:AddEngine( Vector(62,0,20) )

	local DoorHandler = self:AddDoorHandler( "left_door", Vector(10,32,17), Angle(2,0,0), Vector(-20,-6,-12), Vector(20,6,12), Vector(-20,-25,-12), Vector(20,40,12) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "right_door", Vector(10,-32,17), Angle(2,0,0), Vector(-20,-6,-12), Vector(20,6,12), Vector(-20,-40,-12), Vector(20,25,12) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat )

	local DoorHandler = self:AddDoorHandler( "rear_left_door", Vector(-30,32,19), Angle(2,0,0), Vector(-20,-6,-12), Vector(20,6,12), Vector(-20,-25,-12), Vector(20,40,12) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat1 )

	local DoorHandler = self:AddDoorHandler( "rear_right_door", Vector(-30,-32,19), Angle(2,0,0), Vector(-20,-6,-12), Vector(20,6,12), Vector(-20,-40,-12), Vector(20,25,12) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat2 )

	local DoorHandler = self:AddDoorHandler( "trunk", Vector(-90,0,20), Angle(0,0,0), Vector(-10,-20,-3), Vector(15,20,15), Vector(-10,-25,-3), Vector(15,25,35) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_trunk_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )
	DoorHandler:SetRate( 5 )
	DoorHandler:SetRateExponent( 3 )

	local DoorHandler = self:AddDoorHandler( "hood", Vector(60,0,25), Angle(3,0,0), Vector(-25,-30,-3), Vector(25,30,3), Vector(-25,-30,-3), Vector(30,30,45) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:SetRate( 3 )
	DoorHandler:SetRateExponent( 3 )

	local FuelCap = self:AddDoorHandler( "fuel_cap", Vector(-74,-38,21), Angle(0,0,0), Vector(-5,0,-5), Vector(5,5,5), Vector(-5,-5,-5), Vector(5,5,5) )
	FuelCap:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	FuelCap:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )

	local FuelTank = self:AddFuelTank( Vector(-80,0,10), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL )
	FuelTank:SetDoorHandler( FuelCap )

	local WheelModel = "models/diggercars/bmw_m5e34/e34_shit_wheel.mdl"

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
			TorqueFactor = 0.36,
			BrakeFactor = 1,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(56,30,10.5),
				mdl = WheelModel,
				mdl_ang = Angle(-90,180,-90),
			} ),

			self:AddWheel( {
				pos = Vector(56,-30,10.5),
				mdl = WheelModel,
				mdl_ang = Angle(-90,0,-90),
			} ),
		},
		Suspension = {
			Height = 15,
			MaxTravel = 10,
			ControlArmLength = 25,
			SpringConstant = 15000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )

	local RearAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 0.64,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-56,30,7),
				mdl = WheelModel,
				mdl_ang = Angle(-90,180,-90),
			} ),

			self:AddWheel( {
				pos = Vector(-56,-30,7),
				mdl = WheelModel,
				mdl_ang = Angle(-90,0,-90),
			} ),
		},
		Suspension = {
			Height = 10,
			MaxTravel = 10,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )
end
