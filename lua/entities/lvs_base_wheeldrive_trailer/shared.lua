
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

	self:AddDT( "Entity", "InputTarget" )
	self:AddDT( "Entity", "LightsHandler" )
	self:AddDT( "Vector", "AIAimVector" )
end

function ENT:GetVehicleType()
	return "trailer"
end

function ENT:StartCommand( ply, cmd )
end

function ENT:GetSteer()
	local InputTarget = self:GetInputTarget()

	if not IsValid( InputTarget ) then return 0 end

	return InputTarget:GetSteer()
end

function ENT:GetNWMaxSteer()
	local InputTarget = self:GetInputTarget()

	if not IsValid( InputTarget ) then return 1 end

	return InputTarget:GetNWMaxSteer()
end

function ENT:GetTurnMode()
	local InputTarget = self:GetInputTarget()

	if not IsValid( InputTarget ) then return 0 end

	return InputTarget:GetTurnMode()
end

function ENT:GetReverse()
	local InputTarget = self:GetInputTarget()

	if not IsValid( InputTarget ) then return false end

	return InputTarget:GetReverse()
end

function ENT:GetNWHandBrake()
	local InputTarget = self:GetInputTarget()

	if not IsValid( InputTarget ) then return false end

	return InputTarget:GetNWHandBrake()
end

function ENT:SetNWHandBrake()
end

function ENT:GetParkingBrake()
	local InputTarget = self:GetInputTarget()

	if not IsValid( InputTarget ) then return false end

	return InputTarget:GetParkingBrake()
end

function ENT:GetBrake()
	local InputTarget = self:GetInputTarget()

	if not IsValid( InputTarget ) then return 0 end

	return InputTarget:GetBrake()
end