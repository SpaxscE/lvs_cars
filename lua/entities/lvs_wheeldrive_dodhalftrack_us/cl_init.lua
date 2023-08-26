include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")
include("entities/lvs_tank_wheeldrive/cl_tankview.lua")

function ENT:UpdatePoseParameters( steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter )
	self:SetPoseParameter( "vehicle_steer", steer )
	self:CalcTurret()
end


function ENT:OnFrame()
	local Heat = 0
	if self:GetSelectedWeapon() == 1 then
		Heat = self:QuickLerp( "50cal_heat", self:GetNWHeat(), 10 )
	else
		Heat = self:QuickLerp( "50cal_heat", 0, 0.2 )
	end

	local name = "halftrack_gunglow_"..self:EntIndex()

	if not self.TurretGlow then
		self.TurretGlow = self:CreateSubMaterial( 4, name )

		return
	end

	if self._oldGunHeat ~= Heat then
		self._oldGunHeat = Heat

		self.TurretGlow:SetFloat("$detailblendfactor", Heat ^ 2 )

		self:SetSubMaterial(4, "!"..name)
	end
end