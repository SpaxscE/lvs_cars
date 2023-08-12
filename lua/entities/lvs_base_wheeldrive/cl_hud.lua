
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

LVS:AddHudEditor( "CarMenu",  ScrW() - 690, ScrH() - 85,  220, 75, 220, 75, "CAR MENU",
	function( self, vehicle, X, Y, W, H, ScrX, ScrY, ply )
		if not vehicle.LVSHudPaintCarMenu then return end
		vehicle:LVSHudPaintCarMenu( X, Y, W, H, ScrX, ScrY, ply )
	end
)
local function DrawTexturedRect( X, Y, size, selected )
	local oz = 2

	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.DrawTexturedRectRotated( X + oz, Y + oz, size, size, 0 )

	if IsColor( selected ) then
		surface.SetDrawColor( selected.r, selected.g, selected.b, selected.a )
	else
		if selected then
			surface.SetDrawColor( 255, 255, 255, 255 )
		else
			surface.SetDrawColor( 150, 150, 150, 150 )
		end
	end

	surface.DrawTexturedRectRotated( X, Y, size, size, 0 )
end

ENT.CarMenuHighbeam = Material( "lvs/carmenu_highbeam.png" )
ENT.CarMenuLowbeam = Material( "lvs/carmenu_lowbeam.png" )
ENT.CarMenuDisable = Material( "lvs/carmenu_cross.png" )
ENT.CarMenuFog = Material( "lvs/carmenu_fog.png" )
ENT.CarMenuHazard = Material( "lvs/carmenu_hazard.png" )
ENT.CarMenuLeft = Material( "lvs/carmenu_turnleft.png" )
ENT.CarMenuRight = Material( "lvs/carmenu_turnRight.png" )

function ENT:LVSHudPaintCarMenu( X, Y, w, h, ScrX, ScrY, ply )
	if self:GetDriver() ~= ply then return end

	local MenuOpen = ply:lvsKeyDown( "CAR_MENU" )

	if MenuOpen then
		if ply:lvsKeyDown( "CAR_THROTTLE" ) then
			self._SelectedMode = 3
		end
		if ply:lvsKeyDown( "CAR_BRAKE" ) then
			self._SelectedMode = 0
		end
		if ply:lvsKeyDown( "CAR_STEER_LEFT" ) then
			self._SelectedMode = 1
		end
		if ply:lvsKeyDown( "CAR_STEER_RIGHT" ) then
			self._SelectedMode = 2
		end

		if self._oldSelectedMode ~= self._SelectedMode then
			self._oldSelectedMode = self._SelectedMode

			self:EmitSound("buttons/lightswitch2.wav",75,120,0.25)
		end
	else
		if self._oldSelectedMode and isnumber( self._SelectedMode ) then
			self:EmitSound("buttons/lightswitch2.wav",75,100,0.25)

			net.Start( "lvs_car_turnsignal" )
				net.WriteInt( self._SelectedMode, 4 )
			net.SendToServer()

			self._SelectedMode = 0
			self._oldSelectedMode = nil
		end

		local size = 32
		local dist = 5

		local cX = X + w * 0.5
		local cY = Y + h - size * 0.5 - dist

		local LightsHandler = self:GetLightsHandler()

		if IsValid( LightsHandler ) then
			if LightsHandler:GetActive() then
				if LightsHandler:GetHighActive() then
					surface.SetMaterial( self.CarMenuHighbeam )
					DrawTexturedRect( cX, cY, size, Color(0,255,255,255) )
				else
					surface.SetMaterial( self.CarMenuLowbeam )
					DrawTexturedRect( cX, cY, size, Color(0,255,0,255) )
				end
			end

			if LightsHandler:GetFogActive() then
				surface.SetMaterial( self.CarMenuFog )
				DrawTexturedRect( cX, cY - (size + dist), size, Color(255,100,0,255) )
			end
		end

		local TurnMode = self:GetTurnMode()

		if TurnMode == 0 then return end

		local Alpha = self:GetTurnFlasher() and 255 or 0

		if TurnMode == 1 or TurnMode == 3 then
			surface.SetMaterial( self.CarMenuLeft )
			DrawTexturedRect( cX - (size + dist), cY, size, Color(0,255,157,Alpha) )
		end

		if TurnMode == 2 or TurnMode == 3 then
			surface.SetMaterial( self.CarMenuRight )
			DrawTexturedRect( cX + (size + dist), cY, size, Color(0,255,157,Alpha) )
		end

		return
	end

	local SelectedThing = self._SelectedMode or 0

	local size = 32
	local dist = 5

	local cX = X + w * 0.5
	local cY = Y + h - size * 0.5 - dist

	surface.SetMaterial( self.CarMenuDisable )
	DrawTexturedRect( cX, cY, size, SelectedThing == 0 )

	surface.SetMaterial( self.CarMenuLeft )
	DrawTexturedRect( cX - (size + dist), cY, size, SelectedThing == 1 )

	surface.SetMaterial( self.CarMenuRight)
	DrawTexturedRect( cX + (size + dist), cY, size, SelectedThing == 2 )

	surface.SetMaterial( self.CarMenuHazard )
	DrawTexturedRect( cX, cY - (size + dist), size, SelectedThing == 3 )
end
