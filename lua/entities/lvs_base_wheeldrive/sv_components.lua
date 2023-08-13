
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
