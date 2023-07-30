include("shared.lua")
include("sh_animations.lua")

ENT.GroundEffectsMultiplier = 1.6

function ENT:LVSCalcView( ply, pos, angles, fov, pod )

	self._smDelta = self._smDelta or 0
	self._smFov = self._smFov or 0

	local FT = RealFrameTime()

	local Vel = self:GetVelocity()
	local NewVel = Vel:Length()

	local VelDelta = NewVel - (self.oldVel or 0)

	self.oldVel = NewVel

	self._smDelta = self._smDelta + (VelDelta - self._smDelta) * FT * 3

	local newFov = math.Clamp(self._smDelta * 10 * math.max( 1 - (NewVel / self.MaxVelocity), 0 ),-15,15)
	newFov = (math.abs( newFov ) / 15) ^ 10 * self:Sign( newFov ) * 15

	self._smFov = self._smFov + (newFov * math.max((90 - self:AngleBetweenNormal( angles:Forward(), Vel:GetNormalized() )) / 90,-0.5) - self._smFov) * FT * 2.5

	if pod == self:GetDriverSeat() then
		pos = pos + pod:GetUp() * 7 - pod:GetRight() * 11
	end

	return LVS:CalcView( self, ply, pos, angles,  fov + self._smFov, pod )
end


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
	end

	self:LVSDrawCircle( hX, hY, H * 0.35, math.min( Throttle, 1 ) )

	if Throttle > 1 then
		draw.SimpleText( "+"..math.Round((Throttle - 1) * 100,0).."%" , "LVS_FONT",  hX, hY, Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end