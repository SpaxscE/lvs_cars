AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	self:AddDriverSeat( Vector(0,0,50), Angle(0,-90,0) )

	self:AddEngine( Vector(-16.1,-81.68,47.25) )

	local WheelModelBig = "models/props_vehicles/tire001b_truck.mdl"
	local WheelModelSmall = "models/props_vehicles/tire001c_car.mdl"

	self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
			TorqueFactor = 0.1,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( { hide = false, pos = Vector(100,-45,45), mdl = WheelModelBig, mdl_ang = Angle(0,180,0) } ),
			self:AddWheel( { hide = false, pos = Vector(100,45,45), mdl = WheelModelBig, mdl_ang = Angle(0,0,0) } ),
			self:AddWheel( { hide = false, pos = Vector(60,-45,35), mdl = WheelModelSmall, mdl_ang = Angle(0,180,0) } ),
			self:AddWheel( { hide = false, pos = Vector(60,45,35), mdl = WheelModelSmall, mdl_ang = Angle(0,0,0) } ),
		},
		Suspension = {
			Height = 20,
			MaxTravel = 15,
			ControlArmLength = 150,
			SpringConstant = 20000,
			SpringDamping = 1000,
			SpringRelativeDamping = 2000,
		},
	} )

	self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 0.1,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( { hide = false, pos = Vector(30,-45,35), mdl = WheelModelSmall, mdl_ang = Angle(0,180,0) } ),
			self:AddWheel( { hide = false, pos = Vector(30,45,35), mdl = WheelModelSmall, mdl_ang = Angle(0,0,0) } ),
			self:AddWheel( { hide = false, pos = Vector(0,-45,35), mdl = WheelModelSmall, mdl_ang = Angle(0,180,0) } ),
			self:AddWheel( { hide = false, pos = Vector(0,45,35), mdl = WheelModelSmall, mdl_ang = Angle(0,0,0) } ),
		},
		Suspension = {
			Height = 20,
			MaxTravel = 15,
			ControlArmLength = 150,
			SpringConstant = 20000,
			SpringDamping = 1000,
			SpringRelativeDamping = 2000,
		},
	} )

	self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_REAR,
			SteerAngle = 30,
			TorqueFactor = 0.1,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( { hide = false, pos = Vector(-60,-45,35), mdl = WheelModelSmall, mdl_ang = Angle(0,180,0) } ),
			self:AddWheel( { hide = false, pos = Vector(-60,45,35), mdl = WheelModelSmall, mdl_ang = Angle(0,0,0) } ),
			self:AddWheel( { hide = false, pos = Vector(-30,-45,35), mdl = WheelModelSmall, mdl_ang = Angle(0,180,0) } ),
			self:AddWheel( { hide = false, pos = Vector(-30,45,35), mdl = WheelModelSmall, mdl_ang = Angle(0,0,0) } ),
		},
		Suspension = {
			Height = 20,
			MaxTravel = 15,
			ControlArmLength = 150,
			SpringConstant = 20000,
			SpringDamping = 1000,
			SpringRelativeDamping = 2000,
		},
	} )
end
