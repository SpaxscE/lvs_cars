AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	self:AddDriverSeat( Vector(0,0,50), Angle(0,-90,0) )

	self:AddEngine( Vector(-79.66,0,72.21) )

	local WheelModel = "models/props_vehicles/tire001c_car.mdl"

	self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 25,
			TorqueFactor = 0.1,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( { hide = true, pos = Vector(100,-42,45), mdl = "models/props_vehicles/tire001b_truck.mdl", mdl_ang = Angle(0,180,0) } ),
			self:AddWheel( { hide = true, pos = Vector(100,42,45), mdl = "models/props_vehicles/tire001b_truck.mdl", mdl_ang = Angle(0,0,0) } ),
			self:AddWheel( { hide = true, pos = Vector(60,-42,35), mdl = WheelModel, mdl_ang = Angle(0,180,0) } ),
			self:AddWheel( { hide = true, pos = Vector(60,42,35), mdl = WheelModel, mdl_ang = Angle(0,0,0) } ),
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

	
	local DriveWheelFL = self:AddWheel( { hide = true, pos = Vector(0,42,35), mdl = WheelModel, mdl_ang = Angle(0,180,0) } )
	local DriveWheelFR = self:AddWheel( { hide = true, pos = Vector(0,-42,35), mdl = WheelModel, mdl_ang = Angle(0,0,0) } )

	self:SetDriveWheelFL( DriveWheelFL )
	self:SetDriveWheelFR( DriveWheelFR )

	self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 0.25,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( { hide = true, pos = Vector(30,-42,35), mdl = WheelModel, mdl_ang = Angle(0,180,0) } ),
			self:AddWheel( { hide = true, pos = Vector(30,42,35), mdl = WheelModel, mdl_ang = Angle(0,0,0) } ),
			DriveWheelFL,
			DriveWheelFR,
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
			SteerAngle = 25,
			TorqueFactor = 0.1,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( { hide = true, pos = Vector(-80,-42,45), mdl = "models/props_vehicles/tire001b_truck.mdl", mdl_ang = Angle(0,180,0) } ),
			self:AddWheel( { hide = true, pos = Vector(-80,42,45), mdl = "models/props_vehicles/tire001b_truck.mdl", mdl_ang = Angle(0,0,0) } ),
			self:AddWheel( { hide = true, pos = Vector(-30,-42,30), mdl = WheelModel, mdl_ang = Angle(0,180,0) } ),
			self:AddWheel( { hide = true, pos = Vector(-30,42,30), mdl = WheelModel, mdl_ang = Angle(0,0,0) } ),
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

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/sherman/engine_start.wav" )
	end
end