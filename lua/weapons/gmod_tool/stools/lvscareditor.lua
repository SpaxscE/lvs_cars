
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

		if not pos2D.visible then return end
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
