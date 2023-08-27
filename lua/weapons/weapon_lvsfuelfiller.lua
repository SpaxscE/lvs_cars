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

SWEP.HitDistance = 128

function SWEP:SetupDataTables()
	self:NetworkVar( "Int",0, "FuelType" )
end

function SWEP:GetTank( entity )
	if entity.lvsGasStationRefillMe then
		return entity
	end

	if not entity.LVS or not entity.GetFuelTank then return NULL end

	return entity:GetFuelTank()
end

function SWEP:GetCap( entity )
	if entity.lvsGasStationRefillMe then
		return entity
	end

	if not entity.LVS or not entity.GetFuelTank then return NULL end

	local FuelTank = entity:GetFuelTank()

	if not IsValid( FuelTank ) then return NULL end

	return FuelTank:GetDoorHandler()
end

if CLIENT then
	SWEP.PrintName		= "Fuel Filler Pistol"
	SWEP.Slot				= 1
	SWEP.SlotPos			= 12

	SWEP.DrawWeaponInfoBox 	= false

	function SWEP:DrawWorldModel()
		local ply = self:GetOwner()

		if not IsValid( ply ) then return end

		local id = ply:LookupAttachment("anim_attachment_rh")
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
		local ply = self:GetOwner()

		if not IsValid( ply ) then return end

		local startpos = ply:GetShootPos()
		local endpos = startpos + ply:GetAimVector() * self.HitDistance

		local trace = util.TraceLine( {
			start = startpos ,
			endpos = endpos,
			filter = ply,
			mask = MASK_SHOT_HULL
		} )

		if not IsValid( trace.Entity ) then
			trace = util.TraceHull( {
				start = startpos ,
				endpos = endpos,
				filter = ply,
				mins = Vector( -10, -10, -8 ),
				maxs = Vector( 10, 10, 8 ),
				mask = MASK_SHOT_HULL
			} )
		end

		local FuelCap = self:GetCap( trace.Entity )

		if not IsValid( FuelCap ) or FuelCap:IsOpen() then return end

		local point = FuelCap:GetPos()
		local data2D = point:ToScreen()

		if not data2D.visible then return end

		draw.SimpleText( "Press E to Open!", "Default", data2D.x, data2D.y, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + 0.5 )

	local ply = self:GetOwner()

	if not IsValid( ply ) then return end

	local startpos = ply:GetShootPos()
	local endpos = startpos + ply:GetAimVector() * self.HitDistance

	local trace = util.TraceLine( {
		start = startpos ,
		endpos = endpos,
		filter = ply,
		mask = MASK_SHOT_HULL
	} )

	if not IsValid( trace.Entity ) then
		trace = util.TraceHull( {
			start = startpos ,
			endpos = endpos,
			filter = ply,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

	self:Refuel( trace.Entity )
end

function SWEP:SecondaryAttack()
end

function SWEP:Refuel( entity )
	if CLIENT or not IsValid( entity ) then return end

	local FuelCap = self:GetCap( entity )
	local FuelTank = self:GetTank( entity )

	if not IsValid( FuelTank ) then return end

	if FuelTank:GetFuelType() ~= self:GetFuelType() then return end

	if IsValid( FuelCap ) and not FuelCap:IsOpen() then return end

	if FuelTank:GetFuel() ~= 1 then
		FuelTank:SetFuel( math.min( FuelTank:GetFuel() + (entity.lvsGasStationFillSpeed or 0.005), 1 ) )
		entity:OnRefueled()
	end
end