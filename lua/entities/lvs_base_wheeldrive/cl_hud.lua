
include("cl_optics.lua")

function ENT:LVSPreHudPaint( X, Y, ply )
	return true
end

local zoom = 0
local zoom_mat = Material( "vgui/zoom" )
local zoom_switch = 0
local zoom_blinder = 0
local TargetZoom = 0

ENT.ZoomInSound = "weapons/sniper/sniper_zoomin.wav"
ENT.ZoomOutSound =  "weapons/sniper/sniper_zoomout.wav"

function ENT:GetZoom()
	return TargetZoom
end

function ENT:PaintZoom( X, Y, ply )
	TargetZoom = ply:lvsKeyDown( "ZOOM" ) and 1 or 0

	zoom = zoom + (TargetZoom - zoom) * RealFrameTime() * 10

	if self.OpticsEnable then
		if self:GetOpticsEnabled() then
			if zoom_switch ~= TargetZoom then
				zoom_switch = TargetZoom

				zoom_blinder = 1

				if TargetZoom == 1 then
					surface.PlaySound( self.ZoomInSound )
				else
					surface.PlaySound( self.ZoomOutSound )
				end
			end

			zoom_blinder = zoom_blinder - zoom_blinder * RealFrameTime() * 5

			surface.SetDrawColor( Color(0,0,0,255 * zoom_blinder) )
			surface.DrawRect( 0, 0, X, Y )

			self.ZoomFov = self.OpticsFov
		else
			self.ZoomFov = nil
		end
	end

	X = X * 0.5
	Y = Y * 0.5

	surface.SetDrawColor( Color(255,255,255,255 * zoom) )
	surface.SetMaterial(zoom_mat ) 
	surface.DrawTexturedRectRotated( X + X * 0.5, Y * 0.5, X, Y, 0 )
	surface.DrawTexturedRectRotated( X + X * 0.5, Y + Y * 0.5, Y, X, 270 )
	surface.DrawTexturedRectRotated( X * 0.5, Y * 0.5, Y, X, 90 )
	surface.DrawTexturedRectRotated( X * 0.5, Y + Y * 0.5, X, Y, 180 )
end

function ENT:LVSHudPaint( X, Y, ply )
	if not self:LVSPreHudPaint( X, Y, ply ) then return end

	self:PaintZoom( X, Y, ply )
end

ENT.IconEngine = Material( "lvs/engine.png" )
ENT.IconFuel = Material( "lvs/fuel.png" )

local WaveScale = 0
local WaveMaterial = Material( "effects/select_ring" )
local oldThrottleActive = false

function ENT:LVSHudPaintInfoText( X, Y, W, H, ScrX, ScrY, ply )
	self:DrawDeveloperInfo()

	local T = CurTime()

	if (self._nextRefreshVel or 0) < T then
		self._nextRefreshVel = T + 0.1
		self._refreshVel = self:GetVelocity():Length()
	end

	local kmh = math.Round( (self._refreshVel or 0) * 0.09144,0)
	draw.DrawText( "km/h ", "LVS_FONT", X + 72, Y + 35, color_white, TEXT_ALIGN_RIGHT )
	draw.DrawText( kmh, "LVS_FONT_HUD_LARGE", X + 72, Y + 20, color_white, TEXT_ALIGN_LEFT )

	if ply ~= self:GetDriver() then return end

	local Throttle = self:GetThrottle()
	local Col = Throttle <= 1 and color_white or Color(0,0,0,255)
	local hX = X + W - H * 0.5
	local hY = Y + H * 0.25 + H * 0.25

	local fueltank = self:GetFuelTank()

	if IsValid( fueltank ) and fueltank:GetFuel() <= 0 then
		surface.SetMaterial( self.IconFuel )
	else
		surface.SetMaterial( self.IconEngine )
	end

	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawTexturedRectRotated( hX + 4, hY + 1, H * 0.5, H * 0.5, 0 )
	surface.SetDrawColor( color_white )
	surface.DrawTexturedRectRotated( hX + 2, hY - 1, H * 0.5, H * 0.5, 0 )

	if not self:GetEngineActive() then
		draw.SimpleText( "X" , "LVS_FONT",  hX, hY, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	else
		if self:GetParkingBrake() then
			local ThrottleActive = Throttle == 0 or Throttle == 1

			if oldThrottleActive ~= ThrottleActive then
				oldThrottleActive = ThrottleActive
				if ThrottleActive then
					WaveScale = 1
				end
			end

			if WaveScale > 0 then
				WaveScale = math.max( WaveScale - RealFrameTime() * 2, 0 )
	
				local WaveRadius = (1 - WaveScale) * H * 1.5

				surface.SetDrawColor( 255, 0, 0, 255 * WaveScale )
				surface.SetMaterial( WaveMaterial )
	
				surface.DrawTexturedRectRotated( hX, hY, WaveRadius, WaveRadius, 0 )

				draw.SimpleText( "P" , "LVS_FONT",  hX, hY, Color(255,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( "P" , "LVS_FONT",  hX, hY, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		else
			oldThrottleActive = false

			if self:GetReverse() then
				draw.SimpleText( "R" , "LVS_FONT",  hX, hY, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
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

	local MenuOpen = ply:lvsKeyDown( "CAR_MENU" ) and self:HasTurnSignals()

	if MenuOpen then
		if ply:lvsKeyDown( "CAR_BRAKE" ) then
			self._SelectedMode = 3
		end
		if ply:lvsKeyDown( "CAR_THROTTLE" ) then
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
	DrawTexturedRect( cX, cY - (size + dist), size, SelectedThing == 0 )

	surface.SetMaterial( self.CarMenuLeft )
	DrawTexturedRect( cX - (size + dist), cY, size, SelectedThing == 1 )

	surface.SetMaterial( self.CarMenuRight)
	DrawTexturedRect( cX + (size + dist), cY, size, SelectedThing == 2 )

	surface.SetMaterial( self.CarMenuHazard )
	DrawTexturedRect( cX, cY, size, SelectedThing == 3 )
end

local smXX = 0
function ENT:DrawDeveloperInfo()
	if not LVS.DeveloperEnabled then return end
	local SizeX = 400
	local SizeY = 200
	local X = ScrW() - SizeX - 100
	local Y = 100

	surface.SetDrawColor(0,0,0,200)
	surface.DrawRect(X,Y,SizeX,SizeY)

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawLine( X, Y, X, Y + SizeY )
	surface.DrawLine( X, Y + SizeY, X + SizeX, Y + SizeY )

	local EngineCurve = self.EngineCurve
	local EngineTorque = self.EngineTorque

	local Turbo = self:GetTurbo()
	if IsValid( Turbo ) then
		EngineCurve = EngineCurve + Turbo:GetEngineCurve()
		EngineTorque = EngineTorque + Turbo:GetEngineTorque()
	end

	local Compressor = self:GetCompressor()
	if IsValid( Compressor ) then
		EngineCurve = EngineCurve + Compressor:GetEngineCurve()
		EngineTorque = EngineTorque + Compressor:GetEngineTorque()
	end

	local torque = EngineTorque / 5
	local target = self.MaxVelocity
	local boost = (target / self.TransGears) * 0.5

	if self:GetReverse() then
		target = self.MaxVelocityReverse
		boost = (target / self.TransGearsReverse) * 0.5
	end

	local power = target * EngineCurve

	surface.SetDrawColor( 0, 255, 255, 255 )

	local steps = target / SizeX * 2

	local BoostMul = math.max( self.EngineCurveBoostLow, 0 )
	local BoostStart = 1 + BoostMul

	if self:GetEngineActive() then
		local throttle = self:GetThrottle()

		for a = 0, target, steps do
			local curRPM = a
			local nextRPM = a + steps

			local powerCurve1 = (power + math.max( target - power,0) - math.max(curRPM - power,0)) / target
			local powerCurve2 = (power + math.max( target - power,0) - math.max(nextRPM - power,0)) / target

			local TorqueBoost1 = BoostStart - (math.min( math.max( curRPM - boost, 0 ), boost) / boost) * BoostMul
			local TorqueBoost2 = BoostStart - (math.min( math.max( nextRPM - boost, 0 ), boost) / boost) * BoostMul

			local X1 = X + (curRPM / target) * SizeX
			local Y1 = Y + SizeY - powerCurve1 * TorqueBoost1 * torque * throttle

			local X2 = X + (nextRPM / target) * SizeX
			local Y2 = Y + SizeY - powerCurve2 * TorqueBoost2 * torque * throttle

			surface.DrawLine( X1, Y1, X2, Y2 )
		end

		smXX = smXX + ((self:GetVelocity():Length() / target) * SizeX - smXX) * RealFrameTime() * 5
		local XX = X + smXX
		surface.SetDrawColor( 255, 0, 0, 255 )
		surface.DrawLine( XX, Y - 10, XX, Y + SizeY + 10 )
	else
		for a = 0, target, steps do
			local curRPM = a
			local nextRPM = a + steps

			local powerCurve1 = (power + math.max( target - power,0) - math.max(curRPM - power,0)) / target
			local powerCurve2 = (power + math.max( target - power,0) - math.max(nextRPM - power,0)) / target

			local TorqueBoost1 = BoostStart - (math.min( math.max( curRPM - boost, 0 ), boost) / boost) * BoostMul
			local TorqueBoost2 = BoostStart - (math.min( math.max( nextRPM - boost, 0 ), boost) / boost) * BoostMul

			local X1 = X + (curRPM / target) * SizeX
			local Y1 = Y + SizeY - powerCurve1 * TorqueBoost1 * torque

			local X2 = X + (nextRPM / target) * SizeX
			local Y2 = Y + SizeY - powerCurve2 * TorqueBoost2 * torque

			surface.DrawLine( X1, Y1, X2, Y2 )
		end
	end

	draw.SimpleTextOutlined( "velocity u/s", "DermaDefault", X + SizeX + 15, Y + SizeY, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, color_black )
	draw.SimpleTextOutlined( self:GetReverse() and "torque@wheel [reverse]" or "torque@wheel", "DermaDefault", X, Y - 15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black )

	surface.SetDrawColor( 255, 255, 255, 255 )

	for a = 0, target, 250 do
		local X1 = X + (a / target) * SizeX
		local Y1 = Y + SizeY

		surface.DrawLine( X1, Y1 + 5, X1, Y1 - 5 )

		draw.SimpleTextOutlined( a, "DermaDefault", X1, Y1 + 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black )
	end

	for a = 0, SizeY, 20 do
		local X1 = X
		local Y1 = Y + SizeY - a

		surface.DrawLine( X1 - 5, Y1, X1 + 5, Y1 )

		draw.SimpleTextOutlined( a * 5, "DermaDefault", X1 - 10, Y1, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, color_black )
	end
end
