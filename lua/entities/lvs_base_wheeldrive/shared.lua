
ENT.Base = "lvs_base"

ENT.PrintName = "[LVS] Automobile Base"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

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

function ENT:InitFromList()
	local class = self:GetClass()

	local data = list.Get( "simfphys_vehicles" )[ class ]

	if not data or not data.Members then return end

	self._VehicleInfo = data.Members
end

function ENT:GetVehicleParams()
	return istable( self._VehicleInfo ) and self._VehicleInfo or {}
end

function ENT:GetVehicleClass()
	return self:GetClass()
end