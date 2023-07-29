
ENT.Base = "lvs_base"

ENT.PrintName = "[LVS] Automobile Base"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.MaxHealth = 1000

ENT.MaxVelocity = 2000

ENT.TorqueMultiplier = 10
ENT.TorqueCurveMultiplier = 0.1

ENT.SteerSpeed = 3
ENT.SteerReturnSpeed = 10

ENT.FastSteerActiveVelocity = 500
ENT.FastSteerAngleClamp = 10
ENT.FastSteerDeactivationDriftAngle = 10

ENT.SteerAssistDeadZoneAngle = 3
ENT.SteerAssistMaxAngle = 15
ENT.SteerAssistMultiplier = 0.9


function ENT:SetupDataTables()
	self:CreateBaseDT()

	self:AddDT( "Float", "Steer" )
	self:AddDT( "Float", "NWThrottle" )
	self:AddDT( "Float", "MaxThrottle" )
	self:AddDT( "Float", "NWMaxSteer" )

	self:AddDT( "Entity", "Engine" )
	self:AddDT( "Entity", "Transmission" )

	if SERVER then
		self:SetMaxThrottle( 1 )
	end
end

function ENT:GetSteerPercent()
	return (self:GetSteer() / self:GetMaxSteerAngle())
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

function ENT:SetThrottle( NewThrottle )
	if self:GetEngineActive() then
		self:SetNWThrottle( math.Clamp(NewThrottle,0,self:GetMaxThrottle()) )
	else
		self:SetNWThrottle( 0 )
	end
end

function ENT:GetThrottle()
	if self:GetEngineActive() then
		return self:GetNWThrottle()
	else
		return 0
	end
end