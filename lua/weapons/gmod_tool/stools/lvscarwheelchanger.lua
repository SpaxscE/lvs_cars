

TOOL.Category		= "LVS"
TOOL.Name			= "#Wheel Changer"

if CLIENT then
	language.Add( "tool.lvscarwheelchanger.name", "[LVS-Car] Wheel Changer" )
	language.Add( "tool.lvscarwheelchanger.desc", "A tool used to edit LVS-Cars" )
	language.Add( "tool.lvscarwheelchanger.0", "Left click to apply Wheel. Right click to copy Wheel." )
	language.Add( "tool.lvscarwheelchanger.1", "Left click to apply Wheel. Right click to copy Wheel." )
end

function TOOL:LeftClick( trace )
	if CLIENT then return true end

	return true
end

function TOOL:RightClick( trace )
	if CLIENT then return true end

	return true
end

function TOOL:Reload( trace )
	return false
end