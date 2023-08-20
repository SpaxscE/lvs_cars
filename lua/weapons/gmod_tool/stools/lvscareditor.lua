
TOOL.Category		= "LVS"
TOOL.Name			= "#[Car] Editor"
TOOL.Command		= nil
TOOL.ConfigName		= ""

if CLIENT then
	language.Add( "tool.lvscareditor.name", "Car Editor" )
	language.Add( "tool.lvscareditor.desc", "A tool used to edit LVS-Cars" )
	language.Add( "tool.lvscareditor.0", "Left click to cock." )
	language.Add( "tool.lvscareditor.1", "Left click to cock." )

	local SizeX = 400
	local SizeY = 200
	local drawcolor = Color(127,255,0)
	local drawtarget = nil

	net.Receive( "lvs_car_editor", function( len )
		drawtarget = net.ReadEntity()
	end )

	hook.Add( "PreDrawHalos", "!!!!!lvs_car_editor_halo", function()
		if not IsValid( drawtarget ) then return end

		halo.Add( {drawtarget}, drawcolor )
	end )
	
	function TOOL:DrawHUD()
		if not IsValid( drawtarget ) then return end

		if not drawtarget.LVS then return end

		local pos = drawtarget:LocalToWorld( drawtarget:OBBCenter() )
		local pos2D = pos:ToScreen()

		if not pos2D.visible then drawtarget = nil return end

		local X = ScrW() - SizeX - 50
		local Y = 50

		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(X,Y,SizeX,SizeY)

		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawLine( X, Y, X, Y + SizeY )
		surface.DrawLine( X, Y + SizeY, X + SizeX, Y + SizeY )

		local torque = drawtarget.EngineTorque / 5
		local target = drawtarget.MaxVelocity
		local boost = (target / drawtarget.TransGears) * 0.5
		local power = target * drawtarget.EngineCurve

		surface.SetDrawColor( 0, 255, 255, 255 )

		local steps = target / SizeX * 2

		for a = 0, target, steps do
			local curRPM = a
			local nextRPM = a + steps

			local powerCurve1 = (power + math.max( target - power,0) - math.max(curRPM - power,0)) / target
			local powerCurve2 = (power + math.max( target - power,0) - math.max(nextRPM - power,0)) / target

			local TorqueBoost1 = 2 - (math.min( math.max( curRPM - boost, 0 ), boost) / boost)
			local TorqueBoost2 = 2 - (math.min( math.max( nextRPM - boost, 0 ), boost) / boost)

			local X1 = X + (curRPM / target) * SizeX
			local Y1 = Y + SizeY - powerCurve1 * TorqueBoost1 * torque

			local X2 = X + (nextRPM / target) * SizeX
			local Y2 = Y + SizeY - powerCurve2 * TorqueBoost2 * torque

			surface.DrawLine( X1, Y1, X2, Y2 )
		end

		surface.SetDrawColor( 255, 255, 255, 255 )

		draw.SimpleTextOutlined( "1/min", "DermaDefault", X + SizeX + 15, Y + SizeY, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( "torque", "DermaDefault", X, Y - 15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black )
		
		local rpm = drawtarget.EngineMaxRPM
		for a = 0, rpm, 1000 do
			local X1 = X + (a / rpm) * SizeX
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
end

if SERVER then
	util.AddNetworkString( "lvs_car_editor" )
end

function TOOL:LeftClick( trace )
	if CLIENT then return true end

	local target = trace.Entity

	if target and target:IsWorld() then target = nil end

	net.Start( "lvs_car_editor" )
		net.WriteEntity( target )
	net.Send( self:GetOwner() )

	return true
end

function TOOL:RightClick( trace )
	if CLIENT then return true end

	local target = trace.Entity

	if target and target:IsWorld() then target = nil end

	net.Start( "lvs_car_editor" )
		net.WriteEntity( target )
	net.Send( self:GetOwner() )

	return true
end

function TOOL:Reload( trace )
	return false
end
