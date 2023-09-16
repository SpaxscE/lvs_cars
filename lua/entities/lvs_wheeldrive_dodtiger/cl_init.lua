include("shared.lua")
include("sh_tracks.lua")
include("cl_optics.lua")
include("sh_turret.lua")


include("entities/lvs_tank_wheeldrive/modules/cl_tankview.lua")
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


local switch = Material("lvs/weapons/change_ammo.png")
local AP = Material("lvs/weapons/bullet_ap.png")
local HE = Material("lvs/weapons/tank_cannon.png")
function ENT:DrawWeaponIcon( PodID, ID, x, y, width, height, IsSelected, IconColor )
	local Icon = self:GetUseHighExplosive() and HE or AP

	surface.SetMaterial( Icon )
	surface.DrawTexturedRect( x, y, width, height )

	local ply = LocalPlayer()

	if not IsValid( ply ) or self:GetSelectedWeapon() ~= 2 then return end

	surface.SetMaterial( switch )
	surface.DrawTexturedRect( x + width + 5, y + 7, 24, 24 )

	local buttonCode = ply:lvsGetControls()[ "CAR_SWAP_AMMO" ]

	if not buttonCode then return end

	local KeyName = input.GetKeyName( buttonCode )

	if not KeyName then return end

	draw.DrawText( KeyName, "DermaDefault", x + width + 17, y + height * 0.5 + 7, Color(0,0,0,IconColor.a), TEXT_ALIGN_CENTER )
end


function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/tiger/engine_start.wav", 75, 100,  LVS.EngineVolume )
	else
		self:EmitSound( "lvs/vehicles/tiger/engine_stop.wav", 75, 100,  LVS.EngineVolume )
	end
end
