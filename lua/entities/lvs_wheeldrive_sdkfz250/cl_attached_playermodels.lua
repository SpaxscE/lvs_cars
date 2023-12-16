
include("entities/lvs_tank_wheeldrive/modules/cl_attachable_playermodels.lua")

function ENT:DrawDriver()
	local pod = self:GetFrontGunnerSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "driver" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "driver" ) return end

	local Pos = self:LocalToWorld( Vector(-30,0,32) )
	local Ang = self:LocalToWorldAngles( Angle(0,0,0) )

	local model = self:CreatePlayerModel( ply, "driver" )

	local Pitch = math.Remap( self:GetPoseParameter( "f_pitch" ),0,1,-15,15)
	local Yaw = math.Remap( self:GetPoseParameter( "f_yaw" ),0,1,-35,35) 

	model:SetPoseParameter( "aim_pitch", Pitch * 1.5 )
	model:SetPoseParameter( "aim_yaw", Yaw * 1.5 )

	model:SetPoseParameter( "head_pitch", -Pitch * 2 )
	model:SetPoseParameter( "head_yaw", -Yaw * 2 )

	model:SetSequence( "cwalk_revolver" )
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:DrawGunner()
	local pod = self:GetRearGunnerSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "passenger" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "passenger" ) return end

	local Pos = self:LocalToWorld( Vector(-35,0,30) )
	local Ang = self:LocalToWorldAngles( Angle(0,180,0) )

	local model = self:CreatePlayerModel( ply, "passenger" )

	local Pitch = math.Remap( self:GetPoseParameter( "r_pitch" ),0,1,-15,15)
	local Yaw = math.Remap( self:GetPoseParameter( "r_yaw" ),0,1,-35,35) 

	model:SetPoseParameter( "aim_pitch", Pitch * 3 - 10 )
	model:SetPoseParameter( "aim_yaw", Yaw * 1.5 )

	model:SetPoseParameter( "head_pitch", -Pitch * 2 )
	model:SetPoseParameter( "head_yaw", -Yaw * 2 )

	model:SetSequence( "cwalk_revolver" )
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:PreDraw()
	self:DrawDriver()
	self:DrawGunner()

	return true
end
