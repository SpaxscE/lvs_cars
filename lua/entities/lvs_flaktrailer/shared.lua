
ENT.Base = "lvs_base_wheeldrive_trailer"

ENT.PrintName = "FlaK Trailer"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS]"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/blu/flakcarriage.mdl"

ENT.AITEAM = 1

function ENT:OnSetupDataTables()
	self:AddDT( "Bool", "Prong" )
end