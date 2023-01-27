
ENT.Base = "lvs_base"

ENT.PrintName = "[LVS] Four Wheel Generic"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS]"

function ENT:SetupDataTables()
	self:CreateBaseDT()

	--self:AddDT( "Bool", "Disabled" )

	--if SERVER then
		--self:NetworkVarNotify( "Disabled", self.OnDisabled )
	--end
end
