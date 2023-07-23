AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_animations.lua" )
include("shared.lua")
include("sh_animations.lua")
include("sv_controls.lua")
include("sv_wheelsystem.lua")

ENT.DriverActiveSound = "common/null.wav"
ENT.DriverInActiveSound = "common/null.wav"

function ENT:OnSpawn( PObj )
	PObj:SetMass( 1000 )
	PObj:EnableDrag( false )

	self:AddDriverSeat( Vector(-8,11,13), Angle(0,-95,-8) )

	local WheelModel = "models/diggercars/kubel/kubelwagen_wheel.mdl"

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(47.5,-20,16),

				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),

				camber = -0.5,
				caster = 5,
				toe = 0,
			} ),

			self:AddWheel( {
				pos = Vector(47.5,20,16),

				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),

				camber = -0.5,
				caster = 5,
				toe = 0,
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
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-41,-20,14),

				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),

			self:AddWheel( {
				pos = Vector(-41,20,14),

				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),
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

function ENT:AlignView( ply )
	if not IsValid( ply ) then return end

	timer.Simple( 0, function()
		if not IsValid( ply ) or not IsValid( self ) then return end
		local Ang = Angle(0,90,0)

		ply:SetEyeAngles( Ang )
	end)
end

function ENT:TakeCollisionDamage( damage, attacker )
end

function ENT:AlignWheel( Wheel )
	if not IsValid( Wheel ) then return end

	if not isfunction( Wheel.GetMaster ) then Wheel:Remove() return end

	local Master = Wheel:GetMaster()

	if not IsValid( Master ) then Wheel:Remove() return end

	local Steer = self:GetSteer()

	local PhysObj = Master:GetPhysicsObject()

	if PhysObj:IsMotionEnabled() then PhysObj:EnableMotion( false ) return end

	local ID = Wheel:GetAxle()

	local Axle = self:GetAxleData( ID )

	local AxleAng = self:LocalToWorldAngles( Axle.ForwardAngle )

	AxleAng:RotateAroundAxis( AxleAng:Right(), Wheel:GetCaster() )
	AxleAng:RotateAroundAxis( AxleAng:Forward(), Wheel:GetCamber() )
	AxleAng:RotateAroundAxis( AxleAng:Up(), Wheel:GetToe() )

	if Axle.SteerType == LVS.WHEEL_STEER_REAR then
		AxleAng:RotateAroundAxis( AxleAng:Up(), Steer * Axle.SteerAngle )
	else
		if Axle.SteerType == LVS.WHEEL_STEER_FRONT then
			AxleAng:RotateAroundAxis( AxleAng:Up(), -Steer * Axle.SteerAngle )
		end
	end

	Master:SetAngles( AxleAng )

	return AxleAng
end

function ENT:PhysicsSimulate( phys, deltatime )
	local ent = phys:GetEntity()

	if ent == self then
		return vector_origin, vector_origin, SIM_NOTHING
	end

	phys:Wake()

	local AxleAng = self:AlignWheel( ent )

	if not AxleAng then return end

	local torque = -ent:WorldToLocalAngles( AxleAng ):Right() * 1500 * self:GetThrottle()

	return torque, vector_origin, SIM_LOCAL_ACCELERATION
end