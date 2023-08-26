AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(-12,-15,3), Angle(0,-90,8) )
	local PassengerSeat = self:AddPassengerSeat( Vector(0,15,15), Angle(0,-90,28) )

	self:AddEngine( Vector(62,0,35) )
	self:AddTurboCharger()

	self:AddFuelTank( Vector(-70,0,25), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL )


	local DoorHandler = self:AddDoorHandler( "left_door", Vector(-15,29,29), Angle(0,0,0), Vector(-8,-6,-16), Vector(46,6,8), Vector(0,-20,-16), Vector(46,52,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/skyline/door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/skyline/door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat )

	local DoorHandler = self:AddDoorHandler( "right_door", Vector(-15,-29,29), Angle(0,0,0), Vector(-8,-6,-16), Vector(46,6,8), Vector(0,-52,-16), Vector(46,20,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/skyline/door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/skyline/door_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "hood", Vector(63,0,35), Angle(10,0,0), Vector(-27,-28,-3), Vector(24,28,3), Vector(-27,-28,-3), Vector(10,28,40) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

	local FuelCap = self:AddDoorHandler( "fuel_cap", Vector(-66,-36.5,33), Angle(0,0,0), Vector(-5,0,-3), Vector(5,5,3), Vector(-5,-5,-3), Vector(5,5,3) )
	FuelCap:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	FuelCap:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )

	local DoorHandler = self:AddDoorHandler( "trunk", Vector(-70,0,40), Angle(0,0,0), Vector(-20,-28,-10), Vector(10,28,3), Vector(-20,-28,-3), Vector(10,28,20) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_trunk_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )



	local WheelModel = "models/diggercars/nissan_skyline_gtr34/gtr_wheel.mdl"

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
			TorqueFactor = 0.2,
			BrakeFactor = 1,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(54,28,12),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),

			self:AddWheel( {
				pos = Vector(54,-28,12),
				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),
			} ),
		},
		Suspension = {
			Height = 4,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 30000,
			SpringDamping = 3000,
			SpringRelativeDamping = 3900,
		},
	} )

	local RearAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 0.8,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-52.5,28,15),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),

			self:AddWheel( {
				pos = Vector(-52.5,-28,15),
				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),
			} ),
		},
		Suspension = {
			Height = 8,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 30000,
			SpringDamping = 3000,
			SpringRelativeDamping = 3900,
		},
	} )
end
