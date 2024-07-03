LVS:AddHudEditor( "Speedo",  ScrW() * 0.5 - 300 - 25, ScrH() - 240,  300, 220, 300, 220, "SPEEDO",
	function( self, vehicle, X, Y, W, H, ScrX, ScrY, ply )
		if not vehicle.LVSHudPaintSpeedo then return end

		vehicle:LVSHudPaintSpeedo( X, Y, W, H, ScrX, ScrY, ply )
	end
)

LVS:AddHudEditor( "Tach",  ScrW() * 0.5 + 25, ScrH() - 240,  300, 220, 300, 220, "TACH",
	function( self, vehicle, X, Y, W, H, ScrX, ScrY, ply )
		if not vehicle.LVSHudPaintTach then return end

		vehicle:LVSHudPaintTach( X, Y, W, H, ScrX, ScrY, ply )
	end
)

local THE_FONT = {
	font = "Verdana",
	extended = false,
	size = 100,
	weight = 2000,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
}
surface.CreateFont( "LVS_TACHOMETER", THE_FONT )

THE_FONT.size = 50
surface.CreateFont( "LVS_SPEEDOMETER", THE_FONT )

local circles = include("includes/circles/circles.lua")

local Center = 650

local startAngleSpeedo = 180
local endAngleSpeedo = 375

local startAngleTach = 165
local endAngleTach = 360

local RingOuter = circles.New( CIRCLE_OUTLINED, 645, 0, 0, 35 )
RingOuter:SetX( Center )
RingOuter:SetY( Center )
RingOuter:SetMaterial( true )

local RingInner = circles.New( CIRCLE_OUTLINED, 640, 0, 0, 25 )
RingInner:SetX( Center )
RingInner:SetY( Center )
RingInner:SetMaterial( true )

local RingOuterRedline = circles.New( CIRCLE_OUTLINED, 645, 0, 0, 20 )
RingOuterRedline:SetX( Center )
RingOuterRedline:SetY( Center )
RingOuterRedline:SetMaterial( true )

local RingInnerRedline = circles.New( CIRCLE_OUTLINED, 640, 0, 0, 10 )
RingInnerRedline:SetX( Center )
RingInnerRedline:SetY( Center )
RingInnerRedline:SetMaterial( true )

local VehicleSpeedo = {}
local VehicleTach = {}

function ENT:GetBakedSpeedoMaterial( MaxSpeed )
	local Class = self:GetClass()

	if VehicleSpeedo[ Class ] then return VehicleSpeedo[ Class ] end

	local SpeedoRange = endAngleSpeedo - startAngleSpeedo

	local Steps = math.ceil( MaxSpeed / 15 ) + 2
	local AngleStep = SpeedoRange / Steps

	local speedoRT = GetRenderTarget( "lvs_speedo_"..Class, Center * 2, Center * 2 )

	local old = DisableClipping( true )

	render.OverrideAlphaWriteEnable( true, true )

	render.PushRenderTarget( speedoRT )

	cam.Start2D()
		render.ClearDepth()
		render.Clear( 0, 0, 0, 0 )

		surface.SetDrawColor( Color( 0, 0, 0, 200 ) )

		RingOuter:SetStartAngle( startAngleSpeedo )
		RingOuter:SetEndAngle( endAngleSpeedo )
		RingOuter()

		surface.SetDrawColor( color_white )

		for i = 0, Steps do
			local Ang = AngleStep * i + startAngleSpeedo

			local AngX = math.cos( math.rad( Ang ) )
			local AngY = math.sin( math.rad( Ang ) )

			local StartX = Center + AngX * 554
			local StartY = Center + AngY * 554

			local EndX = Center + AngX * 635
			local EndY = Center + AngY * 635


			draw.NoTexture()
			surface.DrawTexturedRectRotated( (StartX + EndX) * 0.5, (StartY + EndY) * 0.5, 90, 15, -Ang )

			local TextX = Center - 3 + AngX * 500
			local TextY = Center + AngY * 515

			draw.SimpleText( i * 15, "LVS_SPEEDOMETER", TextX, TextY, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		for i = 1, Steps do
			local Start = AngleStep * i + startAngleSpeedo

			for n = 1, 5 do
				local Ang = Start - (AngleStep / 6) * n

				surface.SetDrawColor( Color(150,150,150,255) )

				local AngX = math.cos( math.rad( Ang ) )
				local AngY = math.sin( math.rad( Ang ) )

				local StartX = Center + AngX * 575
				local StartY = Center + AngY * 575

				local EndX = Center + AngX * 635
				local EndY = Center + AngY * 635

				draw.NoTexture()
				surface.DrawTexturedRectRotated( (StartX + EndX) * 0.5, (StartY + EndY) * 0.5, 60, 5, -Ang )
			end
		end

		surface.SetDrawColor( color_white )

		RingInner:SetStartAngle( startAngleSpeedo )
		RingInner:SetEndAngle( endAngleSpeedo )
		RingInner()
	cam.End2D()

	render.OverrideAlphaWriteEnable( false )

	render.PopRenderTarget()

	local Mat = CreateMaterial( "lvs_speedo_"..Class.."_mat", "UnlitGeneric", { ["$basetexture"] = speedoRT:GetName(), ["$translucent"] = 1, ["$vertexcolor"] = 1 } )

	VehicleSpeedo[ Class ] = Mat

	DisableClipping( old )

	return Mat
end

function ENT:GetBakedTachMaterial( MaxRPM )
	local Class = self:GetClass()

	if VehicleTach[ Class ] then return VehicleTach[ Class ] end

	local TachRange = endAngleTach - startAngleTach

	local Steps = math.ceil(MaxRPM / 1000)
	local AngleStep = TachRange / Steps
	local AngleRedline = startAngleTach + (TachRange / MaxRPM) * self.EngineMaxRPM

	local tachRT = GetRenderTarget( "lvs_tach_"..Class, Center * 2, Center * 2 )

	local old = DisableClipping( true )

	render.OverrideAlphaWriteEnable( true, true )

	render.PushRenderTarget( tachRT )

	cam.Start2D()
		render.ClearDepth()
		render.Clear( 0, 0, 0, 0 )

		surface.SetDrawColor( Color( 0, 0, 0, 200 ) )

		RingOuter:SetStartAngle( startAngleTach )
		RingOuter:SetEndAngle( AngleRedline )
		RingOuter()

		RingOuterRedline:SetStartAngle( AngleRedline )
		RingOuterRedline:SetEndAngle( endAngleTach )
		RingOuterRedline()

		surface.SetDrawColor( color_white )

		for i = 0, Steps do
			local Ang = AngleStep * i + startAngleTach

			local AngX = math.cos( math.rad( Ang ) )
			local AngY = math.sin( math.rad( Ang ) )

			local StartX = Center + AngX * 554
			local StartY = Center + AngY * 554

			local EndX = Center + AngX * 635
			local EndY = Center + AngY * 635

			if Ang > AngleRedline then
				surface.SetDrawColor( Color(255,0,0,255) )
			else
				surface.SetDrawColor( color_white )
			end

			draw.NoTexture()
			surface.DrawTexturedRectRotated( (StartX + EndX) * 0.5, (StartY + EndY) * 0.5, 90, 15, -Ang )

			local TextX = Center + AngX * 485
			local TextY = Center + AngY * 485

			if Ang > AngleRedline then
				draw.SimpleText( i, "LVS_TACHOMETER", TextX, TextY, Color(255,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( i, "LVS_TACHOMETER", TextX, TextY, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end

		for i = 1, Steps do
			local Start = AngleStep * i + startAngleTach

			for n = 1, 9 do
				local Ang = Start - (AngleStep / 10) * n

				if Ang > AngleRedline then
					surface.SetDrawColor( Color(150,0,0,255) )
				else
					surface.SetDrawColor( Color(150,150,150,255) )
				end

				local AngX = math.cos( math.rad( Ang ) )
				local AngY = math.sin( math.rad( Ang ) )

				local StartX = Center + AngX * 575
				local StartY = Center + AngY * 575

				local EndX = Center + AngX * 635
				local EndY = Center + AngY * 635

				draw.NoTexture()
				surface.DrawTexturedRectRotated( (StartX + EndX) * 0.5, (StartY + EndY) * 0.5, 60, 5, -Ang )
			end
		end

		surface.SetDrawColor( color_white )

		RingInner:SetStartAngle( startAngleTach )
		RingInner:SetEndAngle( AngleRedline )
		RingInner()

		surface.SetDrawColor( Color(255,0,0,255) )

		RingInnerRedline:SetStartAngle( AngleRedline )
		RingInnerRedline:SetEndAngle( endAngleTach )
		RingInnerRedline()

	cam.End2D()

	render.OverrideAlphaWriteEnable( false )

	render.PopRenderTarget()

	local Mat = CreateMaterial( "lvs_tach_"..Class.."_mat", "UnlitGeneric", { ["$basetexture"] = tachRT:GetName(), ["$translucent"] = 1, ["$vertexcolor"] = 1 } )

	VehicleTach[ Class ] = Mat

	DisableClipping( old )

	return Mat
end

local TachNeedleColor = Color(255,0,0,255)
local TachNeedleRadiusInner = 15
local TachNeedleRadiusOuter = 130
local TachNeedleBlurTime = 0.1
local TachNeedles = {}
local CurRPM = 0
local CurSpeed = 0

function ENT:LVSHudPaintSpeedo( X, Y, w, h, ScrX, ScrY, ply )
	if ply ~= self:GetDriver() then return end

	if not self:GetRacingHud() then return end

	local Delta = (self:GetVelocity():Length() * 0.09144 - CurSpeed) * RealFrameTime()

	if Delta > 0 then
		Delta = Delta * (self:IsViewPunchSuppressed() and 3 or 20)
	else
		Delta = Delta * 20
	end

	CurSpeed = CurSpeed + Delta

	local MaxSpeed = math.ceil( math.max( self.MaxVelocity, self.MaxVelocityReverse ) * 0.09144,0)

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( self:GetBakedSpeedoMaterial( MaxSpeed ) )
	surface.DrawTexturedRect( X, Y, w, w )

	local CenterX = X + w * 0.5
	local CenterY = Y + w * 0.5

	local T = CurTime()

	local Ang = startAngleSpeedo + (endAngleSpeedo - startAngleSpeedo) * (CurSpeed / MaxSpeed)

	local AngX = math.cos( math.rad( Ang ) )
	local AngY = math.sin( math.rad( Ang ) )

	if math.abs( Delta ) > 0 then
		local data = {
			StartX = (CenterX + AngX * TachNeedleRadiusInner),
			StartY = (CenterY + AngY * TachNeedleRadiusInner),
			EndX = (CenterX + AngX * TachNeedleRadiusOuter),
			EndY = (CenterY + AngY * TachNeedleRadiusOuter),
			Time = T + TachNeedleBlurTime
		}

		table.insert( TachNeedles, data )
	else
		local StartX = CenterX + AngX * TachNeedleRadiusInner
		local StartY = CenterY + AngY * TachNeedleRadiusInner
		local EndX = CenterX + AngX * TachNeedleRadiusOuter
		local EndY = CenterY + AngY * TachNeedleRadiusOuter

		surface.SetDrawColor( TachNeedleColor )
		surface.DrawLine( StartX, StartY, EndX, EndY )
	end

	for index, data in pairs( TachNeedles ) do
		if data.Time < T then
			TachNeedles[ index ] = nil

			continue
		end

		local Brightness = (data.Time - T) / TachNeedleBlurTime

		surface.SetDrawColor( Color( TachNeedleColor.r * Brightness, TachNeedleColor.g * Brightness, TachNeedleColor.b * Brightness, TachNeedleColor.a * Brightness ^ 2 ) )
		surface.DrawLine( data.StartX, data.StartY, data.EndX, data.EndY )
	end
end

function ENT:LVSHudPaintTach( X, Y, w, h, ScrX, ScrY, ply )
	if ply ~= self:GetDriver() then return end

	if not self:GetRacingHud() then return end

	local Engine = self:GetEngine()

	if not IsValid( Engine ) then return end

	local Delta = (Engine:GetRPM() - CurRPM) * RealFrameTime() * 20

	CurRPM = CurRPM + Delta

	local MaxRPM = self.EngineMaxRPM + 3000

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( self:GetBakedTachMaterial( MaxRPM ) )
	surface.DrawTexturedRect( X, Y, w, w )

	local CenterX = X + w * 0.5
	local CenterY = Y + w * 0.5

	local T = CurTime()

	local Ang = startAngleTach + (endAngleTach - startAngleTach) * (CurRPM / MaxRPM)

	local AngX = math.cos( math.rad( Ang ) )
	local AngY = math.sin( math.rad( Ang ) )

	if math.abs( Delta ) > 1 then
		local data = {
			StartX = (CenterX + AngX * TachNeedleRadiusInner),
			StartY = (CenterY + AngY * TachNeedleRadiusInner),
			EndX = (CenterX + AngX * TachNeedleRadiusOuter),
			EndY = (CenterY + AngY * TachNeedleRadiusOuter),
			Time = T + TachNeedleBlurTime
		}

		table.insert( TachNeedles, data )
	else
		local StartX = CenterX + AngX * TachNeedleRadiusInner
		local StartY = CenterY + AngY * TachNeedleRadiusInner
		local EndX = CenterX + AngX * TachNeedleRadiusOuter
		local EndY = CenterY + AngY * TachNeedleRadiusOuter

		surface.SetDrawColor( TachNeedleColor )
		surface.DrawLine( StartX, StartY, EndX, EndY )
	end

	for index, data in pairs( TachNeedles ) do
		if data.Time < T then
			TachNeedles[ index ] = nil

			continue
		end

		local Brightness = (data.Time - T) / TachNeedleBlurTime

		surface.SetDrawColor( Color( TachNeedleColor.r * Brightness, TachNeedleColor.g * Brightness, TachNeedleColor.b * Brightness, TachNeedleColor.a * Brightness ^ 2 ) )
		surface.DrawLine( data.StartX, data.StartY, data.EndX, data.EndY )
	end
end
