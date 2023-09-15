
AddCSLuaFile( "cl_optics.lua" )
--include("cl_optics.lua")


DEFINE_BASECLASS( "lvs_base" )

ENT.UseOptics = false

function ENT:UseOptics()
	local ply = LocalPlayer()

	if not IsValid( ply ) then return false end

	local pod = ply:GetVehicle()

	if pod == self:GetDriverSeat() then return not pod:GetThirdPersonMode() end

	return false
end

function ENT:PaintCrosshairCenter( Pos2D, Col )

	if self:UseOptics() then

		self:PaintOptics( Pos2D, Col )

		return
	end

	BaseClass.PaintCrosshairCenter( self, Pos2D, Col )
end

function ENT:PaintCrosshairOuter( Pos2D, Col )
	if self:UseOptics() then

		self:PaintOptics( Pos2D, Col )

		return
	end

	BaseClass.PaintCrosshairOuter( self, Pos2D, Col )
end

function ENT:PaintCrosshairSquare( Pos2D, Col )
	if self:UseOptics() then

		self:PaintOptics( Pos2D, Col )

		return
	end

	BaseClass.PaintCrosshairSquare( self, Pos2D, Col )
end

function ENT:DrawRotatedText( text, x, y, font, color, ang)
	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )

	local m = Matrix()
	m:Translate( Vector( x, y, 0 ) )
	m:Rotate( Angle( 0, ang, 0 ) )

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	m:Translate( -Vector( w / 2, h / 2, 0 ) )

	cam.PushModelMatrix( m )
		draw.DrawText( text, font, 0, 0, color )
	cam.PopModelMatrix()

	render.PopFilterMag()
	render.PopFilterMin()
end

function ENT:PaintOptics( Pos2D, Col )
end