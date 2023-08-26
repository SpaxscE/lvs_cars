AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(-12,14.5,-3), Angle(0,-90,8) )
	local PassengerSeat = self:AddPassengerSeat( Vector(0,-14.5,8), Angle(0,-90,28) )

	self:AddEngine( Vector(65,0,25) )

	local DoorHandler = self:AddDoorHandler( "trunk", Vector(-70,0,25), Angle(-5,0,0), Vector(-20,-28,-3), Vector(10,28,3), Vector(-10,-28,-3), Vector(10,28,30) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_trunk_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )

	local DoorHandler = self:AddDoorHandler( "hood", Vector(45,0,28), Angle(5,0,0), Vector(-20,-30,-3), Vector(39,30,3), Vector(10,-30,-3), Vector(39,30,50) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

	local FuelCap = self:AddDoorHandler( "fuel_cap", Vector(-80,-33.5,20), Angle(0,0,0), Vector(-5,0,-3), Vector(5,5,3), Vector(-5,-5,-3), Vector(5,5,3) )
	FuelCap:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	FuelCap:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )

	local FuelTank = self:AddFuelTank( Vector(-75,0,12), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL )
	FuelTank:SetDoorHandler( FuelCap )

	local WheelModel = "models/diggercars/bmw_e9/e9_wheel.mdl"

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
				pos = Vector(54,28,5),
				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),
			} ),

			self:AddWheel( {
				pos = Vector(54,-28,5),
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
				pos = Vector(-52,28,8),
				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),
			} ),

			self:AddWheel( {
				pos = Vector(-52,-28,8),
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
