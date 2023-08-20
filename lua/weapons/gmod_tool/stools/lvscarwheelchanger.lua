

TOOL.Category		= "LVS"
TOOL.Name			= "#Wheel Changer"

TOOL.ClientConVar[ "camber" ] = 0
TOOL.ClientConVar[ "caster" ] = 0
TOOL.ClientConVar[ "toe" ] = 0

if CLIENT then
	language.Add( "tool.lvscarwheelchanger.name", "[LVS-Car] Wheel Changer" )
	language.Add( "tool.lvscarwheelchanger.desc", "A tool used to edit LVS-Car Wheels" )
	language.Add( "tool.lvscarwheelchanger.0", "Left click to apply Wheel. Left click again to flip 180 degrees. Right click to copy Wheel. Reload to apply Camber/Caster/Toe settings" )
	language.Add( "tool.lvscarwheelchanger.1", "Left click to apply Wheel. Left click again to flip 180 degrees. Right click to copy Wheel. Reload to apply Camber/Caster/Toe settings" )

	local ConVarsDefault = TOOL:BuildConVarList()
	function TOOL.BuildCPanel( panel )
		panel:AddControl( "Header", { Text = "#tool.lvscarwheelchanger.name", Description = "#tool.lvscarwheelchanger.desc" } )
		panel:AddControl( "ComboBox", { MenuButton = 1, Folder = "lvswheels", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

		panel:AddControl("Slider", { Label = "Camber", Type = "float", Min = "-15", Max = "15", Command = "lvscarwheelchanger_camber" } )
		panel:AddControl("Slider", { Label = "Caster", Type = "float", Min = "-15", Max = "15", Command = "lvscarwheelchanger_caster" } )
		panel:AddControl("Slider", { Label = "Toe", Type = "float", Min = "-30", Max = "30", Command = "lvscarwheelchanger_toe" } )
	end

end

function TOOL:IsValidTarget( ent )
	if not IsValid( ent ) then return false end

	local class = ent:GetClass()

	return class == "lvs_wheeldrive_wheel"
end

function TOOL:GetData( ent )
	if CLIENT then return end

	self.radius = ent:GetRadius() * (1 / ent:GetModelScale())
	self.ang = ent:GetAlignmentAngle()
	self.mdl = ent:GetModel()
end

function TOOL:SetData( ent )
	if CLIENT then return end

	if not isstring( self.mdl ) or not isangle( self.ang ) or not isnumber( self.radius ) then return end

	if ent:GetModel() == self.mdl then
		local Ang = ent:GetAlignmentAngle()
		Ang:RotateAroundAxis( Vector(0,0,1), 180 )

		ent:SetAlignmentAngle( Ang )
	else
		ent:SetModel( self.mdl )
		ent:SetAlignmentAngle( self.ang )

		timer.Simple(0.05, function()
			if not IsValid( ent ) then return end

			ent:SetModelScale( ent:GetRadius() / self.radius )
		end )
	end
end

function TOOL:LeftClick( trace )
	if not self:IsValidTarget( trace.Entity ) then return false end

	self:SetData( trace.Entity )

	return true
end

function TOOL:RightClick( trace )
	if not self:IsValidTarget( trace.Entity ) then return false end

	self:GetData( trace.Entity )

	return true
end

function TOOL:Reload( trace )
	local ent = trace.Entity

	if not self:IsValidTarget( ent ) then return false end

	ent:SetCamber( self:GetClientInfo("camber") )
	ent:SetCaster( self:GetClientInfo("caster") )
	ent:SetToe( self:GetClientInfo("toe") )

	return true
end