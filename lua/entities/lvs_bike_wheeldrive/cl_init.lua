include("shared.lua")

function ENT:CalcViewDirectInput( ply, pos, angles, fov, pod )
	local roll = angles.r

	angles.r = math.max( math.abs( roll ) - 30, 0 ) * (angles.r > 0 and 1.5 or -1.5)
	return LVS:CalcView( self, ply, pos, angles,  fov, pod )
end

function ENT:CalcViewPassenger( ply, pos, angles, fov, pod )
	local roll = angles.r

	angles.r = math.max( math.abs( roll ) - 30, 0 ) * (angles.r > 0 and 1.5 or -1.5)
	return LVS:CalcView( self, ply, pos, angles,  fov, pod )
end

local angle_zero = Angle(0,0,0)

function ENT:GetPlayerBoneManipulation( ply, PodID )
	if PodID ~= 1 then return self.PlayerBoneManipulate[ PodID ] or {} end

	local TargetValue = self:ShouldPutFootDown() and 1 or 0

	local Rate = math.min( RealFrameTime() * 2, 1 )

	ply._smlvsBikerFoot = ply._smlvsBikerFoot and (ply._smlvsBikerFoot + (TargetValue - ply._smlvsBikerFoot) * Rate) or 0

	local CurValue = ply._smlvsBikerFoot ^ 2

	local Pose = table.Copy( self.PlayerBoneManipulate[ PodID ] )

	for bone, EndAngle in pairs( self.DriverBoneManipulate ) do
		local StartAngle = Pose[ bone ] or angle_zero

		Pose[ bone ] = LerpAngle( CurValue, StartAngle, EndAngle )
	end

	return Pose or {}
end