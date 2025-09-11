
include("entities/lvs_tank_wheeldrive/modules/cl_tankview.lua")

function ENT:TankViewOverride( ply, pos, angles, fov, pod )
	if ply == self:GetDriver() and not pod:GetThirdPersonMode() then
		local vieworigin, found = self:GetTurretViewOrigin()

		if found then pos = vieworigin end
	end

	return pos, angles, fov
end