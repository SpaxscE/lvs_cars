AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")
include("sv_ai.lua")

function ENT:OnSpawn( PObj )
	local WheelModel = "models/blu/pak40_wheel.mdl"

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			SteerAngle = 0,
			BrakeFactor = 1,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(47.2,31,16.27),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),

			self:AddWheel( {
				pos = Vector(47.2,-31,16.27),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),

			} ),
		},
		Suspension = {
			Height = 0,
			MaxTravel = 0,
			ControlArmLength = 0,
		},
	} )
end
	
function ENT:PhysicsSimulate( phys, deltatime )
	local ent = phys:GetEntity()

	if ent == self then
		if not self:StabilityAssist() or not self:WheelsOnGround() then return vector_origin, vector_origin, SIM_NOTHING end

		local ForceAngle = Vector(0,0, math.deg( -phys:GetAngleVelocity().z ) * math.min( phys:GetVelocity():Length() / self.PhysicsDampingSpeed, 1 ) * self.ForceAngleMultiplier )

		return ForceAngle, vector_origin, SIM_GLOBAL_ACCELERATION
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
