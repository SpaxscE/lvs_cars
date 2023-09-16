include("shared.lua")
include("sh_turret.lua")
include("cl_tankview.lua")
include("cl_attached_playermodels.lua")

function ENT:OnFrame()
	local Heat1 = 0
	if self:GetSelectedWeapon() == 2 then
		Heat1 = self:QuickLerp( "cannon_heat", self:GetNWHeat(), 10 )
	else
		Heat1 = self:QuickLerp( "cannon_heat", 0, 0.25 )
	end
	local name = "spaehwagen_cannonglow_"..self:EntIndex()
	if not self.TurretGlow1 then
		self.TurretGlow1 = self:CreateSubMaterial( 3, name )

		return
	end
	if self._oldGunHeat1 ~= Heat1 then
		self._oldGunHeat1 = Heat1

		self.TurretGlow1:SetFloat("$detailblendfactor", Heat1 ^ 7 )

		self:SetSubMaterial(3, "!"..name)
	end


	local Heat2 = 0
	if self:GetSelectedWeapon() == 1 then
		Heat2 = self:QuickLerp( "mg_heat", self:GetNWHeat(), 10 )
	else
		Heat2 = self:QuickLerp( "mg_heat", 0, 0.25 )
	end
	local name = "spaehwagen_mgglow_"..self:EntIndex()
	if not self.TurretGlow2 then
		self.TurretGlow2 = self:CreateSubMaterial( 2, name )

		return
	end
	if self._oldGunHeat2 ~= Heat2 then
		self._oldGunHeat2 = Heat2

		self.TurretGlow2:SetFloat("$detailblendfactor", Heat2 ^ 7 )

		self:SetSubMaterial(2, "!"..name)
	end
end
