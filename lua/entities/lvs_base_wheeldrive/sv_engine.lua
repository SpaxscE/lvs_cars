
function ENT:AddEngine( Pos )
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

	Engine:SetPos( self:LocalToWorld( Pos ) )
	Engine:SetAngles( self:GetAngles() )
	Engine:Spawn()
	Engine:Activate()

	self:SetEngine( Engine )

	return Engine
end
