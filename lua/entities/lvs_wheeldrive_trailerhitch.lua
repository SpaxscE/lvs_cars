AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )
	self:NetworkVar( "Entity",1, "Player" )
	self:NetworkVar( "Entity",2, "HitchTarget" )
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

	return
end

local HitchEnts = {}

function ENT:Initialize()
	table.insert( HitchEnts, self )
end

function ENT:OnRemove()
	for id, e in pairs( HitchEnts ) do
		if IsValid( e ) then continue end

		HitchEnts[ id ] = nil
	end
end

function ENT:Draw()
end

local function DrawDiamond( X, Y, radius )
	local segmentdist = 90
	local radius2 = radius + 1
	
	for a = 0, 360, segmentdist do
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius2, Y - math.sin( math.rad( a ) ) * radius2, X + math.cos( math.rad( a + segmentdist ) ) * radius2, Y - math.sin( math.rad( a + segmentdist ) ) * radius2 )
	end
end

local circle = Material( "vgui/circle" )
local radius = 6
local Col = Color(255,191,0,255)

function ENT:DrawTranslucent()
	local HitchType = self:GetHitchType()

	if HitchType ~= LVS.HITCHTYPE_MALE then return end

	local pos = self:GetPos()
	local scr = pos:ToScreen()

	if not scr.visible then return end

	local X = scr.x
	local Y = scr.y

	cam.Start2D()
		for id, ent in pairs( HitchEnts ) do
			if ent == self then continue end

			local tpos = ent:GetPos()

			local dist = (tpos - pos):Length()

			if dist > 200 then continue end

			surface.SetMaterial( circle )
			surface.SetDrawColor( 0, 0, 0, 80 )
			surface.DrawTexturedRect( X - radius * 0.5 + 1, Y - radius * 0.5 + 1, radius, radius )

			surface.SetDrawColor( Col.r, Col.g, Col.b, Col.a )
			surface.DrawTexturedRect( X - radius * 0.5, Y - radius * 0.5, radius, radius )

			surface.SetDrawColor( Col.r, Col.g, Col.b, Col.a )

			local tscr = tpos:ToScreen()

			if not tscr.visible then continue end

			local tX = tscr.x
			local tY = tscr.y

			DrawDiamond( tX, tY, radius )
			surface.SetDrawColor( 0, 0, 0, 80 )
			DrawDiamond( tX + 1, tY + 1, radius )

			if dist > 50 then continue end

			surface.SetDrawColor( Col.r, Col.g, Col.b, Col.a )
			surface.DrawLine( X, Y, tX, tY )
		end
	cam.End2D()
end
