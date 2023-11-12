AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )
	self:NetworkVar( "Int",0, "HitchType" )
end

if SERVER then
	function ENT:Initialize()	
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		self:DrawShadow( false )
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

function ENT:DrawTranslucent()
	local scr = self:GetPos():ToScreen()

	local X = scr.x
	local Y = scr.y

	cam.Start2D()
		local radius = 25 + math.cos( CurTime() * 10 ) * 2

		local Col = Color(255,191,0,255)

		surface.SetDrawColor( Col.r, Col.g, Col.b, Col.a )

		DrawDiamond( X, Y, radius )

		surface.SetDrawColor( 0, 0, 0, 80 )

		DrawDiamond( X + 1, Y + 1, radius )
	cam.End2D()
end
