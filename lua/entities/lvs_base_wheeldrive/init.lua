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

DEFINE_BASECLASS( "lvs_base" )

function ENT:PostInitialize( PObj )
	PObj:SetMass( self.PhysicsMass )
	PObj:EnableDrag( self.PhysicsDrag )

	local Inertia = PObj:GetInertia()

	PObj:SetInertia( Vector(Inertia.x * self.PhysicsInertia.x,Inertia.y * self.PhysicsInertia.y,Inertia.z * self.PhysicsInertia.z) )

	BaseClass.PostInitialize( self, PObj )
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

function ENT:PhysicsSimulate( phys, deltatime )
	local ent = phys:GetEntity()

	if ent == self then
		return vector_origin, vector_origin, SIM_NOTHING
	end

	if not self:AlignWheel( ent ) or ent:IsHandbrakeActive() then return vector_origin, vector_origin, SIM_NOTHING end

	local RotationAxis = ent:GetRotationAxis()

	local curRPM = self:VectorSplitNormal( RotationAxis,  phys:GetAngleVelocity() ) / 6

	local TorqueFactor = ent:GetTorqueFactor()

	local ForceAngle = vector_origin

	if self:GetBrake() then
		if ent:IsRotationLocked() then
			ForceAngle = vector_origin
		else
			local ForwardVel = self:VectorSplitNormal( ent:GetDirectionAngle():Forward(),  phys:GetVelocity() )

			local targetRPM = ent:VelToRPM( ForwardVel ) * 0.5

			if math.abs( curRPM ) < self.WheelBrakeLockRPM then
				ent:LockRotation()
			else
				ForceAngle = RotationAxis * (targetRPM - curRPM) * self.WheelBrakeForce * self.ForceAngleMultiplier * ent:GetBrakeFactor()
			end
		end
	else
		local MaxTorque = 1000 * self.TorqueMultiplier

		local targetRPM = ent:VelToRPM( self.MaxVelocity )

		local Torque = math.Clamp( (targetRPM - curRPM) * 0.5 * self.TorqueCurveMultiplier,-MaxTorque,MaxTorque) * self.WheelAccelerationForce * self.ForceAngleMultiplier * TorqueFactor * self:GetThrottle()

		if ent:IsRotationLocked() then
			ent:ReleaseRotation()
		end

		ForceAngle = RotationAxis * Torque
	end

	phys:Wake()

	if not self:WheelsOnGround() then return ForceAngle, vector_origin, SIM_GLOBAL_ACCELERATION end

	local ForceLinear = -self:GetUp() * (self.WheelDownForce + self.WheelDownForceAcceleration * TorqueFactor) * self.ForceLinearMultiplier

	return ForceAngle, ForceLinear, SIM_GLOBAL_ACCELERATION
end