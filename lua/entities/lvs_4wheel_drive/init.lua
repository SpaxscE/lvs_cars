AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	PObj:SetMass( 1000 )

	self:AddDriverSeat( Vector(-14,14.94,4.2394), Angle(0,-90,7.8) )
	self:AddPassengerSeat( Vector(-3,-14.94,13), Angle(0,-90,20) )

	local WheelModel = "models/props_vehicles/tire001c_car.mdl"
	local WheelRadius = 13

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT, --LVS.WHEEL_STEER_REAR   LVS.WHEEL_STEER_NONE
			SteerAngle = 35,
		},
		Wheels = {
			self:AddWheel( Vector(50.814,-29,12.057), Angle(0,-90,0), WheelModel, WheelRadius ),
			self:AddWheel( Vector(50.814,29,12.057), Angle(0,90,0), WheelModel, WheelRadius ),
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
		},
		Wheels = {
			self:AddWheel( Vector(-50.814,-29,12.057), Angle(0,-90,0), WheelModel, WheelRadius ),
			self:AddWheel( Vector(-50.814,29,12.057), Angle(0,90,0), WheelModel, WheelRadius ),
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

	self:AddEngine( {
		Pos = Vector(50,0,20),
		Ang = Angle(0,0,0),
		Specs = {
			IdleRPM = 600,
			LimitRPM = 7700,
			PeakTorque = 200,
			PowerbandStart = 1500,
			PowerbandEnd = 7400,
		},
	} )

	self:AddTransmission( {
		Pos = Vector(30,0,20),
		Ang = Angle(0,0,0),
		Gears = {
			Forward = {0.12,0.21,0.32,0.42,0.5},
			Reverse = {0.12},
			Differential = 0.6,
		},
		Axles = {
			[FrontAxle] = 0,
			[RearAxle] = 1,
		}
	} )
end
