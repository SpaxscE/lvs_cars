
ENT.Base = "lvs_base"

ENT.PrintName = "[LVS] Automobile Base"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/kubel/kubelwagen.mdl"

function ENT:SetupDataTables()
	self:CreateBaseDT()

	self:AddDT( "Float", "Steer" )
	self:AddDT( "Float", "Throttle" )

	self:AddDT( "Entity", "Engine" )
	self:AddDT( "Entity", "Transmission" )

	self:AddDT( "Float", "Camber", { KeyName = "camber", Edit = { type = "Float", order = 1,min = -15, max = 15, category = "Alignment Specs"} } )
	self:AddDT( "Float", "Caster", { KeyName = "caster", Edit = { type = "Float", order = 1,min = -15, max = 15, category = "Alignment Specs"} } )
	self:AddDT( "Float", "Toe", { KeyName = "toe", Edit = { type = "Float", order = 1,min = -15, max = 15, category = "Alignment Specs"} } )

	if SERVER then
		self:SetCamber( 0 )
		self:SetCaster( 5 )
		self:SetToe( 0 )
	end
end
