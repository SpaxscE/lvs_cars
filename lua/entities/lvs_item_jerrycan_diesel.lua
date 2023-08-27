AddCSLuaFile()

ENT.Base = "lvs_item_jerrycan"
DEFINE_BASECLASS( "lvs_item_jerrycan" )

ENT.PrintName = "Jerry Can (Diesel)"
ENT.Author = "Luna"
ENT.Category = "[LVS] - Cars - Items"

ENT.Spawnable		= true
ENT.AdminOnly		= false

ENT.AutomaticFrameAdvance = true

ENT.FuelType = LVS.FUELTYPE_DIESEL

ENT.lvsGasStationRefillMe = true

if SERVER then
	function ENT:Initialize()
		BaseClass.Initialize( self )
		self:SetSkin( 1 )
	end
else
	ENT.IconColor = Color(255,60,0,255)
	ENT.Text = "Diesel"
end