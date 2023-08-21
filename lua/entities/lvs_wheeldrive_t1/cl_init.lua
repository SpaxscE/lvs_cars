include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")

function ENT:LVSPreHudPaint( X, Y, ply )
	if ply == self:GetDriver() then
		local Col = Color(255,255,255,255)

		local MuzzlePos2D = self:GetEyeTrace().HitPos:ToScreen() 

		self:PaintCrosshairOuter( MuzzlePos2D, Col )
	end

	return true
end

function ENT:UpdatePoseParameters( steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter )
	self:SetPoseParameter( "vehicle_steer", steer )
	self:CalcTracks()
end
