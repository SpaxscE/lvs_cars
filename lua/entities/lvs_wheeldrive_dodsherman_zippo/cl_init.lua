include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")
include("cl_optics.lua")
include("cl_tankview.lua")

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/sherman/engine_start.wav", 75, 100,  LVS.EngineVolume )
	end
end
