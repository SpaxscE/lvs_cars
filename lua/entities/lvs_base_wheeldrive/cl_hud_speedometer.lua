LVS:AddHudEditor( "Tach",  ScrW() - 266, ScrH() - 266,  256, 256, 256, 256, "TACH",
	function( self, vehicle, X, Y, W, H, ScrX, ScrY, ply )
		if not vehicle.LVSHudPaintTach then return end

		vehicle:LVSHudPaintTach( X, Y, W, H, ScrX, ScrY, ply )
	end
)

local circles = include("includes/circles/circles.lua")

local Center = 130

local startAngle = 165
local endAngle = 360
local offsetAngle = 1.4

local RingOuter = circles.New( CIRCLE_OUTLINED, 129, 0, 0, 7 )
RingOuter:SetX( Center )
RingOuter:SetY( Center )
RingOuter:SetMaterial( true )

local RingInner = circles.New( CIRCLE_OUTLINED, 128, 0, 0, 5 )
RingInner:SetX( Center )
RingInner:SetY( Center )
RingInner:SetMaterial( true )

local RingOuterRedline = circles.New( CIRCLE_OUTLINED, 129, 0, 0, 4 )
RingOuterRedline:SetX( Center )
RingOuterRedline:SetY( Center )
RingOuterRedline:SetMaterial( true )

local RingInnerRedline = circles.New( CIRCLE_OUTLINED, 128, 0, 0, 2 )
RingInnerRedline:SetX( Center )
RingInnerRedline:SetY( Center )
RingInnerRedline:SetMaterial( true )

local VehicleTach = {}

function ENT:GetBakedTachMaterial()
	local Class = self:GetClass()

	if VehicleTach[ Class ] then return VehicleTach[ Class ] end

	local MaxRPM = self.EngineMaxRPM + 3000

	local TachRange = endAngle - startAngle

	local Steps = math.ceil(MaxRPM / 1000)
	local AngleStep = TachRange / Steps
	local AngleRedline = startAngle + (TachRange / MaxRPM) * self.EngineMaxRPM

	local tachRT = GetRenderTarget( "lvs_tach_"..Class, Center * 2, Center * 2 )

	local old = DisableClipping( true )

	render.OverrideAlphaWriteEnable( true, true )

	render.PushRenderTarget( tachRT )

	cam.Start2D()
		render.ClearDepth()
		render.Clear( 0, 0, 0, 0 )

		surface.SetDrawColor( Color( 0, 0, 0, 200 ) )

		RingOuter:SetStartAngle( startAngle - offsetAngle )
		RingOuter:SetEndAngle( AngleRedline )
		RingOuter()

		RingOuterRedline:SetStartAngle( AngleRedline )
		RingOuterRedline:SetEndAngle( endAngle + offsetAngle )
		RingOuterRedline()

		surface.SetDrawColor( color_white )

		for i = 0, Steps do
			for n = -1,1, 0.25 do
				local Ang = AngleStep * i + startAngle + n

				local AngX = math.cos( math.rad( Ang ) )
				local AngY = math.sin( math.rad( Ang ) )

				local StartX = Center + AngX * 109
				local StartY = Center + AngY * 109

				local EndX = Center + AngX * 127
				local EndY = Center + AngY * 127

				if Ang > AngleRedline then
					surface.SetDrawColor( Color(255,0,0,255) )
				else
					surface.SetDrawColor( color_white )
				end

				surface.DrawLine( StartX, StartY, EndX, EndY )

				if n == 0 then
					local TextX = Center + AngX * 97
					local TextY = Center + AngY * 97

					if Ang > AngleRedline then
						draw.SimpleText( i, "LVS_FONT", TextX, TextY, Color(255,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					else
						draw.SimpleText( i, "LVS_FONT", TextX, TextY, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
				end
			end
		end

		for i = 1, Steps do
			local Start = AngleStep * i + startAngle

			for n = 1, 9 do
				local Ang = Start - (AngleStep / 10) * n

				if Ang > AngleRedline then
					surface.SetDrawColor( Color(150,0,0,255) )
				else
					surface.SetDrawColor( Color(150,150,150,255) )
				end

				local AngX = math.cos( math.rad( Ang ) )
				local AngY = math.sin( math.rad( Ang ) )

				local StartX = Center + AngX * 115
				local StartY = Center + AngY * 115

				local EndX = Center + AngX * 127
				local EndY = Center + AngY * 127

				surface.DrawLine( StartX, StartY, EndX, EndY )
			end
		end

		surface.SetDrawColor( color_white )

		RingInner:SetStartAngle( startAngle - offsetAngle )
		RingInner:SetEndAngle( AngleRedline )
		RingInner()

		surface.SetDrawColor( Color(255,0,0,255) )

		RingInnerRedline:SetStartAngle( AngleRedline )
		RingInnerRedline:SetEndAngle( endAngle + offsetAngle )
		RingInnerRedline()

	cam.End2D()

	render.OverrideAlphaWriteEnable( false )

	render.PopRenderTarget()

	local Mat = CreateMaterial( "lvs_tach_"..Class.."_mat", "UnlitGeneric", { ["$basetexture"] = tachRT:GetName(), ["$translucent"] = 1, ["$vertexcolor"] = 1 } )

	VehicleTach[ Class ] = Mat

	DisableClipping( old )

	return Mat
end

function ENT:LVSHudPaintTach( X, Y, w, h, ScrX, ScrY, ply )
	if ply ~= self:GetDriver() then return end

	if not self:GetRacingHud() then return end

	local Engine = self:GetEngine()

	if not IsValid( Engine ) then return end

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( self:GetBakedTachMaterial() )
	surface.DrawTexturedRect( X, Y, w, h )
end
