include("shared.lua")
include("sh_animations.lua")

 function ENT:LVSCalcView( ply, pos, angles, fov, pod )
	if pod == self:GetDriverSeat() then
		pos = pos + pod:GetUp() * 7 - pod:GetRight() * 11
	end

	return LVS:CalcView( self, ply, pos, angles, fov, pod )
end
