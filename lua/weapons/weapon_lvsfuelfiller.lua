AddCSLuaFile()

SWEP.Category				= "LVS"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.ViewModel			= "models/weapons/c_fuelfillerlvs.mdl"
SWEP.WorldModel			= "models/props_equipment/gas_pump_p13.mdl"
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

function SWEP:SetupDataTables()
	--self:NetworkVar( "Int",0, "FuelType" )
end

if CLIENT then
	SWEP.PrintName		= "Fuel Filler Pistol"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 12

	SWEP.DrawWeaponInfoBox 	= false

	function SWEP:DrawWorldModel()
		local ply = self:GetOwner()

		if not IsValid( ply ) then return end

		local id =ply:LookupAttachment("anim_attachment_rh")
		local attachment = ply:GetAttachment( id )

		if not attachment then return end

		local pos = attachment.Pos + attachment.Ang:Forward() * 6 + attachment.Ang:Right() * -1.5 + attachment.Ang:Up() * 2.2
		local ang = attachment.Ang
		ang:RotateAroundAxis(attachment.Ang:Up(), 20)
		ang:RotateAroundAxis(attachment.Ang:Right(), -30)
		ang:RotateAroundAxis(attachment.Ang:Forward(), 0)

		self:SetRenderOrigin( pos )
		self:SetRenderAngles( ang )

		self:DrawModel()	
	end

	function SWEP:DrawHUD()
	end
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:OwnerChanged()
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	return false
end

function SWEP:SecondaryAttack()
	return false
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	return true
end
