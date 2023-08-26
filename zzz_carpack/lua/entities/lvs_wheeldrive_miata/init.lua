AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(-20,14,-1), Angle(0,-90,8) )
	local PassengerSeat = self:AddPassengerSeat( Vector(-8,-14,11), Angle(0,-90,28) )

	self:AddEngine( Vector(50,0,23) )
	self:AddFuelTank( Vector(-63,-0,25), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL )

	local DoorHandler = self:AddDoorHandler( "left_door", Vector(-15,29,25), Angle(0,0,0), Vector(-8,-6,-16), Vector(38,6,8), Vector(0,-20,-16), Vector(38,52,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/skyline/door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/skyline/door_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "right_door", Vector(-15,-29,25), Angle(0,0,0), Vector(-8,-6,-16), Vector(38,6,8), Vector(0,-52,-16), Vector(38,20,8) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/skyline/door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/skyline/door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat )

	local DoorHandler = self:AddDoorHandler( "hood", Vector(45,0,29), Angle(12,0,0), Vector(-20,-25,-3), Vector(24,25,3), Vector(-20,-25,-3), Vector(0,25,40) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

	local LightsHandler = self:GetLightsHandler()
	if IsValid( LightsHandler ) then
		local DoorHandler = self:AddDoorHandler( "lights", Vector(72,0,20), Angle(0,0,0), Vector(-5,-25,-5), Vector(5,25,5) )
		DoorHandler:SetRate( 4 )
		DoorHandler:SetRateExponent( 1 )

		LightsHandler:SetDoorHandler( DoorHandler )
	end

	local WheelModel = "models/diggercars/mazda_miata/miata_wheel.mdl"

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
				pos = Vector(47,28,10),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),

			self:AddWheel( {
				pos = Vector(47,-28,10),
				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),
			} ),
		},
		Suspension = {
			Height = 5,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 22000,
			SpringDamping = 2200,
			SpringRelativeDamping = 2200,
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
				pos = Vector(-44,28,14),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),

			self:AddWheel( {
				pos = Vector(-44,-28,14),
				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),
			} ),
		},
		Suspension = {
			Height = 9,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 22000,
			SpringDamping = 2200,
			SpringRelativeDamping = 2200,
		},
	} )
end
