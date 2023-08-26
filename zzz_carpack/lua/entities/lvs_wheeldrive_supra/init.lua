AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(-17,-14,0), Angle(0,-90,8) )
	local PassengerSeat = self:AddPassengerSeat( Vector(-5,14,12), Angle(0,-90,28) )

	self:AddEngine( Vector(50,0,28) )
	self:AddFuelTank( Vector(-70,0,16), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL )
	self:AddTurboCharger()

	local DoorHandler = self:AddDoorHandler( "left_door", Vector(-20,29,28), Angle(0,0,0), Vector(-8,-6,-16), Vector(46,6,8), Vector(0,-20,-16), Vector(46,52,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/skyline/door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/skyline/door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat )

	local DoorHandler = self:AddDoorHandler( "right_door", Vector(-20,-29,28), Angle(0,0,0), Vector(-8,-6,-16), Vector(46,6,8), Vector(0,-52,-16), Vector(46,20,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/skyline/door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/skyline/door_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "hood", Vector(53,0,32), Angle(10,0,0), Vector(-27,-28,-3), Vector(24,28,3), Vector(-27,-28,-3), Vector(10,28,40) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

	local FuelCap = self:AddDoorHandler( "fuel_cap", Vector(-68,-35.5,29), Angle(0,0,0), Vector(-5,0,-3), Vector(5,5,3), Vector(-5,-5,-3), Vector(5,5,3) )
	FuelCap:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	FuelCap:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )

	local WheelModel = "models/diggercars/toyota_supra/supra_wheel.mdl"

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
				pos = Vector(51.4,29,12),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),

			self:AddWheel( {
				pos = Vector(51.4,-29,12),
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
			TorqueFactor = 1,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-50.5,29.5,15),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),

			self:AddWheel( {
				pos = Vector(-50.5,-29.5,15),
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
