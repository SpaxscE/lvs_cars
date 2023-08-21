include("shared.lua")
include("sh_turret.lua")
include("sh_tracks.lua")

function ENT:UpdatePoseParameters( steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter )
	self:CalcTracks()
	self:CalcTurret()
end

function ENT:LVSPreHudPaint( X, Y, ply )
	if ply == self:GetDriver() then
		local Col = Color(255,255,255,255)

		local ID = self:LookupAttachment( "turret_cannon" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Up() * 50000,
				filter = self:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			self:PaintCrosshairCenter( MuzzlePos2D, Col )
		end
	end

	return true
end

function ENT:CalcViewOverride( ply, pos, angles, fov, pod )
	if ply == self:GetDriver() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "turret_cannon" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos - Muzzle.Ang:Up() * 60 - Muzzle.Ang:Forward() * 20
		end

	end

	return pos, angles, fov
end
