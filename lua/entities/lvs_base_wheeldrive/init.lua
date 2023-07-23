AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_animations.lua" )
include("shared.lua")
include("sh_animations.lua")
include("sv_controls.lua")
include("sv_components.lua")
include("sv_wheelsystem.lua")

ENT.DriverActiveSound = "common/null.wav"
ENT.DriverInActiveSound = "common/null.wav"

function ENT:OnSpawn( PObj )
	PObj:SetMass( 1000 )
	PObj:EnableDrag( false )

	self:AddDriverSeat( Vector(-8,11,13), Angle(0,-95,-8) )
	self:AddPassengerSeat( Vector(10,-11,16), Angle(0,-85,8) )

	self:AddEngine( Vector(-45,0,30) )

	local WheelModel = "models/diggercars/kubel/kubelwagen_wheel.mdl"

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
			TorqueFactor = 1,
			BrakeFactor = 1,
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

function ENT:GetVelocityDifference( AngleDirection )
	if not isangle( AngleDirection ) then return vector_origin end

	local Forward = AngleDirection:Forward()

	local Velocity = self:GetVelocity()
	local VelForward = Velocity:GetNormalized()

	local Throttle = self:GetThrottle()

	local TargetVelocity = self.MaxVelocity * Throttle

	local Force = math.max( TargetVelocity - math.cos( math.acos( math.Clamp( Forward:Dot( VelForward ) ,-1,1) ) ) * Velocity:Length(), 0 )

	return Force
end

function ENT:PhysicsSimulate( phys, deltatime )
	local ent = phys:GetEntity()

	if ent == self then
		return vector_origin, vector_origin, SIM_NOTHING
	end

	phys:Wake()

	local Axle, AngleDirection = self:AlignWheel( ent )

	if not Axle or not AngleDirection then return end

	local wAngleDir = -ent:WorldToLocalAngles( AngleDirection )

	local RotationAxis = wAngleDir:Right()

	local Vel = phys:GetVelocity()
	local VelForward = Vel:GetNormalized()
	local VelLength = Vel:Length()

	local Force = self:GetVelocityDifference( AngleDirection )

	local ForceAngle = RotationAxis * Force * self.ForceAngleMultiplier * Axle.TorqueFactor

	local AngVel = phys:GetAngleVelocity()
	local AngVelForward = AngVel:GetNormalized()

	local tRPM = VelLength * 60 / math.pi / (ent:GetRadius() * 2)
	local aRPM = math.cos( math.acos( math.Clamp( RotationAxis:Dot( AngVelForward ) ,-1,1) ) ) * AngVel:Length() / 6

	local Slip = math.min( math.abs( tRPM / aRPM ), 1 )

	local Forward = AngleDirection:Forward()
	local Right = AngleDirection:Right()
	local Fx = math.cos( math.acos( math.Clamp( Right:Dot( VelForward ) ,-1,1) ) ) * VelLength

	if  self:WheelsOnGround() then

		local ForceLinear = (Forward * Force * Axle.TorqueFactor * self.ForceLinearMultiplier - Right * Fx * self.ForceLinearMultiplier * Slip - self:GetUp() * math.abs( Fx ) * self.ForceLinearMultiplier)

		return ForceAngle, ForceLinear, SIM_GLOBAL_ACCELERATION
	end

	return ForceAngle, vector_origin, SIM_GLOBAL_ACCELERATION
end