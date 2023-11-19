AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

ENT.RenderGroup = RENDERGROUP_BOTH

ENT.HookupDistance = 80

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )
	self:NetworkVar( "Entity",1, "TargetBase" )
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
		PrintChat(self)
	end

	function ENT:Decouple()
		local TargetBase = self:GetTargetBase()

		self:SetTargetBase( NULL )

		if not IsValid( self.HitchConstraint ) then return end

		local base = self:GetBase()

		if IsValid( base ) then
			base:OnDecoupled( TargetBase, self.HitchTarget )
		end

		self.HitchConstraint:Remove()

		self.HitchTarget = nil
	end

	function ENT:CoupleTo( target )
		if not IsValid( target ) or IsValid( self.HitchConstraint ) then return end

		local base = self:GetBase()

		if self.IsLinkInProgress or not IsValid( base ) or IsValid( self.PosEnt ) then return end

		self.IsLinkInProgress = true

		if self:GetHitchType() ~= LVS.HITCHTYPE_FEMALE or target:GetHitchType() ~= LVS.HITCHTYPE_MALE then self.IsLinkInProgress = nil return end

		self.PosEnt = ents.Create( "prop_physics" )

		if not IsValid( self.PosEnt ) then self.IsLinkInProgress = nil return end

		self.PosEnt:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )
		self.PosEnt:SetPos( self:GetPos() )
		self.PosEnt:SetAngles( self:GetAngles() )
		self.PosEnt:SetCollisionGroup( COLLISION_GROUP_WORLD )
		self.PosEnt:Spawn()
		self.PosEnt:Activate()
		self.PosEnt:SetNoDraw( true ) 
		self:DeleteOnRemove( self.PosEnt )

		local PhysObj = self.PosEnt:GetPhysicsObject()

		if not IsValid( PhysObj ) then self.IsLinkInProgress = nil return end

		PhysObj:SetMass( 50000 )
		PhysObj:EnableMotion( false )

		constraint.Ballsocket( base, self.PosEnt, 0, 0, vector_origin, 0, 0, 1 )

		local targetBase = target:GetBase()

		base:OnCoupled( targetBase, target )

		timer.Simple( 0, function()
			if not IsValid( self.PosEnt ) then
				self.IsLinkInProgress = nil

				return
			end
	
			if not IsValid( target ) or not IsValid( targetBase ) then
				self.PosEnt:Remove()
	
				self.IsLinkInProgress = nil
	
				return
			end
	
			self.PosEnt:SetPos( target:GetPos() )

			constraint.Weld( self.PosEnt, targetBase, 0, 0, 0, false, false )

			timer.Simple( 0.25, function()
				if not IsValid( base ) or not IsValid( targetBase ) or not IsValid( self.PosEnt ) then self.IsLinkInProgress = nil return end

				self.HitchTarget = target
				self.HitchConstraint = constraint.Ballsocket( base, targetBase, 0, 0, targetBase:WorldToLocal( self.PosEnt:GetPos() ), 0, 0, 1 )

				self:SetTargetBase( targetBase )

				self.PosEnt:Remove()

				self.IsLinkInProgress = nil 
			end )
		end )
	end

	function ENT:Think()
		return false
	end

	function ENT:OnTakeDamage( dmginfo )
	end

	function ENT:OnRemove()
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
	local ply = LocalPlayer()

	if not IsValid( ply ) or IsValid( ply:lvsGetVehicle() ) then return end

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

			if not IsValid( ent ) then continue end

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

			if dist > self.HookupDistance then continue end

			surface.SetDrawColor( Col.r, Col.g, Col.b, Col.a )
			surface.DrawLine( X, Y, tX, tY )
		end
	cam.End2D()
end
