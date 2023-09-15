
DEFINE_BASECLASS( "lvs_base" )

ENT.OpticsFov = 30
ENT.OpticsEnable = false
ENT.OpticsZoomOnly = true
ENT.OpticsFirstPerson = true
ENT.OpticsThirdPerson = true
ENT.OpticsPodIndex = {
	[1] = true,
}

function ENT:GetOpticsEnabled()
	if not self.OpticsEnable then return false end

	local ply = LocalPlayer()

	if not IsValid( ply ) then return false end

	local pod = ply:GetVehicle()
	local PodIndex = pod:GetNWInt( "pPodIndex", -1 )
	if pod == self:GetDriverSeat() then
		PodIndex = 1
	end

	if self.OpticsPodIndex[ PodIndex ] then
		if pod:GetThirdPersonMode() then
			return self.OpticsThirdPerson
		else
			return self.OpticsFirstPerson
		end
	end

	return false
end

function ENT:UseOptics()
	if self.OpticsZoomOnly and self:GetZoom() ~= 1 then return false end

	return self:GetOpticsEnabled()
end

function ENT:PaintCrosshairCenter( Pos2D, Col )

	if self:UseOptics() then

		self:PaintOptics( Pos2D, Col, LocalPlayer():GetVehicle():GetNWInt( "pPodIndex", -1 ), 1 )

		return
	end

	BaseClass.PaintCrosshairCenter( self, Pos2D, Col )
end

function ENT:PaintCrosshairOuter( Pos2D, Col )
	if self:UseOptics() then

		self:PaintOptics( Pos2D, Col, LocalPlayer():GetVehicle():GetNWInt( "pPodIndex", -1 ), 2 )

		return
	end

	BaseClass.PaintCrosshairOuter( self, Pos2D, Col )
end

function ENT:PaintCrosshairSquare( Pos2D, Col )
	if self:UseOptics() then

		self:PaintOptics( Pos2D, Col, LocalPlayer():GetVehicle():GetNWInt( "pPodIndex", -1 ), 3 )

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

function ENT:PaintOptics( Pos2D, Col, PodIndex, Type )
end
