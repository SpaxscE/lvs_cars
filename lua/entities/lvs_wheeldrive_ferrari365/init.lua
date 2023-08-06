AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(-26.6,14.5,0), Angle(0,-90,8) )
	local PassengerSeat = self:AddPassengerSeat( Vector(-14,-14,12), Angle(0,-90,28) )

	self:AddEngine( Vector(45,0,20) )

	local DoorHandler = self:AddDoorHandler( Vector(-10,32,24), Angle(0,0,0), Vector(-23,-6,-12), Vector(20,6,12), "left_door" )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/Open Door Exterior 01.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/Close Door Exterior 01.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( Vector(-10,-32,24), Angle(0,0,0), Vector(-23,-6,-12), Vector(20,6,12), "right_door" )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/Open Door Exterior 01.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/Close Door Exterior 01.wav" )
	DoorHandler:LinkToSeat( PassengerSeat )

	local DoorHandler = self:AddDoorHandler( Vector(-73,0,35), Angle(-10,0,0), Vector(-15,-20,-3), Vector(15,20,3), "trunk" )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/Trunk Open 01.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_old_door_close.wav" )

	local DoorHandler = self:AddDoorHandler( Vector(50,0,35), Angle(5,0,0), Vector(-25,-30,-3), Vector(25,30,3), "hood" )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/Open Hood 02.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/Close Hood 01.wav" )

	local WheelModel = "models/diggercars/ferrari_365/f365_wheel.mdl"

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
				pos = Vector(49.2,26.5,17),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),

			self:AddWheel( {
				pos = Vector(49.2,-26.5,17),
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
				pos = Vector(-49.2,26.5,17),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),

			self:AddWheel( {
				pos = Vector(-49.2,-26.5,17),
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