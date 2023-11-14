AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(-6.5,12,16.5), Angle(0,-95,-8) )
	local PassengerSeat = self:AddPassengerSeat( Vector(13,-12,22), Angle(0,-85,15) )
	local PassengerSeat1 = self:AddPassengerSeat( Vector(-22,12,22), Angle(0,-90,15) )
	local PassengerSeat2 = self:AddPassengerSeat( Vector(-22,-12,22), Angle(0,-90,15) )

	local DoorHandler = self:AddDoorHandler( "left_door", Vector(10,21,35), Angle(0,0,0), Vector(-10,-3,-12), Vector(20,6,12), Vector(-10,-15,-12), Vector(20,30,12) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "right_door", Vector(20,-21,35), Angle(0,180,0), Vector(-10,-3,-12), Vector(20,6,12), Vector(-10,-15,-12), Vector(20,30,12) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat )

	local DoorHandler = self:AddDoorHandler( "rear_left_door", Vector(-20,21,35), Angle(0,0,0), Vector(-8,-3,-12), Vector(18,6,12), Vector(-8,-15,-12), Vector(18,30,12) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat1 )

	local DoorHandler = self:AddDoorHandler( "rear_right_door", Vector(-10,-21,35), Angle(0,180,0), Vector(-8,-3,-12), Vector(18,6,12), Vector(-8,-15,-12), Vector(18,30,12) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat2 )

	local DoorHandler = self:AddDoorHandler( "hatch", Vector(27.71,0,53), Angle(0,0,0), Vector(-5,-23,-5), Vector(5,23,7), Vector(-5,-23,-10), Vector(18,23,-3) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_open.wav" )

	local FuelCap = self:AddDoorHandler( "fuel_cap", Vector(46.84,-15.13,45.95), Angle(0,90,-70), Vector(-2,-0.5,-2), Vector(2,2,2), Vector(-2,-3,-2), Vector(2,2,5) )
	FuelCap:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	FuelCap:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )

	self:AddEngine( Vector(-56,0,37.5) )

	local FuelTank = self:AddFuelTank( Vector(-57.06,0,18.92), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL )
	FuelTank:SetDoorHandler( FuelCap )

	local WheelModel = "models/diggercars/kubel/kubelwagen_wheel.mdl"

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
				pos = Vector(53,-23,17.5),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),

			self:AddWheel( {
				pos = Vector(53,23,17.5),
				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),

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
				pos = Vector(-46.5,-25,15.5),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),

			self:AddWheel( {
				pos = Vector(-46.5,25,15.5),
				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),
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

	self:AddTrailerHitch( Vector(-74,0,16.5), LVS.HITCHTYPE_MALE )
end
