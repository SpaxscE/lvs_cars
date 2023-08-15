AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	self:AddDriverSeat( Vector(0,0,0), Angle(0,0,0) )

	self:AddEngine( Vector(-16.1,-81.68,47.25) )

	local WheelModel = "models/props_vehicles/tire001c_car.mdl"

	self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,90,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
			TorqueFactor = 0.1,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( { hide = true, pos = Vector(-45,80,-10), mdl = WheelModel, mdl_ang = Angle(0,180,0) } ),
			self:AddWheel( { hide = true, pos = Vector(45,80,-10), mdl = WheelModel, mdl_ang = Angle(0,0,0) } ),
			self:AddWheel( { hide = true, pos = Vector(-45,40,-10), mdl = WheelModel, mdl_ang = Angle(0,180,0) } ),
			self:AddWheel( { hide = true, pos = Vector(45,40,-10), mdl = WheelModel, mdl_ang = Angle(0,0,0) } ),
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
			ForwardAngle = Angle(0,90,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 0.1,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( { hide = true, pos = Vector(-45,0,-10), mdl = WheelModel, mdl_ang = Angle(0,180,0) } ),
			self:AddWheel( { hide = true, pos = Vector(45,0,-10), mdl = WheelModel, mdl_ang = Angle(0,0,0) } ),
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
			ForwardAngle = Angle(0,90,0),
			SteerType = LVS.WHEEL_STEER_REAR,
			SteerAngle = 30,
			TorqueFactor = 0.1,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( { hide = true, pos = Vector(-45,-80,-10), mdl = WheelModel, mdl_ang = Angle(0,180,0) } ),
			self:AddWheel( { hide = true, pos = Vector(45,-80,-10), mdl = WheelModel, mdl_ang = Angle(0,0,0) } ),
			self:AddWheel( { hide = true, pos = Vector(-45,-40,-10), mdl = WheelModel, mdl_ang = Angle(0,180,0) } ),
			self:AddWheel( { hide = true, pos = Vector(45,-40,-10), mdl = WheelModel, mdl_ang = Angle(0,0,0) } ),
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
