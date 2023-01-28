include("shared.lua")

 function ENT:LVSCalcView( ply, pos, angles, fov, pod )
	pos = pos + pod:GetUp() * 7 - pod:GetRight() * 11
	return LVS:CalcView( self, ply, pos, angles, fov, pod )
end
