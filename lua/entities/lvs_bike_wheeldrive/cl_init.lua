include("shared.lua")

function ENT:CalcViewDirectInput( ply, pos, angles, fov, pod )
	local roll = angles.r

	angles.r = math.max( math.abs( roll ) - 30, 0 ) * (angles.r > 0 and 1.5 or -1.5)
	return LVS:CalcView( self, ply, pos, angles,  fov, pod )
end
