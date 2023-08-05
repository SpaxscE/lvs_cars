AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_flyby.lua" )
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

local function SetMinimumAngularVelocityTo( new )
	local tbl = physenv.GetPerformanceSettings()

	if tbl.MaxAngularVelocity < new then
		local OldAngVel = tbl.MaxAngularVelocity

		tbl.MaxAngularVelocity = new
		physenv.SetPerformanceSettings( tbl )

		print("[LVS-Cars] Wheels require higher MaxAngularVelocity to perform correctly! Increasing! "..OldAngVel.." =>"..new)
	end
end

function ENT:PostInitialize( PObj )

	PObj:SetMass( self.PhysicsMass )
	PObj:EnableDrag( self.PhysicsDrag )
	PObj:SetInertia( self.PhysicsInertia )

	BaseClass.PostInitialize( self, PObj )

	SetMinimumAngularVelocityTo( 10000 )
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
		local Vel = 0

		for _, wheel in pairs( self:GetWheels() ) do
			if wheel:GetTorqueFactor() <= 0 then continue end

			local wheelVel = wheel:RPMToVel( math.abs( wheel:GetRPM() or 0 ) )

			if wheelVel > Vel then
				Vel = wheelVel
			end
		end

		self:SetWheelVelocity( Vel )

		return vector_origin, vector_origin, SIM_NOTHING
	end

	return self:SimulateRotatingWheel( ent, phys, deltatime )
end

function ENT:SimulateRotatingWheel( ent, phys, deltatime )
	if not self:AlignWheel( ent ) or ent:IsHandbrakeActive() then if ent.SetRPM then ent:SetRPM( 0 ) end return vector_origin, vector_origin, SIM_NOTHING end

	local RotationAxis = ent:GetRotationAxis()

	local curRPM = self:VectorSplitNormal( RotationAxis,  phys:GetAngleVelocity() ) / 6

	ent:SetRPM( curRPM )

	local ForceAngle = vector_origin

	local TorqueFactor = ent:GetTorqueFactor()

	if self:GetBrake() > 0 then
		if ent:IsRotationLocked() then
			ForceAngle = vector_origin
		else
			local ForwardVel = self:VectorSplitNormal( ent:GetDirectionAngle():Forward(),  phys:GetVelocity() )

			local targetRPM = ent:VelToRPM( ForwardVel ) * 0.5

			if math.abs( curRPM ) < self.WheelBrakeLockupRPM then
				ent:LockRotation()
			else
				ForceAngle = RotationAxis * (targetRPM - curRPM) * self.WheelBrakeForce * ent:GetBrakeFactor() * self:GetBrake()
			end
		end
	else
		if ent:IsRotationLocked() then
			ent:ReleaseRotation()
		end

		if TorqueFactor > 0 then
			local targetRPM = ent:VelToRPM( self:GetTargetVelocity() )

			local powerRPM = math.min( self.EnginePower, targetRPM )

			local powerCurve = (powerRPM + math.max(targetRPM - powerRPM,0) - math.max(math.abs(curRPM) - powerRPM,0)) / targetRPM * self:Sign( targetRPM - curRPM )

			local Torque = powerCurve * math.deg( self.EngineTorque ) * TorqueFactor * self:GetThrottle()

			ForceAngle = RotationAxis * Torque
		end
	end

	phys:Wake()

	if not self:WheelsOnGround() then return ForceAngle, vector_origin, SIM_GLOBAL_ACCELERATION end

	local ForceLinear = -self:GetUp() * (self.WheelDownForce + self.WheelDownForcePowered * TorqueFactor)

	return ForceAngle, ForceLinear, SIM_GLOBAL_ACCELERATION
end