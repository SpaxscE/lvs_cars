
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "[LVS] Wheeldrive Trailer"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.DeleteOnExplode = true

ENT.lvsAllowEngineTool = false
ENT.lvsShowInSpawner = false

ENT.AllowSuperCharger = false
ENT.AllowTurbo = false

ENT.PhysicsDampingForward = true
ENT.PhysicsDampingReverse = true

function ENT:SetupDataTables()
	self:CreateBaseDT()

	self:AddDT( "Entity", "LightsHandler" )
	self:AddDT( "Vector", "AIAimVector" )
end

function ENT:GetVehicleType()
	return "trailer"
end

function ENT:StartCommand( ply, cmd )
end

function ENT:GetSteer()
	return 0
end

function ENT:GetNWMaxSteer()
	return 1
end

function ENT:GetTurnMode()
	return 0
end

function ENT:GetReverse()
	return false
end

function ENT:GetNWHandBrake()
	return false
end

function ENT:SetNWHandBrake()
end

function ENT:GetParkingBrake()
	return false
end

function ENT:GetBrake()
	return 0
end