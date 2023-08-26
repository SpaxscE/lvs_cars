AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(8,14.5,0), Angle(0,-90,10) )
	local PassengerSeat = self:AddPassengerSeat( Vector(19,-14.5,10), Angle(0,-90,20) )
	local PassengerSeat1 = self:AddPassengerSeat( Vector(-20,14.5,10), Angle(0,-90,20) )
	local PassengerSeat2 = self:AddPassengerSeat( Vector(-20,-14.5,10), Angle(0,-90,20) )

	self:AddEngine( Vector(78,0,30) )

	local DoorHandler = self:AddDoorHandler( "left_door", Vector(25,32,20), Angle(0,0,0), Vector(-20,-6,-12), Vector(20,6,12), Vector(-20,-25,-12), Vector(20,40,12) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "right_door", Vector(25,-32,20), Angle(0,0,0), Vector(-20,-6,-12), Vector(20,6,12), Vector(-20,-40,-12), Vector(20,25,12) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat )

	local DoorHandler = self:AddDoorHandler( "rear_left_door", Vector(-15,32,20), Angle(0,0,0), Vector(-20,-6,-12), Vector(20,6,12), Vector(-20,-25,-12), Vector(20,40,12) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat1 )

	local DoorHandler = self:AddDoorHandler( "rear_right_door", Vector(-15,-32,20), Angle(0,0,0), Vector(-20,-6,-12), Vector(20,6,12), Vector(-20,-40,-12), Vector(20,25,12) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat2 )

	local DoorHandler = self:AddDoorHandler( "trunk", Vector(-73,0,30), Angle(-5,0,0), Vector(-15,-25,-3), Vector(15,25,3), Vector(-15,-25,-3), Vector(15,25,25) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_trunk_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )

	local DoorHandler = self:AddDoorHandler( "hood", Vector(75,0,30), Angle(5,0,0), Vector(-25,-30,-20), Vector(25,30,3), Vector(-25,-30,-3), Vector(25,30,40) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

	local FuelCap = self:AddDoorHandler( "fuel_cap", Vector(-50,-32.5,29.5), Angle(0,0,-30), Vector(-5,0,-5), Vector(5,5,5), Vector(-5,-5,-5), Vector(5,5,5) )
	FuelCap:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	FuelCap:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )

	local FuelTank = self:AddFuelTank( Vector(-72,0,14), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL )
	FuelTank:SetDoorHandler( FuelCap )

	local WheelModel = "models/diggercars/mb_w123/wheel.mdl"

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
				pos = Vector(73.4,23.5,10),
				mdl = WheelModel,
				mdl_ang = Angle(-90,0,-90),
			} ),

			self:AddWheel( {
				pos = Vector(73.4,-23.5,10),
				mdl = WheelModel,
				mdl_ang = Angle(-90,180,-90),
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
				pos = Vector(-42.6,23.5,8),
				mdl = WheelModel,
				mdl_ang = Angle(-90,0,-90),
			} ),

			self:AddWheel( {
				pos = Vector(-42.6,-23.5,8),
				mdl = WheelModel,
				mdl_ang = Angle(-90,180,-90),
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

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/kuebelwagen/engine_start.wav" )
	else
		self:EmitSound( "lvs/vehicles/kuebelwagen/engine_stop.wav" )
	end
end