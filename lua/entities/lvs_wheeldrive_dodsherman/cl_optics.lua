
ENT.OpticsFov = 30
ENT.OpticsEnable = true
ENT.OpticsZoomOnly = true
ENT.OpticsFirstPerson = true
ENT.OpticsThirdPerson = false
ENT.OpticsPodIndex = {
	[1] = true,
}

local axis = Material( "lvs/axis.png" )
local sight = Material( "lvs/shermansights.png" )
local Circles = {
	[1] = {r = 0, col = Color(0,0,0,100)},
	[2] = {r = -1, col = Color(0,0,0,92.5)},
	[3] = {r = -2, col = Color(0,0,0,75)},
	[4] = {r = -3, col = Color(0,0,0,60)},
	[5] = {r = -4, col = Color(0,0,0,45)},
	[6] = {r = -5, col = Color(0,0,0,30)},
	[7] = {r = -6, col = Color(0,0,0,15)},
}

function ENT:PaintOptics( Pos2D, Col, PodIndex, Type )
	surface.SetMaterial( axis )
	surface.SetDrawColor( 255, 255, 255, 25 )
	surface.DrawTexturedRect( Pos2D.x - 7, Pos2D.y - 7, 16, 16 )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawTexturedRect( Pos2D.x - 8, Pos2D.y - 8, 16, 16 )

	surface.SetMaterial( sight )
	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.DrawTexturedRect( Pos2D.x - 210, Pos2D.y - 23, 420, 420 )

	if Type == 1 then
		self:DrawRotatedText( "MG", Pos2D.x + 30, Pos2D.y + 10, "LVS_FONT_PANEL", Color(0,0,0,220), 0)
	else
		self:DrawRotatedText( Type == 3 and "HE" or "AP", Pos2D.x + 30, Pos2D.y + 10, "LVS_FONT_PANEL", Color(0,0,0,220), 0)
	end

	for i = 1, #Circles do
		local data = Circles[ i ]
		local radius = ScrH() * 0.5 + data.r
		local segmentdist = 360 / ( math.pi * radius / 2 )

		for a = 0, 360, segmentdist do
			surface.SetDrawColor( data.col )

			surface.DrawLine( Pos2D.x - math.sin( math.rad( a ) ) * radius, Pos2D.y + math.cos( math.rad( a ) ) * radius, Pos2D.x - math.sin( math.rad( a + segmentdist ) ) * radius, Pos2D.y + math.cos( math.rad( a + segmentdist ) ) * radius )
		end
	end
end
