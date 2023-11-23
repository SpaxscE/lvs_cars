
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

ENT.GibModels = {
	"models/blu/flakcarriage.mdl",
	"models/blu/carriage_wheel.mdl",
	"models/blu/carriage_wheel.mdl",
	"models/gibs/manhack_gib01.mdl",
	"models/gibs/manhack_gib02.mdl",
	"models/gibs/manhack_gib03.mdl",
	"models/gibs/manhack_gib04.mdl",
	"models/props_c17/canisterchunk01a.mdl",
	"models/props_c17/canisterchunk01d.mdl",
}
