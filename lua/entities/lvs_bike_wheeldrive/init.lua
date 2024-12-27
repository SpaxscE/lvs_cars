AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

-- code relies on this forward angle...
ENT.ForcedForwardAngle = Angle(0,0,0)

ENT.LeanAngleIdle = -10
ENT.LeanAnglePark = -10

function ENT:PhysicsSimulateOverride( ForceAngle, phys, deltatime )
	local Steer = self:GetSteer()

	local VelL = self:WorldToLocal( self:GetPos() + phys:GetVelocity() )

	if self:ShouldPutFootDown() then
		Steer = self:GetEngineActive() and self.LeanAngleIdle or self.LeanAnglePark
		VelL.x = self.MaxVelocity * 0.5
	end

	local Mul = (math.max( self:GetUp().z, 0 ) ^ 2) * 50 * (math.max( VelL.x / self.MaxVelocity, 0 ) ^ 2) * self.PhysicsWheelGyroMul

	ForceAngle.x = ((Steer - self:GetAngles().r) * 2.5 * self.PhysicsRollMul - phys:GetAngleVelocity().x * self.PhysicsDampingRollMul) * Mul

	return ForceAngle, vector_origin, SIM_GLOBAL_ACCELERATION
end
