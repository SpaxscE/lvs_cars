AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(-8,13.75,16.25), Angle(0,-95,-8) )
	local PassengerSeat = self:AddPassengerSeat( Vector(10,-13.75,20), Angle(0,-85,8) )
	local PassengerSeat1 = self:AddPassengerSeat( Vector(-27,13.5,20), Angle(0,-90,8) )
	local PassengerSeat2 = self:AddPassengerSeat( Vector(-27,-13.5,20), Angle(0,-90,8) )

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

	local DoorHandler = self:AddDoorHandler( "fuel_cap", Vector(46,-15.5,48.5), Angle(0,90,-70), Vector(-5,0,-5), Vector(5,5,5), Vector(-5,-5,-5), Vector(5,5,5) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )

	self:AddEngine( Vector(-56,0,37.5) )
	self:AddFuelTank( Vector(-57.06,0,18.92), 600, LVS.FUELTYPE_PETROL )

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
end
