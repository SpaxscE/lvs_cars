
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

	self:AddDS( {
		pos = pos,
		ang = Angle(0,0,0),
		mins = Vector(-15,-15,-5),
		maxs =  Vector(15,15,5),
		Callback = function( tbl, ent, dmginfo )
			if not IsValid( FuelTank ) then return end

			FuelTank:OnTakeDamage( dmginfo )
		end
	} )

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

function ENT:AddTurboCharger()
	if IsValid( self:GetTurbo() ) then return end

	local Turbo = ents.Create( "lvs_item_turbo" )

	if not IsValid( Turbo ) then
		self:Remove()

		print("LVS: Failed to create turbocharger entity. Vehicle terminated.")

		return
	end

	Turbo:SetPos( self:GetPos() )
	Turbo:SetAngles( self:GetAngles() )
	Turbo:Spawn()
	Turbo:Activate()
	Turbo:LinkTo( self )

	self:TransferCPPI( Turbo )

	return Turbo
end

function ENT:AddSuperCharger()
	if IsValid( self:GetCompressor() ) then return end

	local SuperCharger = ents.Create( "lvs_item_compressor" )

	if not IsValid( SuperCharger ) then
		self:Remove()

		print("LVS: Failed to create supercharger entity. Vehicle terminated.")

		return
	end

	SuperCharger:SetPos( self:GetPos() )
	SuperCharger:SetAngles( self:GetAngles() )
	SuperCharger:Spawn()
	SuperCharger:Activate()
	SuperCharger:LinkTo( self )

	self:TransferCPPI( SuperCharger )

	return SuperCharger
end
