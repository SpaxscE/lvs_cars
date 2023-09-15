
ENT.OpticsFirstPerson = true
ENT.OpticsThirdPerson = false
ENT.OpticsEnable = true
ENT.OpticsPodIndex = {
	[1] = true,
}

local axis = Material( "lvs/axis.png" )
local sight = Material( "lvs/shermansights.png" )

function ENT:PaintOptics( Pos2D, Col, PodIndex )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.SetMaterial( axis )
	surface.DrawTexturedRect( Pos2D.x - 8, Pos2D.y - 8, 16, 16 )

	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.SetMaterial( sight )
	surface.DrawTexturedRect( Pos2D.x - 210, Pos2D.y - 23, 420, 420 )

	surface.DrawCircle( Pos2D.x, Pos2D.y, ScrH() * 0.5, Color( 0, 0, 0, 100) )

	if self:GetSelectedWeapon() == 1 then
		self:DrawRotatedText( "MG", Pos2D.x + 30, Pos2D.y + 10, "LVS_FONT_PANEL", Color(0,0,0,220), 0)
	else
		self:DrawRotatedText( self:GetUseHighExplosive() and "HE" or "AP", Pos2D.x + 30, Pos2D.y + 10, "LVS_FONT_PANEL", Color(0,0,0,220), 0)
	end
end
