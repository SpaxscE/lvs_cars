
ENT.Base = "lvs_base_wheeldrive_trailer"

ENT.PrintName = "PaK 40"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/blu/pak40.mdl"

ENT.WheelPhysicsMass = 350
ENT.WheelPhysicsInertia = Vector(10,8,10)

function ENT:OnSetupDataTables()
	self:AddDT( "Bool", "Prongs" )
end