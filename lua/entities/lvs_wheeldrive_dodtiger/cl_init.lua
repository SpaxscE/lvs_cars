include("shared.lua")
include("sh_turret.lua")
include("sh_tracks.lua")

function ENT:UpdatePoseParameters( steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter )
	self:CalcTurret()
end


include("entities/lvs_tank_wheeldrive/cl_tankview.lua")
function ENT:TankViewOverride( ply, pos, angles, fov, pod )
	if ply == self:GetDriver() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "muzzle" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos - Muzzle.Ang:Up() * 130 + Muzzle.Ang:Forward() * 15 - Muzzle.Ang:Right() * 8
		end

	end

	return pos, angles, fov
end


function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/tiger/engine_start.wav", 75, 100,  LVS.EngineVolume )
	else
		self:EmitSound( "lvs/vehicles/tiger/engine_stop.wav", 75, 100,  LVS.EngineVolume )
	end
end