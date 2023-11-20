include("shared.lua")


function ENT:UpdatePoseParameters( steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter )
	local Prongs = self:GetProngs()

	local T = CurTime()

	if Prongs then self._ProngTime = T + 1 end

	local ProngsActive = (self._ProngTime or 0) > T

	self:SetPoseParameter( "prong", self:QuickLerp( "pront", (ProngsActive and 1 or 0), 10 ) )
end