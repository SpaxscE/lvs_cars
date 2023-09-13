AddCSLuaFile()

SWEP.Category				= "[LVS]"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.ViewModel			= "models/weapons/c_repairlvs.mdl"
SWEP.WorldModel			= "models/weapons/w_repairlvs.mdl"
SWEP.UseHands				= true

SWEP.HoldType				= "slam"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo		= "none"

SWEP.MaxRange = 250

function SWEP:GetLVS()
	local ply = self:GetOwner()

	if not IsValid( ply ) then return NULL end

	local ent = ply:GetEyeTrace().Entity

	if not IsValid( ent ) then return NULL end

	if ent.LVS then return ent end

	if not ent.GetBase then return NULL end

	ent = ent:GetBase()

	if IsValid( ent ) and ent.LVS then return ent end

	return NULL
end

function SWEP:FindClosest()
	local lvsEnt = self:GetLVS()

	if not IsValid( lvsEnt ) then return NULL end

	local ply = self:GetOwner()

	if ply:InVehicle() then return end

	local ShootPos = ply:GetShootPos()
	local AimVector = ply:GetAimVector()

	local ClosestDist = self.MaxRange
	local ClosestPiece = NULL

	for _, entity in pairs( lvsEnt:GetChildren() ) do
		if entity:GetClass() ~= "lvs_wheeldrive_armor" then continue end

		local boxOrigin = entity:GetPos()
		local boxAngles = entity:GetAngles()
		local boxMins = entity:GetMins()
		local boxMaxs = entity:GetMaxs()

		local HitPos, _, _ = util.IntersectRayWithOBB( ShootPos, AimVector * 1000, boxOrigin, boxAngles, boxMins, boxMaxs )

		if isvector( HitPos ) then
			local Dist = (ShootPos - HitPos):Length()

			if Dist < ClosestDist then
				ClosestDist = Dist
				ClosestPiece = entity
			end
		end
	end

	return ClosestPiece
end

if CLIENT then
	SWEP.PrintName		= "Armor Repair Torch"
	SWEP.Author			= "Blu-x92"

	SWEP.Slot				= 5
	SWEP.SlotPos			= 1

	SWEP.Purpose			= "Repair Broken Armor"
	SWEP.Instructions		= "Primary to Repair"
	SWEP.DrawWeaponInfoBox 	= true

	SWEP.WepSelectIcon 			= surface.GetTextureID( "weapons/lvsrepair" )

	local ColorSelect = Color(50,50,50,150)
	local ColorTransBlack = Color(0,0,0,50)
	local OutlineThickness = Vector(0.5,0.5,0.5)
	local ColorText = Color(255,255,255,255)

	local function DrawText( pos, text, col )
		local data2D = pos:ToScreen()

		if not data2D.visible then return end

		local font = "TargetIDSmall"

		local x = data2D.x
		local y = data2D.y

		draw.DrawText( text, font, x + 1, y + 1, Color( 0, 0, 0, 120 ), TEXT_ALIGN_CENTER )
		draw.DrawText( text, font, x + 2, y + 2, Color( 0, 0, 0, 50 ), TEXT_ALIGN_CENTER )
		draw.DrawText( text, font, x, y, col or color_white, TEXT_ALIGN_CENTER )
	end

	function SWEP:DrawHUD()
		local Target = self:FindClosest()

		if IsValid( Target ) then
			local boxOrigin = Target:GetPos()
			local boxAngles = Target:GetAngles()
			local boxMins = Target:GetMins()
			local boxMaxs = Target:GetMaxs()

			cam.Start3D()
				render.SetColorMaterial()
				render.DrawBox( boxOrigin, boxAngles, boxMins, boxMaxs, ColorSelect )
				render.DrawBox( boxOrigin, boxAngles, boxMaxs + OutlineThickness, boxMins - OutlineThickness, ColorTransBlack )
			cam.End3D()

			DrawText( Target:LocalToWorld( (boxMins + boxMaxs) * 0.5 ), "Armor: "..(Target:GetIgnoreForce() / 100).."mm\nHealth:"..Target:GetHP().."/"..Target:GetMaxHP(), ColorText )
		end
	end
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 0.1 )

	local Target = self:FindClosest()

	if not IsValid( Target ) then return end

	local HP = Target:GetHP()
	local MaxHP = Target:GetMaxHP()

	if IsFirstTimePredicted() then
		if HP ~= MaxHP then
			Target:EmitSound("ambient/energy/spark"..math.random(1,6)..".wav")

			local ply = self:GetOwner()
			if IsValid( ply ) then
				local trace = ply:GetEyeTrace()

				local effectdata = EffectData()
				effectdata:SetOrigin( trace.HitPos )
				effectdata:SetNormal( trace.HitNormal )
				util.Effect( "stunstickimpact", effectdata, true, true )
			end
		end
	end

	if CLIENT then return end

	Target:SetHP( math.min( HP + 5, MaxHP ) )

	if Target:GetDestroyed() then Target:SetDestroyed( false ) end
end

function SWEP:SecondaryAttack()
end
