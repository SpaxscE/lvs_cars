LVS:AddHudEditor( "Tach",  ScrW() - 266, ScrH() - 266,  256, 256, 256, 256, "TACH",
	function( self, vehicle, X, Y, W, H, ScrX, ScrY, ply )
		if not vehicle.LVSHudPaintTach then return end

		vehicle:LVSHudPaintTach( X, Y, W, H, ScrX, ScrY, ply )
	end
)

ENT.TachRange = 280
ENT.TachRing = Material( "lvs/tachometer/ring.png" )
ENT.TachTextFont = "LVS_FONT"
ENT.TachTextRadius = 97
ENT.TachPartRadiusInner = 115
ENT.TachTickRadiusInner = 109
ENT.TachTickRadiusOuter = 124

ENT.TachPartColor = Color(200,200,200,255)

ENT.TachGlow = Material("sun/overlay")
ENT.TachGlowColor = Color(5,30,30,255)
ENT.TachGlowColorRedline = Color(50,0,0,255)
ENT.TachGlowRadius = 110

ENT.TachNeedleColor = Color(255,0,0,255)
ENT.TachNeedleRadiusInner = 50
ENT.TachNeedleRadiusOuter = 124
ENT.TachNeedleBlurTime = 0.1
ENT.TachNeedles = {}

local CurRPM = 0

function ENT:LVSHudPaintTach( X, Y, w, h, ScrX, ScrY, ply )
	if ply ~= self:GetDriver() then return end

	if not self:GetRacingHud() then return end

	local Engine = self:GetEngine()

	if not IsValid( Engine ) then return end

	local MaxRPM = self.EngineMaxRPM + 3000

	local Delta = (Engine:GetRPM() - CurRPM) * RealFrameTime() * 20

	CurRPM = CurRPM + Delta

	surface.SetMaterial( self.TachRing )
	surface.SetDrawColor( Color(0,0,0,200) )
	surface.DrawTexturedRect( X - 1,Y - 1,w + 2,h + 2)

	surface.SetDrawColor( color_white )
	surface.DrawTexturedRect( X,Y,w,h)

	local Steps = math.ceil(MaxRPM / 1000)
	local AngleStep = self.TachRange / Steps
	local AngleRedline = (self.TachRange / MaxRPM) * self.EngineMaxRPM

	local CenterX = X + w * 0.5
	local CenterY = Y + h * 0.5

	for i = 0, self.TachRange, 10 do
		local Ang = i + 90

		local AngX = math.cos( math.rad( Ang ) )
		local AngY = math.sin( math.rad( Ang ) )

		local TextX = CenterX + AngX * self.TachGlowRadius
		local TextY = CenterY + AngY * self.TachGlowRadius

		surface.SetMaterial( self.TachGlow )
		if i > AngleRedline then
			surface.SetDrawColor( self.TachGlowColorRedline )
		else
			surface.SetDrawColor( self.TachGlowColor )
		end

		surface.DrawTexturedRectRotated( TextX,TextY,64,64,0)
	end

	surface.SetDrawColor( color_white )

	for i = 0, Steps do
		for n = -1,1, 0.25 do
			local Ang = AngleStep * i + 90 + n

			local AngX = math.cos( math.rad( Ang ) )
			local AngY = math.sin( math.rad( Ang ) )

			local StartX = CenterX + AngX * self.TachTickRadiusInner
			local StartY = CenterY + AngY * self.TachTickRadiusInner

			local EndX = CenterX + AngX * self.TachTickRadiusOuter
			local EndY = CenterY + AngY * self.TachTickRadiusOuter

			surface.DrawLine( StartX, StartY, EndX, EndY )

			if n == 0 then
				local TextX = CenterX + AngX * self.TachTextRadius
				local TextY = CenterY + AngY * self.TachTextRadius

				draw.SimpleText( i, self.TachTextFont, TextX, TextY, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
	end

	surface.SetDrawColor( self.TachPartColor )

	for i = 1, Steps do
		local Start = AngleStep * i + 90

		for n = 1, 9 do
			local Ang = Start - (AngleStep / 10) * n

			local AngX = math.cos( math.rad( Ang ) )
			local AngY = math.sin( math.rad( Ang ) )

			local StartX = CenterX + AngX * self.TachPartRadiusInner
			local StartY = CenterY + AngY * self.TachPartRadiusInner

			local EndX = CenterX + AngX * self.TachTickRadiusOuter
			local EndY = CenterY + AngY * self.TachTickRadiusOuter

			surface.DrawLine( StartX, StartY, EndX, EndY )
		end
	end

	local T = CurTime()

	local Ang = (CurRPM / MaxRPM) * self.TachRange + 90

	local AngX = math.cos( math.rad( Ang ) )
	local AngY = math.sin( math.rad( Ang ) )

	if math.abs( Delta ) > 1 then
		local data = {
			StartX = (CenterX + AngX * self.TachNeedleRadiusInner),
			StartY = (CenterY + AngY * self.TachNeedleRadiusInner),
			EndX = (CenterX + AngX * self.TachNeedleRadiusOuter),
			EndY = (CenterY + AngY * self.TachNeedleRadiusOuter),
			Time = T + self.TachNeedleBlurTime
		}

		table.insert( self.TachNeedles, data )
	else
		local StartX = CenterX + AngX * self.TachNeedleRadiusInner
		local StartY = CenterY + AngY * self.TachNeedleRadiusInner
		local EndX = CenterX + AngX * self.TachNeedleRadiusOuter
		local EndY = CenterY + AngY * self.TachNeedleRadiusOuter

		surface.SetDrawColor( self.TachNeedleColor )
		surface.DrawLine( StartX, StartY, EndX, EndY )
	end

	for index, data in pairs( self.TachNeedles ) do
		if data.Time < T then
			self.TachNeedles[ index ] = nil

			continue
		end

		local Brightness = (data.Time - T) / self.TachNeedleBlurTime

		surface.SetDrawColor( Color( self.TachNeedleColor.r * Brightness, self.TachNeedleColor.g * Brightness, self.TachNeedleColor.b * Brightness, self.TachNeedleColor.a * Brightness ^ 2 ) )
		surface.DrawLine( data.StartX, data.StartY, data.EndX, data.EndY )
	end
end