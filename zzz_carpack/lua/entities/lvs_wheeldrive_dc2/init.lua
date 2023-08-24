AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(-12,-15.2,2), Angle(0,-90,10) )
	local PassengerSeat = self:AddPassengerSeat( Vector(-2,15.2,12), Angle(0,-90,20) )

	self:AddEngine( Vector(65,0,20) )

	local DoorHandler = self:AddDoorHandler( "left_door", Vector(0,31,26), Angle(0,0,0), Vector(-25,-6,-16), Vector(32,6,8), Vector(-25,-20,-16), Vector(32,42,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat )

	local DoorHandler = self:AddDoorHandler( "right_door", Vector(0,-31,26), Angle(0,0,0), Vector(-25,-6,-16), Vector(32,6,8), Vector(-25,-42,-16), Vector(32,20,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "trunk", Vector(-70,0,40), Angle(-8,0,0), Vector(-15,-25,-3), Vector(10,25,3), Vector(-15,-30,-3), Vector(10,30,40) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_trunk_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )

	local DoorHandler = self:AddDoorHandler( "hood", Vector(65,0,30), Angle(10,0,0), Vector(-30,-30,-3), Vector(20,30,3), Vector(-30,-30,-3), Vector(0,30,40) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

	local WheelModel = "models/DiggerCars/honda_integra_dc2/dc2_wheel.mdl"

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
			TorqueFactor = 1,
			BrakeFactor = 1,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(52,28,16),
				mdl = WheelModel,
				mdl_ang = Angle(-90,0,-90),
			} ),

			self:AddWheel( {
				pos = Vector(52,-28,16),
				mdl = WheelModel,
				mdl_ang = Angle(-90,180,-90),
			} ),
		},
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 25000,
			SpringDamping = 2400,
			SpringRelativeDamping = 2400,
		},
	} )

	local RearAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 0,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-54,28,18),
				mdl = WheelModel,
				mdl_ang = Angle(-90,0,-90),
			} ),

			self:AddWheel( {
				pos = Vector(-54,-28,18),
				mdl = WheelModel,
				mdl_ang = Angle(-90,180,-90),
			} ),
		},
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 25000,
			SpringDamping = 2400,
			SpringRelativeDamping = 2400,
		},
	} )
end
