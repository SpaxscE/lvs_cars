
function ENT:AddEngine( data )
	local Engine = self:GetEngine()

	if IsValid( Engine ) then
		Engine:Remove()
	end

	local Engine = ents.Create( "lvs_wheeldrive_engine" )

	if not IsValid( Engine ) then
		self:Remove()

		print("LVS: Failed to create engine entity. Vehicle terminated.")

		return
	end
	Engine:SetPos( self:LocalToWorld( data.Pos ) )
	Engine:SetAngles( self:LocalToWorldAngles( data.Ang ) )
	Engine:Spawn()
	Engine:Activate()

	self:SetEngine( Engine )

	return Engine
end

function ENT:AddTransmission( data )
	local Transmission = self:GetTransmission()

	if IsValid( Transmission ) then
		Transmission:Remove()
	end

	local Transmission = ents.Create( "lvs_wheeldrive_transmission" )

	if not IsValid( Transmission ) then
		self:Remove()

		print("LVS: Failed to create transmission entity. Vehicle terminated.")

		return
	end
	Transmission:SetPos( self:LocalToWorld( data.Pos ) )
	Transmission:SetAngles( self:LocalToWorldAngles( data.Ang ) )
	Transmission:Spawn()
	Transmission:Activate()

	self:SetTransmission( Transmission )

	return Transmission
end