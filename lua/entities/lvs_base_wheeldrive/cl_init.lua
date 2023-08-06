include("shared.lua")
include("sh_animations.lua")
include("cl_flyby.lua")

function ENT:PreDraw()
	return false
end

function ENT:PreDrawTranslucent()
	return true
end

function ENT:OnChangeGear( oldGear, newGear )
	self:EmitSound( "buttons/lever7.wav", 75, 80, 0.25 )

	self:SuppressViewPunch( self.TransShiftSpeed )
end

function ENT:SuppressViewPunch( time )
	self._viewpunch_supressed_time = CurTime() + (time or 0.2)
end

function ENT:IsViewPunchSuppressed()
	return (self._viewpunch_supressed_time or 0) > CurTime()
end

function ENT:CalcViewPunch( ply, pos, angles, fov, pod )
	local Vel = self:GetVelocity()
	local VelLength = Vel:Length()
	local VelPercentMaxSpeed = math.min( VelLength / 1000, 1 )

	local direction = (90 - self:AngleBetweenNormal( angles:Forward(), Vel:GetNormalized() )) / 90

	local FovValue = math.min( VelPercentMaxSpeed ^ 2 * 100, 15 )

	local Throttle = self:GetThrottle()
	local Brake = self:GetBrake()

	if self:IsViewPunchSuppressed() then
		self._viewpunch_fov = self._viewpunch_fov and self._viewpunch_fov + (-VelPercentMaxSpeed * FovValue - self._viewpunch_fov) * RealFrameTime() or 0
	else
		local newFov =(1 - VelPercentMaxSpeed) * Throttle * FovValue - VelPercentMaxSpeed * Brake * FovValue

		self._viewpunch_fov = self._viewpunch_fov and self._viewpunch_fov + (newFov - self._viewpunch_fov) * RealFrameTime() * 10 or 0
	end

	if pod == self:GetDriverSeat() then
		pos = pos + pod:GetUp() * 7 - pod:GetRight() * 11
	end

	return self._viewpunch_fov * (90 - self:AngleBetweenNormal( angles:Forward(), Vel:GetNormalized() )) / 90
end

function ENT:LVSCalcView( ply, pos, angles, fov, pod )
	if pod == self:GetDriverSeat() then
		pos = pos + pod:GetUp() * 7 - pod:GetRight() * 11
	end

	local fovAdd = self:CalcViewPunch( ply, pos, angles, fov, pod )

	return LVS:CalcView( self, ply, pos, angles,  fov + fovAdd, pod )
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
