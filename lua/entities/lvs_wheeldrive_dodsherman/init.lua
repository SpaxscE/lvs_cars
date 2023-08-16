AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	self:AddDriverSeat( Vector(0,0,50), Angle(0,-90,0) )

	self:AddEngine( Vector(-79.66,0,72.21) )

	local WheelModel = "models/props_vehicles/tire001c_car.mdl"
	local WheelModelCorner = "models/props_vehicles/tire001b_truck.mdl"

	local L1 = self:AddWheel( { hide = true, pos = Vector(100,42,45), mdl = WheelModelCorner } )
	local L2 = self:AddWheel( { hide = true, pos = Vector(60,42,35), mdl = WheelModel } )
	local L3 = self:AddWheel( { hide = true, pos = Vector(30,42,35), mdl = WheelModel } )
	local L4 = self:AddWheel( { hide = true, pos = Vector(0,42,35), mdl = WheelModel } )
	local L5 = self:AddWheel( { hide = true, pos = Vector(-30,42,30), mdl = WheelModel } )
	local L6 = self:AddWheel( { hide = true, pos = Vector(-80,42,45), mdl = WheelModelCorner } )

	self:CreateWheelChain( {L1, L6} )
	self:CreateWheelChain( {L2, L3, L4, L5} )
	self:SetDriveWheelFL( L4 )

	local R1 = self:AddWheel( { hide = true, pos = Vector(100,-42,45), mdl = WheelModelCorner } )
	local R2 = self:AddWheel( { hide = true, pos = Vector(60,-42,35), mdl = WheelModel } )
	local R3 = self:AddWheel( { hide = true, pos = Vector(30,-42,35), mdl = WheelModel } )
	local R4 = self:AddWheel( { hide = true, pos = Vector(0,-42,35), mdl = WheelModel } )
	local R5 = self:AddWheel( { hide = true, pos = Vector(-30,-42,30), mdl = WheelModel } )
	local R6 = self:AddWheel( { hide = true, pos = Vector(-80,-42,45), mdl = WheelModelCorner } )

	self:CreateWheelChain( {R1, R6} )
	self:CreateWheelChain( {R2, R3, R4, R5} )
	self:SetDriveWheelFR( R4 )

	self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 25,
			TorqueFactor = 0.5,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = { R1, L1 },
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
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 25,
			TorqueFactor = 0.125,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = { R2, L2 },
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
			TorqueFactor = 0.125,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = { R3, L3, L4, R4 },
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
			SteerAngle = 25,
			TorqueFactor = 0.125,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = { R5, L5 },
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
			SteerAngle = 25,
			TorqueFactor = 0.5,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = { R6, L6 },
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

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/sherman/engine_start.wav" )
	end
end