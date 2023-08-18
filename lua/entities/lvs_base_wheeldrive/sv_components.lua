
function ENT:AddEngine( pos )
	if IsValid( self:GetEngine() ) then return end

	local Engine = ents.Create( "lvs_wheeldrive_engine" )

	if not IsValid( Engine ) then
		self:Remove()

		print("LVS: Failed to create engine entity. Vehicle terminated.")

		return
	end

	Engine:SetPos( self:LocalToWorld( pos ) )
	Engine:SetAngles( self:GetAngles() )
	Engine:Spawn()
	Engine:Activate()
	Engine:SetParent( self )
	Engine:SetBase( self )

	self:SetEngine( Engine )

	self:DeleteOnRemove( Engine )

	self:TransferCPPI( Engine )

	return Engine
end

function ENT:AddFuelTank( pos, tanksize, fueltype )
	if IsValid( self:GetFuelTank() ) then return end

	local FuelTank = ents.Create( "lvs_wheeldrive_fueltank" )

	if not IsValid( FuelTank ) then
		self:Remove()

		print("LVS: Failed to create fueltank entity. Vehicle terminated.")

		return
	end

	FuelTank:SetPos( self:LocalToWorld( pos ) )
	FuelTank:SetAngles( self:GetAngles() )
	FuelTank:Spawn()
	FuelTank:Activate()
	FuelTank:SetParent( self )
	FuelTank:SetBase( self )
	FuelTank:SetSize( tanksize or 600 )
	FuelTank:SetFuelType( fueltype or 0 )

	self:SetFuelTank( FuelTank )

	self:DeleteOnRemove( FuelTank )

	self:TransferCPPI( FuelTank )

	return FuelTank
end

function ENT:AddLights()
	if IsValid( self:GetLightsHandler() ) then return end

	local LightHandler = ents.Create( "lvs_wheeldrive_lighthandler" )

	if not IsValid( LightHandler ) then return end

	LightHandler:SetPos( self:LocalToWorld( self:OBBCenter() ) )
	LightHandler:SetAngles( self:GetAngles() )
	LightHandler:Spawn()
	LightHandler:Activate()
	LightHandler:SetParent( self )
	LightHandler:SetBase( self )

	self:DeleteOnRemove( LightHandler )

	self:TransferCPPI( LightHandler )

	self:SetLightsHandler( LightHandler )
end
