include("shared.lua")
include("sh_animations.lua")
include("sh_collisionfilter.lua")

 function ENT:LVSCalcView( ply, pos, angles, fov, pod )
	pos = pos + pod:GetUp() * 7 - pod:GetRight() * 11
	return LVS:CalcView( self, ply, pos, angles, fov, pod )
end
