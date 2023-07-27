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

	local Throttle = math.max( self:GetThrottle(), 0 )

	local TargetVelocity = self.MaxVelocity * self:Sign( Throttle )

	local Force = math.min( math.max( (TargetVelocity - math.cos( math.acos( math.Clamp( Forward:Dot( VelForward ) ,-1,1) ) ) * Velocity:Length()) * self.TorqueCurveMultiplier * Throttle, 0 ), self.MaxVelocity )

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