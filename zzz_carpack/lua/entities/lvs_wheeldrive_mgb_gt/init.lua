AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(-18.6,11.2,-8), Angle(0,-90,8) )
	local PassengerSeat = self:AddPassengerSeat( Vector(-4,-11,4), Angle(0,-90,28) )

	self:AddEngine( Vector(45,0,20) )

	local DoorHandler = self:AddDoorHandler( "left_door", Vector(0,28,16), Angle(0,0,0), Vector(-23,-6,-12), Vector(14,6,8), Vector(-25,-20,-8), Vector(15,32,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "right_door", Vector(0,-28,16), Angle(0,0,0), Vector(-23,-6,-12), Vector(14,6,8), Vector(-25,-32,-8), Vector(15,20,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat )

	local DoorHandler = self:AddDoorHandler( "trunk", Vector(-55,0,35), Angle(-30,0,0), Vector(-25,-20,-3), Vector(15,20,3), Vector(-15,-20,-3), Vector(15,20,25) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_trunk_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )

	local DoorHandler = self:AddDoorHandler( "hood", Vector(50,0,22), Angle(5,0,0), Vector(-30,-30,-3), Vector(25,30,3), Vector(-25,-30,-3), Vector(25,30,55) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

	local WheelModel = "models/diggercars/mg_mgb/wheel.mdl"

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
				pos = Vector(48.8,26.5,6),
				mdl = WheelModel,
				mdl_ang = Angle(90,180,90),
			} ),

			self:AddWheel( {
				pos = Vector(48.8,-26.5,6),
				mdl = WheelModel,
				mdl_ang = Angle(90,0,90),
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
				pos = Vector(-44.2,26.5,7),
				mdl = WheelModel,
				mdl_ang = Angle(90,180,90),
			} ),

			self:AddWheel( {
				pos = Vector(-44.2,-26.5,7),
				mdl = WheelModel,
				mdl_ang = Angle(90,0,90),
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
