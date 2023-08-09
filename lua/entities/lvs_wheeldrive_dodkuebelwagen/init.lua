AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	self:AddDriverSeat( Vector(-8,13.75,16.25), Angle(0,-95,-8) )
	self:AddPassengerSeat( Vector(10,-13.75,20), Angle(0,-85,8) )

	local DoorHandler = self:AddDoorHandler( "left_door", Vector(15,32,35), Angle(0,0,0), Vector(-10,-6,-12), Vector(20,6,12), Vector(-20,-25,-12), Vector(20,40,12) )
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

	local DoorHandler = self:AddDoorHandler( "fuel_cap", Vector(-50,-32.5,29.5), Angle(0,0,-30), Vector(-5,0,-5), Vector(5,5,5), Vector(-5,-5,-5), Vector(5,5,5) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )

	self:AddEngine( Vector(-56,0,37.5) )

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

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/kuebelwagen/engine_start.wav" )
	else
		self:EmitSound( "lvs/vehicles/kuebelwagen/engine_stop.wav" )
	end
end