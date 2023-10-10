
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
local scope = Material( "lvs/scope.png" )

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

	local diameter = ScrH()
	local radius = diameter * 0.5

	surface.SetMaterial( scope )
	surface.SetDrawColor( 0, 0, 0, 50 )
	surface.DrawTexturedRect( Pos2D.x - radius, Pos2D.y - radius, diameter, diameter )
end
