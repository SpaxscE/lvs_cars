
ENT.Base = "lvs_base"

ENT.PrintName = "[LVS] Automobile Base"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/kubel/kubelwagen.mdl"

ENT.MaxVelocity = 1200
ENT.MaxPower = 100

ENT.TractionMultiplier = 5

function ENT:SetupDataTables()
	self:CreateBaseDT()

	self:AddDT( "Float", "Steer" )
	self:AddDT( "Float", "Throttle" )

	self:AddDT( "Entity", "Engine" )
	self:AddDT( "Entity", "Transmission" )
end
