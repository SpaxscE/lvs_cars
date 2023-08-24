include("shared.lua")
include("sh_turret.lua")
include("entities/lvs_tank_wheeldrive/cl_tankview.lua")

function ENT:GetPlayerModel()
	return self._PlayerModel
end

function ENT:RemovePlayerModel()
	local model = self:GetPlayerModel()

	if not IsValid( model ) then return end

	model:Remove()
end

function ENT:CreatePlayerModel( ply )
	if IsValid( self._PlayerModel ) then return self._PlayerModel end

	local model = ClientsideModel( ply:GetModel() )
	model:SetNoDraw( true )

	model.GetPlayerColor = function() return ply:GetPlayerColor() end
	model:SetSkin( ply:GetSkin() )

	self._PlayerModel = model

	return model
end

function ENT:DrawDriver()
	local pod = self:GetDriverSeat()

	if not IsValid( pod ) then self:RemovePlayerModel() return end

	local plyL = LocalPlayer()
	local ply = self:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel() return end

	local ID = self:LookupAttachment( "seat1" )
	local Att = self:GetAttachment( ID )

	if not Att then self:RemovePlayerModel() return end

	local Pos,Ang = LocalToWorld( Vector(10,-5,0), Angle(0,20,-90), Att.Pos, Att.Ang )

	local model = self:CreatePlayerModel( ply )

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
