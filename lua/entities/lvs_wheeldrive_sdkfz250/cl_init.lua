include("shared.lua")
include("sh_tracks.lua")
include("cl_tankview.lua")
include("cl_attached_playermodels.lua")



function ENT:OnSpawn()
	self:CreateBonePoseParameter( "hatch1", 59, Angle(0,0,0), Angle(0,60,0), Vector(0,0,0), Vector(0,0,0) )
	self:CreateBonePoseParameter( "hatch2", 60, Angle(0,0,0), Angle(0,60,0), Vector(0,0,0), Vector(0,0,0) )
end

