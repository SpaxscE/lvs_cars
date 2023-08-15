AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_flyby.lua" )
AddCSLuaFile( "cl_camera.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_tiresounds.lua" )
AddCSLuaFile( "sh_animations.lua" )
AddCSLuaFile( "sh_camera_eyetrace.lua" )
include("shared.lua")
include("sh_animations.lua")
include("sv_controls.lua")
include("sv_controls_handbrake.lua")
include("sv_components.lua")
include("sv_wheelsystem.lua")
include("sh_camera_eyetrace.lua")

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

local function IsServerOK()

	if GetConVar( "gmod_physiterations" ):GetInt() < 4 then
		RunConsoleCommand("gmod_physiterations", "4")

		return false
	end

	return true
end

function ENT:PostInitialize( PObj )

	if not IsServerOK() then
		self:Remove()
		print("[LVS] ERROR COULDN'T INITIALIZE VEHICLE!")
	end

	if istable( self.Lights ) then
		self:AddLights()
	end

	BaseClass.PostInitialize( self, PObj )

	PObj:SetMass( self.PhysicsMass * self.PhysicsWeightScale )
	PObj:EnableDrag( self.PhysicsDrag )
	PObj:SetInertia( self.PhysicsInertia * self.PhysicsWeightScale )

	SetMinimumAngularVelocityTo( 24000 )

	self:EnableHandbrake()
end

function ENT:AlignView( ply )
	if not IsValid( ply ) then return end

	timer.Simple( 0, function()
		if not IsValid( ply ) or not IsValid( self ) then return end

		local Ang = Angle(0,90,0)

		local pod = ply:GetVehicle()
		local MouseAim = ply:lvsMouseAim() and self:GetDriver() == ply

		if MouseAim and IsValid( pod ) then
			Ang = pod:LocalToWorldAngles( Angle(0,90,0) )
			Ang.r = 0
		end

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

		if not self:WheelsOnGround() then return vector_origin, vector_origin, SIM_NOTHING end

		local F = math.min( phys:GetVelocity():Length() / self.PhysicsDampingSpeed, 1 )

		local ForceAngle = Vector(0,0, math.deg( -phys:GetAngleVelocity().z ) * F * 0.5 * self.ForceAngleMultiplier )

		return ForceAngle, vector_origin, SIM_GLOBAL_ACCELERATION
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
			local targetRPMabs = math.abs( targetRPM )

			local powerRPM = math.min( self.EnginePower, targetRPMabs )

			local powerCurve = (powerRPM + math.max( targetRPMabs - powerRPM,0) * self:Sign( targetRPM ) - math.max(math.abs(curRPM) - powerRPM,0) * self:Sign( curRPM) ) / targetRPMabs

			local Torque = powerCurve * math.deg( self.EngineTorque ) * TorqueFactor * self:GetThrottle()

			local BoostRPM = 0

			if self:GetReverse() then
				BoostRPM = ent:VelToRPM( self.MaxVelocityReverse / self.TransGearsReverse ) * 0.5
			else
				BoostRPM = ent:VelToRPM( self.MaxVelocity / self.TransGears ) * 0.5
			end

			local TorqueBoost = 2 - (math.min( math.max( math.abs( curRPM ) - BoostRPM, 0 ), BoostRPM) / BoostRPM)
	
			ForceAngle = RotationAxis * Torque * TorqueBoost
		end
	end

	phys:Wake()

	if not self:WheelsOnGround() then return ForceAngle, vector_origin, SIM_GLOBAL_ACCELERATION end

	local Vel = phys:GetVelocity()

	local ForwardAngle = ent:GetDirectionAngle()

	local Forward = ForwardAngle:Forward()
	local Right = ForwardAngle:Right()

	local Fy = self:VectorSplitNormal( Right, Vel )
	local Fx = self:VectorSplitNormal( Forward, Vel )

	local ForceLinear = -self:GetUp() * self.WheelDownForce * TorqueFactor - Right * math.Clamp(Fy * 5 * math.min( math.abs( Fx ) / self.WheelPhysicsDampingSpeed, 1 ),-self.WheelSideForce,self.WheelSideForce) * self.ForceLinearMultiplier

	return ForceAngle, ForceLinear, SIM_GLOBAL_ACCELERATION
end

function ENT:SteerTo( TargetValue, MaxSteer )
	local Cur = self:GetSteer() / MaxSteer
	
	local Diff = TargetValue - Cur

	local Returning = (Diff > 0 and Cur < 0) or (Diff < 0 and Cur > 0)

	local Rate = FrameTime() * (Returning and self.SteerReturnSpeed or self.SteerSpeed)

	local New = (Cur + math.Clamp(Diff,-Rate,Rate))

	self:SetSteer( New * MaxSteer )
	self:SetPoseParameter( "vehicle_steer", New  )
end
