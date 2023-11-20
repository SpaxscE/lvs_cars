AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")
include("sv_ai.lua")

function ENT:OnTick()
	local InputTarget = self:GetInputTarget()

	if not IsValid( InputTarget ) then return end

	local InputLightsHandler = InputTarget:GetLightsHandler()
	local LightsHandler = self:GetLightsHandler()

	if not IsValid( InputLightsHandler ) or not IsValid( LightsHandler ) then return end

	LightsHandler:SetActive( InputLightsHandler:GetActive() )
	LightsHandler:SetHighActive( InputLightsHandler:GetHighActive() )
	LightsHandler:SetFogActive( InputLightsHandler:GetFogActive() )
end

function ENT:PhysicsSimulate( phys, deltatime )
	local ent = phys:GetEntity()

	if ent == self then
		return vector_origin, vector_origin, SIM_NOTHING
	end

	return self:SimulateRotatingWheel( ent, phys, deltatime )
end

function ENT:SimulateRotatingWheel( ent, phys, deltatime )
	if not self:AlignWheel( ent ) or ent:IsHandbrakeActive() then return vector_origin, vector_origin, SIM_NOTHING end

	if self:GetBrake() > 0 and not ent:IsRotationLocked() then
		local RotationAxis = ent:GetRotationAxis()

		local curRPM = self:VectorSplitNormal( RotationAxis,  phys:GetAngleVelocity() ) / 6

		local ForwardVel = self:VectorSplitNormal( ent:GetDirectionAngle():Forward(),  phys:GetVelocity() )

		local targetRPM = ent:VelToRPM( ForwardVel ) * 0.5

		if math.abs( curRPM ) < self.WheelBrakeLockupRPM then
			ent:LockRotation()
		else
			if (ForwardVel > 0 and targetRPM > 0) or (ForwardVel < 0 and targetRPM < 0) then
				ForceAngle = RotationAxis * math.Clamp( (targetRPM - curRPM) / 100,-1,1) * math.deg( self.WheelBrakeForce ) * ent:GetBrakeFactor() * self:GetBrake()
			end
		end

		return ForceAngle, vector_origin, SIM_GLOBAL_ACCELERATION
	end

	if ent:IsRotationLocked() then
		ent:ReleaseRotation()
	end

	return vector_origin, vector_origin, SIM_NOTHING
end

function ENT:IsEngineStartAllowed()
	return false
end

function ENT:OnEngineActiveChanged( Active )
end

function ENT:StartEngine()
end

function ENT:StopEngine()
end

function ENT:ToggleEngine()
end

function ENT:HandleStart()
end

function ENT:AddEngine()
end

function ENT:AddTurboCharger()
end

function ENT:AddSuperCharger()
end

function ENT:OnCoupled( targetVehicle, targetHitch )
	self:SetInputTarget( targetVehicle )

	if not IsValid( targetHitch ) then return end

	targetHitch:EmitSound("doors/door_metal_medium_open1.wav")
end

function ENT:OnDecoupled( targetVehicle, targetHitch )
	self:SetInputTarget( NULL )

	if not IsValid( targetHitch ) then return end

	targetHitch:EmitSound("ambient/machines/catapult_throw.wav")

	local LightsHandler = self:GetLightsHandler()

	if not IsValid( LightsHandler ) then return end

	LightsHandler:SetActive( false )
	LightsHandler:SetHighActive( false )
	LightsHandler:SetFogActive( false )
end

function ENT:OnStartDrag( caller, activator )
end

function ENT:OnStopDrag( caller, activator )
end
