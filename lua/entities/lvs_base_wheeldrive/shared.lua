
ENT.Base = "lvs_base"

ENT.PrintName = "[LVS] Automobile Base"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.MaxHealth = 1000

function ENT:SetupDataTables()
	self:CreateBaseDT()

	self:AddDT( "Float", "Steer" )
	self:AddDT( "Float", "NWThrottle" )
	self:AddDT( "Float", "MaxThrottle" )

	self:AddDT( "Entity", "Engine" )
	self:AddDT( "Entity", "Transmission" )

	if SERVER then
		self:SetMaxThrottle( 1 )
	end
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