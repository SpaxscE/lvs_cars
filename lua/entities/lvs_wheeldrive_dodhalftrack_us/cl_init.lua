include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")
include("entities/lvs_tank_wheeldrive/cl_tankview.lua")

function ENT:UpdatePoseParameters( steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter )
	self:CalcTurret()
end


function ENT:OnFrame()
	local name = "halftrack_gunglow_"..self:EntIndex()

	if not self.TurretGlow then
		self.TurretGlow = self:CreateSubMaterial( 4, name )

		return
	end

	local Heat = self:GetNWHeat()

	if self._oldGunHeat ~= Heat then
		self._oldGunHeat = Heat

		self.TurretGlow:SetFloat("$detailblendfactor", Heat ^ 7 )

		self:SetSubMaterial(4, "!"..name)
	end
end