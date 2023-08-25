include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")
include("entities/lvs_tank_wheeldrive/cl_tankview.lua")

function ENT:UpdatePoseParameters( steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter )
	self:CalcTurret()
end