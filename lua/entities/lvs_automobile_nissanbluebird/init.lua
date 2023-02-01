AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	PObj:SetMass( 1000 )

	self:AddDriverSeat( Vector(-14,14.94,4.2394), Angle(0,-90,7.8) )
	self:AddPassengerSeat( Vector(-3,-14.94,13), Angle(0,-90,20) )

	local WheelModel = "models/diggercars/nissan_bluebird910/bluebird_rim.mdl"
	local WheelRadius = 12

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT, --LVS.WHEEL_STEER_REAR   LVS.WHEEL_STEER_NONE
			SteerAngle = 20,
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

	self:AddEngine( Vector(50,0,20) )

	self:AddTransmission( {
		PowerDistribution = 1,
		Gears = {
			Ratios = {2.45,1.45,1.0},
			ReverseRatio = 2.45,
			DifferentialRatio = 2.94,
		},
	} )
end
