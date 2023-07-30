AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_animations.lua" )
include("shared.lua")
include("sh_animations.lua")
include("sv_controls.lua")
include("sv_controls_handbrake.lua")
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

function ENT:PhysicsSimulate( phys, deltatime )
	local ent = phys:GetEntity()

	if ent == self then
		return vector_origin, vector_origin, SIM_NOTHING
	end

	local Axle, AngleDirection = self:AlignWheel( ent )

	if ent:IsHandbrakeActive() then return vector_origin, vector_origin, SIM_NOTHING end

	if not Axle or not AngleDirection then return end

	local WorldAngleDirection = -ent:WorldToLocalAngles( AngleDirection )

	local RotationAxis = WorldAngleDirection:Right()

	local AngVel = phys:GetAngleVelocity()
	local AngVelForward = AngVel:GetNormalized()

	local RotationAxisVel = math.cos( math.acos( math.Clamp( RotationAxis:Dot( AngVelForward ) ,-1,1) ) ) * AngVel:Length()

	local targetRPM = self.MaxVelocity * 60 / math.pi / (ent:GetRadius() * 2)
	local curRPM = RotationAxisVel / 6

	local MaxTorque = 1000 * self.TorqueMultiplier
	local Torque = math.Clamp( (targetRPM - curRPM) * 0.5 * self.TorqueCurveMultiplier,-MaxTorque,MaxTorque) * 100 * self.ForceAngleMultiplier * Axle.TorqueFactor * self:GetThrottle()

	phys:Wake()

	local ForceAngle = RotationAxis * Torque

	if self:GetBrake() then
		if ent:IsRotationLocked() then
			ForceAngle = vector_origin
		else
			local Vel = phys:GetVelocity()
			local ForwardVel = math.cos( math.acos( math.Clamp( AngleDirection:Forward():Dot( Vel:GetNormalized() ) ,-1,1) ) ) * Vel:Length()

			targetRPM = (ForwardVel * 60 / math.pi / (ent:GetRadius() * 2)) * 0.5

			if math.abs( curRPM ) < 100 then
				ent:LockRotation()

				ForceAngle = vector_origin
			else
				ForceAngle = RotationAxis * (targetRPM - curRPM) * 500 * self.ForceAngleMultiplier * Axle.BrakeFactor
			end
		end
	else
		if ent:IsRotationLocked() then
			ent:ReleaseRotation()
		end
	end

	if not self:WheelsOnGround() then return ForceAngle, vector_origin, SIM_GLOBAL_ACCELERATION end

	local ForceLinear = -self:GetUp() * (1000 + 1000 * Axle.TorqueFactor) * self.ForceLinearMultiplier

	return ForceAngle, ForceLinear, SIM_GLOBAL_ACCELERATION
end