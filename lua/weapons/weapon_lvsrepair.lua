AddCSLuaFile()

SWEP.Category				= "LVS"
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

if CLIENT then
	SWEP.PrintName		= "Repair Torch"
	SWEP.Slot				= 5
	SWEP.SlotPos			= 3

	SWEP.DrawWeaponInfoBox 	= false

	function SWEP:DrawHUD()
	end
end

function SWEP:Think()
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 0.5 )
end

function SWEP:SecondaryAttack()
end
