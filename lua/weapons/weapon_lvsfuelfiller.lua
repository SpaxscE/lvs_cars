AddCSLuaFile()

SWEP.Category				= "[LVS]"
SWEP.Spawnable			= false
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

SWEP.RangeToCap = 24
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
	SWEP.SlotPos			= 3

	SWEP.DrawWeaponInfoBox 	= false

	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	end

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

	local function DrawText( pos, text, col )
		local data2D = pos:ToScreen()

		if not data2D.visible then return end

		local font = "TargetIDSmall"

		local x = data2D.x
		local y = data2D.y
		draw.SimpleText( text, font, x + 1, y + 1, Color( 0, 0, 0, 120 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, font, x + 2, y + 2, Color( 0, 0, 0, 50 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( text, font, x, y, col or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
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

		local FuelTank = self:GetTank( trace.Entity )
		local FuelCap = self:GetCap( trace.Entity )

		if not IsValid( FuelTank ) then return end

		if FuelTank:GetFuelType() ~= self:GetFuelType() then
			DrawText( trace.HitPos, "Incorrect Fuel Type", Color(255,0,0,255) )

			return
		end

		if not IsValid( FuelCap ) then
			DrawText( trace.HitPos, math.Round(FuelTank:GetFuel() * 100,1).."%", Color(0,255,0,255) )

			return
		end

		if FuelCap:IsOpen() then
			if (trace.HitPos - FuelCap:GetPos()):Length() > self.RangeToCap then
				DrawText( trace.HitPos, "Aim at Fuel Cap!", Color(255,255,0,255) )
			else
				DrawText( trace.HitPos, math.Round(FuelTank:GetFuel() * 100,1).."%", Color(0,255,0,255) )
			end

			return
		end

		local Key = input.LookupBinding( "+use" )

		if not isstring( Key ) then Key = "[+use is not bound to a key]" end

		DrawText( FuelCap:GetPos(), "Press "..Key.." to Open", Color(255,255,0,255) )
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

	self:Refuel( trace )
end

function SWEP:SecondaryAttack()
end

function SWEP:Refuel( trace )
	local entity = trace.Entity

	if CLIENT or not IsValid( entity ) then return end

	local FuelCap = self:GetCap( entity )
	local FuelTank = self:GetTank( entity )

	if not IsValid( FuelTank ) then return end

	if FuelTank:GetFuelType() ~= self:GetFuelType() then return end

	if IsValid( FuelCap ) then
		if not FuelCap:IsOpen() then return end

		if (trace.HitPos - FuelCap:GetPos()):Length() > self.RangeToCap then return end
	end

	if FuelTank:GetFuel() ~= 1 then
		FuelTank:SetFuel( math.min( FuelTank:GetFuel() + (entity.lvsGasStationFillSpeed or 0.05), 1 ) )
		entity:OnRefueled()
	end
end