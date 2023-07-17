include("shared.lua")
include("sh_animations.lua")

DEFINE_BASECLASS( "lvs_base" )

function ENT:Initialize()
	self:InitFromList()
	BaseClass.Initialize( self )
end

 function ENT:LVSCalcView( ply, pos, angles, fov, pod )
	if pod == self:GetDriverSeat() then
		pos = pos + pod:GetUp() * 7 - pod:GetRight() * 11
	end

	return LVS:CalcView( self, ply, pos, angles, fov, pod )
end
