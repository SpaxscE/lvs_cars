AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	PObj:SetMass( 1000 )

	self:AddDriverSeat( Vector(-14,14.94,4.2394), Angle(0,-90,7.8) )
	self:AddPassengerSeat( Vector(-3,-14.94,13), Angle(0,-90,20) )

	self:AddEngine( Vector(50,0,20) )

	local WheelModel = "models/diggercars/nissan_bluebird910/bluebird_rim.mdl"
	local WheelRadius = 12

	local FrontRight = self:AddWheel( Vector(50.814,-29,12.057), Angle(0,-90,0), WheelModel, WheelRadius )
	local FrontLeft = self:AddWheel( Vector(50.814,29,12.057), Angle(0,90,0), WheelModel, WheelRadius )

	local RearRight = self:AddWheel( Vector(-50.814,-29,12.057), Angle(0,-90,0), WheelModel, WheelRadius )
	local RearLeft = self:AddWheel( Vector(-50.814,29,12.057), Angle(0,90,0), WheelModel, WheelRadius )

	local FrontAxle = {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT, --LVS.WHEEL_STEER_REAR   LVS.WHEEL_STEER_NONE
			SteerAngle = 20,
		},
		Wheels = {
			FrontRight,
			FrontLeft,
		},
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	}
	self:DefineAxle( FrontAxle )


	local RearAxle = {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
		},
		Wheels = {
			RearRight,
			RearLeft,
		},
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	}
	self:DefineAxle( RearAxle )
end
