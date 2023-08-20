
TOOL.Category		= "LVS"
TOOL.Name			= "#Car Editor"
TOOL.Command		= nil
TOOL.ConfigName		= ""

if CLIENT then
	language.Add( "tool.lvscareditor.name", "Car Editor" )
	language.Add( "tool.lvscareditor.desc", "A tool used to edit LVS-Cars" )
	language.Add( "tool.lvscareditor.0", "Left click to cock." )
	language.Add( "tool.lvscareditor.1", "Left click to cock." )
end

function TOOL:LeftClick( trace )
	return true
end

function TOOL:RightClick( trace )
	return true
end

function TOOL:Reload( trace )
	return false
end
