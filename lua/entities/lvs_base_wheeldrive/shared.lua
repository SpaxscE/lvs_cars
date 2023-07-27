
ENT.Base = "lvs_base"

ENT.PrintName = "[LVS] Wheeldrive Base"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

--ENT.MDL = "models/diggercars/kubel/kubelwagen.mdl"

ENT.MaxVelocity = 1200

ENT.ForceLinearMultiplier = 3
ENT.ForceAngleMultiplier = 1

ENT.TorqueCurveMultiplier = 2

ENT.SteerSpeed = 3.5
ENT.SteerReturnSpeed = 10

ENT.FastSteerSpeed = 1
ENT.FastSteerActiveVelocity = 500
ENT.FastSteerAngleClamp = 15
ENT.FastSteerDeactivationDriftAngle = 5

ENT.SteerAssistDeadZoneAngle = 3
ENT.SteerAssistMaxAngle = 15
ENT.SteerAssistMultiplier = 0.8

function ENT:SetupDataTables()
	self:CreateBaseDT()

	self:AddDT( "Float", "Steer" )
	self:AddDT( "Float", "Throttle" )
	self:AddDT( "Float", "NWMaxSteer" )
end

function ENT:GetMaxSteerAngle()
	if CLIENT then return self:GetNWMaxSteer() end

	if self._WheelMaxSteerAngle then return self._WheelMaxSteerAngle end

	local Cur = 0

	for _, Axle in pairs( self._WheelAxleData ) do
		if not Axle.SteerAngle then continue end

		if Axle.SteerAngle > Cur then
			Cur = Axle.SteerAngle
		end
	end

	self._WheelMaxSteerAngle = Cur

	self:SetNWMaxSteer( Cur )

	return Cur
end
