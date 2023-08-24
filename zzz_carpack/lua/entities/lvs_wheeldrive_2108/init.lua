AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )

	local DriverSeat = self:AddDriverSeat( Vector(-7,12,5), Angle(0,-90,10) )
	local PassengerSeat = self:AddPassengerSeat( Vector(3,-12,15), Angle(0,-90,20) )

	self:AddEngine( Vector(55,0,28) )


	local DoorHandler = self:AddDoorHandler( "left_door", Vector(3,28,29), Angle(0,0,0), Vector(-20,-6,-16), Vector(28,6,8), Vector(-20,-20,-16), Vector(28,42,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "right_door", Vector(3,-28,29), Angle(0,0,0), Vector(-20,-6,-16), Vector(28,6,8), Vector(-20,-42,-16), Vector(28,20,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat )

	local DoorHandler = self:AddDoorHandler( "trunk", Vector(-65,0,43), Angle(-30,0,0), Vector(-15,-20,-3), Vector(20,20,3), Vector(10,-20,-3), Vector(20,20,40) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_trunk_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )

	local DoorHandler = self:AddDoorHandler( "hood", Vector(65,0,32), Angle(5,0,0), Vector(-30,-27,-3), Vector(5,27,3), Vector(-30,-27,-3), Vector(5,27,30) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

	local DoorHandler = self:AddDoorHandler( "fuel_cap", Vector(-68,-30,29), Angle(0,0,0), Vector(-5,0,-3), Vector(5,5,3), Vector(-5,-5,-3), Vector(5,5,3) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_door_close.wav" )


	local WheelModel = "models/DiggerCars/VAZ 2108 Sport/wheel2.mdl"

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
				pos = Vector(49,27.5,14.5),
				mdl = WheelModel,
				mdl_ang = Angle(-90,180,-90),
			} ),

			self:AddWheel( {
				pos = Vector(49,-27.5,14.5),
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
			TorqueFactor = 0,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-48.5,27,16),
				mdl = WheelModel,
				mdl_ang = Angle(-90,180,-90),
			} ),

			self:AddWheel( {
				pos = Vector(-48.5,-27,16),
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