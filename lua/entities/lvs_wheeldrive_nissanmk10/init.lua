AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	self:AddDriverSeat( Vector(-7,12,5), Angle(0,-90,10) )
	self:AddPassengerSeat( Vector(3,-12,15), Angle(0,-90,20) )

	self:AddEngine( Vector(45,0,20) )

	local WheelModel = "models/DiggerCars/nissan_mk10/wheel.mdl"

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
				pos = Vector(49,27.5,15),
				mdl = WheelModel,
				mdl_ang = Angle(-90,180,-90),
			} ),

			self:AddWheel( {
				pos = Vector(49,-27.5,15),
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
			TorqueFactor = 1,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-48.5,27,15),
				mdl = WheelModel,
				mdl_ang = Angle(-90,180,-90),
			} ),

			self:AddWheel( {
				pos = Vector(-48.5,-27,15),
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