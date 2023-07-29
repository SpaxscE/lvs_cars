AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	PObj:SetMass( 1000 )
	PObj:EnableDrag( false )

	self:AddDriverSeat( Vector(-29,17.5,21), Angle(0,-90,-10) )
	self:AddPassengerSeat( Vector(-11,-17.5,24), Angle(0,-90,10) )

	self:AddEngine( Vector(-45,0,30) )

	local WheelModel = "models/diggercars/willys/wh.mdl"
	local WheelRadius = 13

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
			TorqueFactor = 0.4,
			BrakeFactor = 1,
		},
		Wheels = {
			self:AddWheel( Vector(49.5,-27,14), Angle(0,90,0), WheelModel, WheelRadius ),
			self:AddWheel( Vector(49.5,27,14), Angle(0,-90,0), WheelModel, WheelRadius ),
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
			TorqueFactor = 0.6,
			BrakeFactor = 1,
		},
		Wheels = {
			self:AddWheel( Vector(-37,-27,14), Angle(0,90,0), WheelModel, WheelRadius ),
			self:AddWheel( Vector(-37,27,14), Angle(0,-90,0), WheelModel, WheelRadius ),
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