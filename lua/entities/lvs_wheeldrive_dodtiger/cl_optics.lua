
ENT.OpticsFov = 30
ENT.OpticsEnable = true
ENT.OpticsZoomOnly = true
ENT.OpticsFirstPerson = true
ENT.OpticsThirdPerson = false
ENT.OpticsPodIndex = {
	[1] = true,
}

local OldTargetOffset = 0
local RotationOffset = 0
local circle = Material( "lvs/circle_hollow.png" )
local tri1 = Material( "lvs/triangle1.png" )
local tri2 = Material( "lvs/triangle2.png" )
local pointer = Material( "gui/point.png" )
local scope = Material( "lvs/scope.png" )

function ENT:PaintOptics( Pos2D, Col, PodIndex, Type )
	surface.SetDrawColor( 255, 255, 255, 5 )
	surface.SetMaterial( tri1 )
	surface.DrawTexturedRect( Pos2D.x - 17, Pos2D.y - 1, 32, 32 )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawTexturedRect( Pos2D.x - 16, Pos2D.y, 32, 32 )

	if Type == 1 then
		self:DrawRotatedText( "MG", Pos2D.x + 30, Pos2D.y + 30, "LVS_FONT_PANEL", Color(0,0,0,220), 0)
	else
		self:DrawRotatedText( Type == 3 and "HE" or "AP", Pos2D.x + 30, Pos2D.y + 30, "LVS_FONT_PANEL", Color(0,0,0,220), 0)
	end

	local ScrW = ScrW()
	local ScrH = ScrH()

	for i = -3, 3, 1 do
		if i == 0 then continue end

		surface.SetMaterial( tri2 )
		surface.SetDrawColor( 255, 255, 255, 5 )
		surface.DrawTexturedRect( Pos2D.x - 11 + i * 32, Pos2D.y - 1, 20, 20 )
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawTexturedRect( Pos2D.x - 10 + i * 32, Pos2D.y, 20, 20 )
	end

	surface.SetDrawColor( 0, 0, 0, 200 )

	local TargetOffset = self:GetSelectedWeapon() == 1 and 150 or 0

	if OldTargetOffset ~= TargetOffset then
		OldTargetOffset = TargetOffset
		surface.PlaySound( "lvs/optics.wav" )
	end

	RotationOffset = RotationOffset + (TargetOffset - RotationOffset) * RealFrameTime() * 8

	local R = ScrH * 0.5 - 64
	local R0 = R + 30
	local R1 = R - 8
	local R2 = R - 23
	local R3 = R - 30
	local R4 = R - 18

	for i = 0, 40 do
		local ang = -90 + (180 / 40) * i + RotationOffset

		local x = math.cos( math.rad( ang ) )
		local y = math.sin( math.rad( ang ) )

		if i == 2 then
			self:DrawRotatedText( "8.8", Pos2D.x + x * R0, Pos2D.y + y * R0, "LVS_FONT", Color(0,0,0,200), 90 + ang)
		end
		if i == 3 then
			self:DrawRotatedText( "cm", Pos2D.x + x * R0, Pos2D.y + y * R0, "LVS_FONT", Color(0,0,0,200), 90 + ang)
		end
		if i == 5 then
			self:DrawRotatedText( "Pzgr", Pos2D.x + x * R0, Pos2D.y + y * R0, "LVS_FONT", Color(0,0,0,200), 90 + ang)
		end
	
		surface.SetMaterial( circle )
		surface.DrawTexturedRectRotated( Pos2D.x + x * R, Pos2D.y + y * R, 16, 16, 0 )

		surface.DrawLine( Pos2D.x + x * R1, Pos2D.y + y * R1, Pos2D.x + x * R2, Pos2D.y + y * R2 )

		self:DrawRotatedText( i, Pos2D.x + x * R3, Pos2D.y + y * R3, "LVS_FONT_PANEL", Color(0,0,0,255), ang + 90)

		if i == 40 then continue end

		local ang = - 90 + (180 / 40) * (i + 0.5) + RotationOffset

		local x = math.cos( math.rad( ang ) )
		local y = math.sin( math.rad( ang ) )

		surface.DrawLine( Pos2D.x + x * R1, Pos2D.y + y * R1, Pos2D.x + x * R4, Pos2D.y + y * R4 )
	end

	for i = 0, 13 do
		local ang = 120 + (120 / 13) * i + RotationOffset

		local x = math.cos( math.rad( ang ) )
		local y = math.sin( math.rad( ang ) )

		if i == 1 then
			self:DrawRotatedText( "MG", Pos2D.x + x * R0, Pos2D.y + y * R0, "LVS_FONT", Color(0,0,0,200), 90 + ang)
		end

		surface.SetMaterial( circle )
		surface.DrawTexturedRectRotated( Pos2D.x + x * R, Pos2D.y + y * R, 16, 16, 0 )

		surface.DrawLine( Pos2D.x + x * R1, Pos2D.y + y * R1, Pos2D.x + x * R2, Pos2D.y + y * R2 )

		self:DrawRotatedText( i, Pos2D.x + x * R3, Pos2D.y + y * R3, "LVS_FONT_PANEL", Color(0,0,0,255), ang + 90)
	end

	surface.SetDrawColor( 0, 0, 0, 100 )
	surface.SetMaterial( pointer )
	surface.DrawTexturedRect( Pos2D.x - 16, 0, 32, 64 )

	local Y = Pos2D.y + 64
	local height = ScrH - Y
	surface.DrawRect( Pos2D.x - 2,  Y, 4, height )

	local diameter = ScrH
	local radius = diameter * 0.5

	surface.SetMaterial( scope )
	surface.SetDrawColor( 0, 0, 0, 50 )
	surface.DrawTexturedRect( Pos2D.x - radius, Pos2D.y - radius, diameter, diameter )
end
