
ENT.Base = "lvs_base"

ENT.PrintName = "[LVS] Automobile Base"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/kubel/kubelwagen.mdl"

ENT.MaxVelocity = 1500

ENT.ForceLinearMultiplier = 1
ENT.ForceAngleMultiplier = 1

function ENT:SetupDataTables()
	self:CreateBaseDT()

	self:AddDT( "Float", "Steer" )
	self:AddDT( "Float", "Throttle" )
end
