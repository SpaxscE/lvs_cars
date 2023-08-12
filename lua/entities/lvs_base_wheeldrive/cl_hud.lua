
ENT.IconEngine = Material( "lvs/engine.png" )

function ENT:LVSHudPaintInfoText( X, Y, W, H, ScrX, ScrY, ply )
	local kmh = math.Round(self:GetVelocity():Length() * 0.09144,0)
	draw.DrawText( "km/h ", "LVS_FONT", X + 72, Y + 35, color_white, TEXT_ALIGN_RIGHT )
	draw.DrawText( kmh, "LVS_FONT_HUD_LARGE", X + 72, Y + 20, color_white, TEXT_ALIGN_LEFT )

	if ply ~= self:GetDriver() then return end

	local Throttle = self:GetThrottle()
	local Col = Throttle <= 1 and color_white or Color(0,0,0,255)
	local hX = X + W - H * 0.5
	local hY = Y + H * 0.25 + H * 0.25

	surface.SetMaterial( self.IconEngine )
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawTexturedRectRotated( hX + 4, hY + 1, H * 0.5, H * 0.5, 0 )
	surface.SetDrawColor( color_white )
	surface.DrawTexturedRectRotated( hX + 2, hY - 1, H * 0.5, H * 0.5, 0 )

	if not self:GetEngineActive() then
		draw.SimpleText( "X" , "LVS_FONT",  hX, hY, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	else
		if self:GetReverse() then
			draw.SimpleText( "R" , "LVS_FONT",  hX, hY, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

	self:LVSDrawCircle( hX, hY, H * 0.35, math.min( Throttle, 1 ) )

	if Throttle > 1 then
		draw.SimpleText( "+"..math.Round((Throttle - 1) * 100,0).."%" , "LVS_FONT",  hX, hY, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end

LVS:AddHudEditor( "CarMenu",  ScrW() - 690, ScrH() - 230,  220, 220, 220, 220, "CAR MENU",
	function( self, vehicle, X, Y, W, H, ScrX, ScrY, ply )
		if not vehicle.LVSHudPaintCarMenu then return end
		vehicle:LVSHudPaintCarMenu( X, Y, W, H, ScrX, ScrY, ply )
	end
)

ENT.CarMenuDisable = Material( "lvs/carmenu_cross.png" )
ENT.CarMenuFog = Material( "lvs/carmenu_fog.png" )
ENT.CarMenuHazard = Material( "lvs/carmenu_hazard.png" )
ENT.CarMenuLeft = Material( "lvs/carmenu_turnleft.png" )
ENT.CarMenuRight = Material( "lvs/carmenu_turnRight.png" )

function ENT:LVSHudPaintCarMenu( X, Y, w, h, ScrX, ScrY, ply )
	--if not ply:lvsKeyDown( "CAR_MENU" ) then return end

	local size = 64
	local dist = 0

	local cX = X + w * 0.5
	local cY = Y + h * 0.5

	surface.SetDrawColor( 255, 255, 255, 255 )

	surface.SetMaterial( self.CarMenuDisable )
	surface.DrawTexturedRectRotated( cX, cY, size, size, 0 )

	surface.SetMaterial( self.CarMenuLeft )
	surface.DrawTexturedRectRotated( cX - (size + dist), cY, size, size, 0 )

	surface.SetMaterial( self.CarMenuRight)
	surface.DrawTexturedRectRotated( cX + (size + dist), cY, size, size, 0 )

	surface.SetMaterial( self.CarMenuHazard )
	surface.DrawTexturedRectRotated( cX, cY - (size + dist), size, size, 0 )

	surface.SetMaterial( self.CarMenuFog )
	surface.DrawTexturedRectRotated( cX, cY + (size + dist), size, size, 0 )

	--draw.SimpleText( "test centered" , "LVS_FONT",  X + w * 0.5, Y + h * 0.5, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end
