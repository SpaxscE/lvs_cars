

TOOL.Category		= "LVS"
TOOL.Name			= "#Wheel Changer"

if CLIENT then
	language.Add( "tool.lvscarwheelchanger.name", "[LVS-Car] Wheel Changer" )
	language.Add( "tool.lvscarwheelchanger.desc", "A tool used to edit LVS-Cars" )
	language.Add( "tool.lvscarwheelchanger.0", "Left click to apply Wheel. Left click again to flip 180 degrees. Right click to copy Wheel." )
	language.Add( "tool.lvscarwheelchanger.1", "Left click to apply Wheel. Left click again to flip 180 degrees. Right click to copy Wheel." )
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
	return false
end