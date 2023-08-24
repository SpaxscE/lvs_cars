AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )

	local DriverSeat = self:AddDriverSeat( Vector(-10,16,-1), Angle(0,-90,10) )
	local PassengerSeat = self:AddPassengerSeat( Vector(0,-16,8), Angle(0,-90,20) )
	self:AddSuperCharger()

	local DoorHandler = self:AddDoorHandler( "left_door", Vector(-5,35,22), Angle(0,0,0), Vector(-15,-6,-16), Vector(32,6,8), Vector(-15,-20,-16), Vector(32,42,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "right_door", Vector(-5,-35,22), Angle(0,0,0), Vector(-15,-6,-16), Vector(32,6,8), Vector(-15,-42,-16), Vector(32,20,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat )

	local DoorHandler = self:AddDoorHandler( "hood", Vector(65,0,28), Angle(5,0,0), Vector(-30,-27,-3), Vector(25,27,3), Vector(-30,-27,-3), Vector(0,27,40) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )


	self:AddEngine( Vector(65,0,25) )

	local WheelModel = "models/diggercars/highwayman/wheel.mdl"

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
				pos = Vector(59.1,32,7),
				mdl = WheelModel,
				mdl_ang = Angle(-90,180,90),
			} ),

			self:AddWheel( {
				pos = Vector(59.1,-32,7),
				mdl = WheelModel,
				mdl_ang = Angle(-90,0,90),
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
				pos = Vector(-59.5,32,8),
				mdl = WheelModel,
				mdl_ang = Angle(-90,180,90),
			} ),

			self:AddWheel( {
				pos = Vector(-59.5,-32,8),
				mdl = WheelModel,
				mdl_ang = Angle(-90,0,90),
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
