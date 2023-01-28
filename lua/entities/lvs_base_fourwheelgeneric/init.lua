AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")
include("sv_workarounds.lua")
include("sv_wheelsystem.lua")

ENT.DriverActiveSound = "common/null.wav"
ENT.DriverInActiveSound = "common/null.wav"

function ENT:OnSpawn( PObj )
	PObj:SetMass( 1000 )

	self:AddDriverSeat( Vector(-14,14.94,4.2394), Angle(0,-90,7.8) )

	local radius = 12

	local FrontRight = self:AddWheel( Vector(50.814,-29,12.057), Angle(0,-90,0), radius )
	local FrontLeft = self:AddWheel( Vector(50.814,29,12.057), Angle(0,90,0), radius )

	local RearRight = self:AddWheel( Vector(-50.814,-29,12.057), Angle(0,-90,0), radius )
	local RearLeft = self:AddWheel( Vector(-50.814,29,12.057), Angle(0,90,0), radius )

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

	self:SetMassCenter( Vector(0,0,0) )
end

function ENT:OnSpawnFinish( PObj )
	timer.Simple(0, function()
		if not IsValid( self ) or not IsValid( PObj ) then return end

		if GetConVar( "developer" ):GetInt() ~= 1 then
			PObj:EnableMotion( true )
		end

		self:SetSolid( SOLID_VPHYSICS )
		self:PhysWake()

		for _, Wheel in pairs( self:GetWheels() ) do
			Wheel:SetSolid( SOLID_VPHYSICS )
		end
	end )
end

function ENT:AlignView( ply )
	if not IsValid( ply ) then return end

	timer.Simple( 0, function()
		if not IsValid( ply ) or not IsValid( self ) then return end
		local Ang = Angle(0,90,0)

		ply:SetEyeAngles( Ang )
	end)
end