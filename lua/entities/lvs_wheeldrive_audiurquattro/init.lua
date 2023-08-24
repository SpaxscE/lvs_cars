AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(-8,12,-7), Angle(0,-90,10) )
	local PassengerSeat = self:AddPassengerSeat( Vector(2,-12,1), Angle(0,-90,20) )

	self:AddEngine( Vector(60,0,15) )
	self:AddTurboCharger()


	local DoorHandler = self:AddDoorHandler( "left_door", Vector(0,30,19), Angle(0,0,0), Vector(-15,-6,-16), Vector(32,6,8), Vector(-15,-20,-16), Vector(32,42,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "right_door", Vector(0,-30,19), Angle(0,0,0), Vector(-15,-6,-16), Vector(32,6,8), Vector(-15,-42,-16), Vector(32,20,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat )

	local DoorHandler = self:AddDoorHandler( "trunk", Vector(-83,0,30), Angle(0,0,0), Vector(-4,-28,-20), Vector(10,28,3), Vector(-4,-28,-3), Vector(10,28,20) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_trunk_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )

	local DoorHandler = self:AddDoorHandler( "hood", Vector(65,0,23), Angle(5,0,0), Vector(-30,-27,-3), Vector(15,27,3), Vector(-30,-27,-3), Vector(0,27,40) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )



	local WheelModel = "models/diggercars/a_sportquattro/wheel.mdl"

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
				pos = Vector(52.5,26,6),
				mdl = WheelModel,
				mdl_ang = Angle(-90,180,-90),
			} ),

			self:AddWheel( {
				pos = Vector(52.5,-26,6),
				mdl = WheelModel,
				mdl_ang = Angle(-90,0,-90),
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
				pos = Vector(-50,27,4),
				mdl = WheelModel,
				mdl_ang = Angle(-90,180,-90),
			} ),

			self:AddWheel( {
				pos = Vector(-50,-27,4),
				mdl = WheelModel,
				mdl_ang = Angle(-90,0,-90),
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