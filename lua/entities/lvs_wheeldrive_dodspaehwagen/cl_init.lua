include("shared.lua")
include("sh_turret.lua")



include("entities/lvs_tank_wheeldrive/cl_tankview.lua")
function ENT:TankViewOverride( ply, pos, angles, fov, pod )
	if ply == self:GetDriver() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "seat1" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos - Muzzle.Ang:Right() * 25
		end

	end

	return pos, angles, fov
end



include("entities/lvs_tank_wheeldrive/cl_attachable_playermodels.lua")
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
