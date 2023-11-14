AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )
	self:NetworkVar( "Entity",1, "HitchTarget" )
	self:NetworkVar( "Int",0, "HitchType" )

	if SERVER then
		self:SetHitchType( LVS.HITCHTYPE_NONE or -1 )
	end
end

if SERVER then
	function ENT:Initialize()	
		self:SetSolid( SOLID_NONE )
		self:SetMoveType( MOVETYPE_NONE )
		self:DrawShadow( false )
	end

	function ENT:Think()
		return false
	end

	function ENT:OnTakeDamage( dmginfo )
	end

	function ENT:OnRemove()
	end

	function ENT:UpdateLink( target, enable )
		local base = self:GetBase()

		if not IsValid( base ) or target == base then return end

		if not enable then
			if target == self:GetHitchTarget() then
				self:SetHitchTarget( NULL )
			end
	
			return
		end

		if not IsValid( target ) or not target.LVS or not target.GetHitchType then return end

		local TargetHitchType = target:GetHitchType()

		if TargetHitchType == LVS.HITCHTYPE_NONE or self:GetHitchType() == TargetHitchType then return end -- no gay sex allowed

		self:SetHitchTarget( target )
	end

	--self:UpdateLink( entity, true )

	return
end

function ENT:Initialize()
end

function ENT:OnRemove()
end

local function DrawDiamond( X, Y, radius )
	local segmentdist = 90
	local radius2 = radius + 1
	
	for a = 0, 360, segmentdist do
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius2, Y - math.sin( math.rad( a ) ) * radius2, X + math.cos( math.rad( a + segmentdist ) ) * radius2, Y - math.sin( math.rad( a + segmentdist ) ) * radius2 )
	end
end

function ENT:Draw()
end

local boxMins = Vector(-15,-15,-15)
local boxMaxs = Vector(15,15,15)

local function DrawText( x, y, text, col )
	local font = "TargetIDSmall"

	draw.SimpleText( text, font, x + 1, y + 1, Color( 0, 0, 0, 120 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( text, font, x + 2, y + 2, Color( 0, 0, 0, 50 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	draw.SimpleText( text, font, x, y, col or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function ENT:DrawTranslucent()
	local ply = LocalPlayer()

	if not IsValid( ply ) or ply:InVehicle() then return end

	local shootPos = ply:GetShootPos()

	local boxOrigin = self:GetPos()
	local boxAngles = self:GetAngles()

	if (boxOrigin - shootPos):LengthSqr() > 250000 then return end

	local HitPos, _, _ = util.IntersectRayWithOBB( shootPos, ply:GetAimVector() * 150, boxOrigin, boxAngles, boxMins, boxMaxs )

	local scr = boxOrigin:ToScreen()

	local X = scr.x
	local Y = scr.y

	local radius = 25
	local Col = Color(255,191,0,255)

	if HitPos then
		if ply:KeyDown( IN_USE ) then
			Col = Color(255,0,0,255)
			radius = radius + 5
			-- send attach command
		else
			radius = radius + math.cos( CurTime() * 10 ) * 2
		end
	end

	cam.Start2D()

		surface.SetDrawColor( Col.r, Col.g, Col.b, Col.a )

		DrawDiamond( X, Y, radius )

		surface.SetDrawColor( 0, 0, 0, 80 )

		DrawDiamond( X + 1, Y + 1, radius )

		local Key = input.LookupBinding( "+use" )
		if not isstring( Key ) then Key = "[+use not bound]" end
		DrawText( X, Y + 35, "press "..Key.." to attach cock!", Col )
	cam.End2D()
end
