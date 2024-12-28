AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

ENT.LeanAngleIdle = -10
ENT.LeanAnglePark = 10

function ENT:OnSpawn( PObj )
	self:AddDriverSeat( Vector(-10,0,23), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(-25,0,24), Angle(0,-90,-5) )

	self:AddEngine( Vector(14,0,10) )
	self:AddFuelTank( Vector(13.84,0,26.21), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL, Vector(-10,-5,-4),Vector(8,5,4) )

	local WheelModel = "models/diggercars/bmw_r75/r75_wheel.mdl"

	local FWheel = self:AddWheel( { hide = true, pos = Vector(38,0,12), mdl = WheelModel, mdl_ang = Angle(0,0,0), width = 2 } )
	local RWheel = self:AddWheel( { hide = true, pos = Vector(-14,0,11), mdl = WheelModel, mdl_ang = Angle(0,0,0), width = 2 } )

	self:CreateRigControler( "fl", FWheel, 5, 13 )
	self:CreateRigControler( "rl", RWheel, 5, 13 )

	local FrontAxle = self:DefineAxle( {
		Axle = {
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
			TorqueFactor = 0,
			BrakeFactor = 1,
		},
		Wheels = { FWheel },
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 10000,
			SpringDamping = 800,
			SpringRelativeDamping = 800,
		},
	} )

	local RearAxle = self:DefineAxle( {
		Axle = {
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 1,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = { RWheel },
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 10000,
			SpringDamping = 800,
			SpringRelativeDamping = 800,
		},
	} )
end
