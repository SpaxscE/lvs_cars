
include("entities/lvs_tank_wheeldrive/modules/cl_tankview.lua")

function ENT:TankViewOverride( ply, pos, angles, fov, pod )
	if pod == self:GetFrontGunnerSeat() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "f_eye" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos
		end
	end

	if pod == self:GetRearGunnerSeat() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "r_eye" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos
		end
	end

	return pos, angles, fov
end