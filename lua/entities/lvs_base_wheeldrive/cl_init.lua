include("shared.lua")
include("sh_animations.lua")
include("cl_flyby.lua")

function ENT:PreDraw()
	return false
end

local _curActive
local _oldAttack

local ActiveSkidMarks = {}
local ourMat = Material( "vgui/white" )

local function StartTrail( pos )
	local ID = 1
	for _,_ in ipairs( ActiveSkidMarks ) do
		ID = ID + 1
	end

	PrintChat("start")

	ActiveSkidMarks[ ID ] = {
		active = true,
		startpos = pos,
		delay = CurTime() + 0.1,
		positions = {},
	}

	return ID
end

local function FinishTrail( id )
	if not id then return end

	PrintChat("stop")

	ActiveSkidMarks[ id ].active = false
end

local function RemoveTrail( id )
	if not id then return end

	PrintChat("removed "..id)
	ActiveSkidMarks[ id ] = nil
end

local W = 6

local function Test()
	local ply = LocalPlayer()

	if ply:KeyDown( IN_ATTACK2 ) then
		if #ActiveSkidMarks > 0 then
			table.Empty( ActiveSkidMarks )
			PrintChat("remove")
		end
	end

	local M1 = ply:KeyDown( IN_ATTACK )
	local trace = ply:GetEyeTrace()

	if _oldAttack ~= M1 then
		_oldAttack = M1

		if M1 then
			_curActive = StartTrail( trace.HitPos + Vector(0,0,50) )
		else
			FinishTrail( _curActive )
		end
	end

	if ActiveSkidMarks[ _curActive ] and ActiveSkidMarks[ _curActive ].active then
		if ActiveSkidMarks[ _curActive ].delay < CurTime() then
			PrintChat("get pos")

			ActiveSkidMarks[ _curActive ].delay = CurTime() + 0.05

			local cur = trace.HitPos + Vector(0,0,50)

			local prev = ActiveSkidMarks[ _curActive ].positions[ #ActiveSkidMarks[ _curActive ].positions ]

			if not prev then
				local sub = cur - ActiveSkidMarks[ _curActive ].startpos

				local L = sub:Length() * 0.5
				local C = (cur + ActiveSkidMarks[ _curActive ].startpos) * 0.5

				local Ang = sub:Angle()
				local Forward = Ang:Right()
				local Right = Ang:Forward()

				local p1 = C + Forward * W + Right * L
				local p2 = C - Forward * W + Right * L

				local t1 = util.TraceLine( { start = p1, endpos = p1 - Vector(0,0,100) } )
				local t2 = util.TraceLine( { start = p2, endpos = p2 - Vector(0,0,100) } )

				prev = {
					px = ActiveSkidMarks[ _curActive ].startpos,
					p1 = t1.HitPos + t1.HitNormal,
					p2 = t2.HitPos + t2.HitNormal,
					lifetime = CurTime() + 1.95,
				}
			end

			local sub = cur - prev.px

			local L = sub:Length() * 0.5
			local C = (cur + prev.px) * 0.5

			local Ang = sub:Angle()
			local Forward = Ang:Right()
			local Right = Ang:Forward()

			local p1 = C + Forward * W + Right * L
			local p2 = C - Forward * W + Right * L

			local t1 = util.TraceLine( { start = p1, endpos = p1 - Vector(0,0,100) } )
			local t2 = util.TraceLine( { start = p2, endpos = p2 - Vector(0,0,100) } )

			ActiveSkidMarks[ _curActive ].positions[ #ActiveSkidMarks[ _curActive ].positions + 1 ] = {
				px = cur,
				p1 = t1.HitPos + t1.HitNormal,
				p2 = t2.HitPos + t2.HitNormal,
				lifetime = CurTime() + 2,
			}
		end
	end
end

function ENT:PreDrawTranslucent()
	Test()

	local T = CurTime()
	render.SetMaterial( ourMat )

	for id, skidmark in pairs( ActiveSkidMarks ) do
		local prev
		local AmountDrawn = 0

		for markID, data in pairs( skidmark.positions ) do
			if not prev then

				prev = data

				continue
			end

			local Mul = math.Clamp( data.lifetime - CurTime(), 0, 1 ) ^ 2

			if Mul > 0 then
				AmountDrawn = AmountDrawn + 1
				render.DrawQuad( data.p2, data.p1, prev.p1, prev.p2, Color( 0, 0, 0, 150 * Mul ) )
			end

			--debugoverlay.Line( prev.p1, data.p1, 0.1 )
			--debugoverlay.Line( prev.p2, data.p2, 0.1 )

			prev = data
		end

		if not skidmark.active and AmountDrawn == 0 then
			RemoveTrail( id )
		end
	end

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
