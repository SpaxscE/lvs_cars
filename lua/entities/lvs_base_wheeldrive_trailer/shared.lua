
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "[LVS] Wheeldrive Trailer"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.DoNotDuplicate = true

ENT.DeleteOnExplode = true

ENT.lvsAllowEngineTool = false
ENT.lvsShowInSpawner = false

ENT.AllowSuperCharger = false
ENT.AllowTurbo = false

ENT.PhysicsDampingSpeed = 1000
ENT.PhysicsDampingForward = true
ENT.PhysicsDampingReverse = true

function ENT:SetupDataTables()
	self:CreateBaseDT()

	self:AddDT( "Entity", "InputTarget" )
	self:AddDT( "Entity", "LightsHandler" )
	self:AddDT( "Vector", "AIAimVector" )

	self:TurretSystemDT()
	self:TrackSystemDT()
end

function ENT:GetVehicleType()
	return "LBaseTrailer"
end

function ENT:StartCommand( ply, cmd )
end

function ENT:SetNWHandBrake()
end

function ENT:GetGear()
	return -1
end

function ENT:IsManualTransmission()
	return false
end

function ENT:SetThrottle()
end

function ENT:SetReverse()
end

function ENT:GetEngine()
	local InputTarget = self:GetInputTarget()

	if not IsValid( InputTarget ) then return NULL end

	return InputTarget:GetEngine()
end

function ENT:GetFuelTank()
	local InputTarget = self:GetInputTarget()

	if not IsValid( InputTarget ) then return NULL end

	return InputTarget:GetFuelTank()
end

function ENT:GetThrottle()
	local InputTarget = self:GetInputTarget()

	if not IsValid( InputTarget ) then return 0 end

	return InputTarget:GetThrottle()
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