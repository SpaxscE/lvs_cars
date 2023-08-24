
function ENT:GetPlayerModel( name )
	if not istable( self._PlayerModels ) then return end

	return self._PlayerModels[ name ]
end

function ENT:RemovePlayerModel( name )
	if not istable( self._PlayerModels ) then return end

	for id, model in pairs( self._PlayerModels ) do
		if name and id ~= name then continue end

		if not IsValid( model ) then continue end

		model:Remove()
	end
end

function ENT:CreatePlayerModel( ply, name )
	if not istable( self._PlayerModels ) then
		self._PlayerModel  = {}
	end

	if IsValid( self._PlayerModels ) then return self._PlayerModels end

	local model = ClientsideModel( ply:GetModel() )
	model:SetNoDraw( true )

	model.GetPlayerColor = function() return ply:GetPlayerColor() end
	model:SetSkin( ply:GetSkin() )

	self._PlayerModel = model

	return model
end

function ENT:DrawDriver()
	local pod = self:GetDriverSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "driver" ) return end

	local plyL = LocalPlayer()
	local ply = self:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "driver" ) return end

	local ID = self:LookupAttachment( "seat1" )
	local Att = self:GetAttachment( ID )

	if not Att then self:RemovePlayerModel() return end

	local Pos,Ang = LocalToWorld( Vector(10,-5,0), Angle(0,20,-90), Att.Pos, Att.Ang )

	local model = self:CreatePlayerModel( ply, "driver" )

	model:SetSequence( "sit" )
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:PreDraw()
	self:DrawDriver()

	return true
end

function ENT:OnRemoved()
	self:RemovePlayerModel()
end