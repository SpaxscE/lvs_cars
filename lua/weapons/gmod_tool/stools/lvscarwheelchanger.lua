

TOOL.Category		= "LVS"
TOOL.Name			= "#Wheel Editor"

TOOL.ClientConVar[ "model" ] = ""
TOOL.ClientConVar[ "camber" ] = 0
TOOL.ClientConVar[ "caster" ] = 0
TOOL.ClientConVar[ "toe" ] = 0

TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
	{ name = "reload" }
}

if CLIENT then
	language.Add( "tool.lvscarwheelchanger.name", "Wheel Editor" )
	language.Add( "tool.lvscarwheelchanger.desc", "A tool used to edit [LVS-Cars] Wheels" )
	language.Add( "tool.lvscarwheelchanger.left", "Apply wheel. Click again to flip 180 degrees" )
	language.Add( "tool.lvscarwheelchanger.right", "Copy wheel" )
	language.Add( "tool.lvscarwheelchanger.reload", "Apply camber/caster/toe settings" )

	local ConVarsDefault = TOOL:BuildConVarList()
	function TOOL.BuildCPanel( panel )
		panel:AddControl( "Header", { Text = "#tool.lvscarwheelchanger.name", Description = "#tool.lvscarwheelchanger.desc" } )
		panel:AddControl( "ComboBox", { MenuButton = 1, Folder = "lvswheels", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

		panel:AddControl("Slider", { Label = "Camber", Type = "float", Min = "-15", Max = "15", Command = "lvscarwheelchanger_camber" } )
		panel:AddControl("Slider", { Label = "Caster", Type = "float", Min = "-15", Max = "15", Command = "lvscarwheelchanger_caster" } )
		panel:AddControl("Slider", { Label = "Toe", Type = "float", Min = "-30", Max = "30", Command = "lvscarwheelchanger_toe" } )

		-- purpose: avoid bullshit concommand system and avoid players abusing it
		for mdl, _ in pairs( list.Get( "lvs_wheels" ) or {} ) do
			list.Set( "lvs_wheels_selection", mdl, {} )
		end
		panel:AddControl( "Label",  { Text = "" } )
		panel:AddControl( "Label",  { Text = "Wheel Models" } )
		panel:AddControl( "PropSelect", { Label = "", ConVar = "lvscarwheelchanger_model", Height = 0, Models = list.Get( "lvs_wheels_selection" ) } )
	end

end

local function DuplicatorSaveCarWheels( ent )
	if CLIENT then return end

	local base = ent:GetBase()

	if not IsValid( base ) then return end

	local data = {}

	for id, wheel in pairs( base:GetWheels() ) do
		if not IsValid( wheel ) then continue end

		local wheeldata = {}
		wheeldata.ID = id
		wheeldata.Model = wheel:GetModel()
		wheeldata.ModelScale = wheel:GetModelScale()
		wheeldata.Skin = wheel:GetSkin()
		wheeldata.Camber = wheel:GetCamber()
		wheeldata.Caster = wheel:GetCaster()
		wheeldata.Toe = wheel:GetToe()
		wheeldata.AlignmentAngle = wheel:GetAlignmentAngle()
		wheeldata.Color = wheel:GetColor()

		table.insert( data, wheeldata )
	end
 
	if not duplicator or not duplicator.StoreEntityModifier then return end

	duplicator.StoreEntityModifier( base, "lvsCarWheels", data )
end

local function DuplicatorApplyCarWheels( ply, ent, data )
	if CLIENT then return end

	timer.Simple(0.1, function()
		if not IsValid( ent ) then return end

		for id, wheel in pairs( ent:GetWheels() ) do
			for _, wheeldata in pairs( data ) do
				if not wheeldata or wheeldata.ID ~= id then continue end

				if wheeldata.Model then wheel:SetModel( wheeldata.Model ) end
				if wheeldata.ModelScale then wheel:SetModelScale( wheeldata.ModelScale ) end
				if wheeldata.Skin then wheel:SetSkin( wheeldata.Skin ) end
				if wheeldata.Camber then wheel:SetCamber( wheeldata.Camber ) end
				if wheeldata.Caster then wheel:SetCaster( wheeldata.Caster ) end
				if wheeldata.Toe then wheel:SetToe( wheeldata.Toe ) end
				if wheeldata.AlignmentAngle then wheel:SetAlignmentAngle( wheeldata.AlignmentAngle ) end
				if wheeldata.Color then wheel:SetColor( wheeldata.Color ) end

				wheel:CheckAlignment()
				wheel:PhysWake()
			end
		end
	end)
end
if duplicator and duplicator.RegisterEntityModifier then
	duplicator.RegisterEntityModifier( "lvsCarWheels", DuplicatorApplyCarWheels )
end

function TOOL:IsValidTarget( ent )
	if not IsValid( ent ) then return false end

	local class = ent:GetClass()

	return class == "lvs_wheeldrive_wheel"
end

function TOOL:GetData( ent )
	if CLIENT then return end

	if self:IsValidTarget( ent ) then
		self.radius = ent:GetRadius() * (1 / ent:GetModelScale())
		self.ang = ent:GetAlignmentAngle()
		self.mdl = ent:GetModel()

		self:GetOwner():ConCommand( [[lvscarwheelchanger_model ""]] )
	else
		local data = list.Get( "lvs_wheels" )[ mdl ]

		if data then
			self:GetOwner():ConCommand( [[lvscarwheelchanger_model "]]..mdl..[["]] )
		end
	end
end

function TOOL:SetData( ent )
	if CLIENT then return end

	local mdl = self:GetClientInfo("model")

	if mdl ~= "" then
		local data = list.Get( "lvs_wheels" )[ mdl ]

		if data then
			self.mdl = mdl
			self.ang = data.angle
			self.radius = data.radius
		end
	end

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
		end)
	end

	timer.Simple(0.1, function()
		if not IsValid( ent ) then return end

		DuplicatorSaveCarWheels( ent )
	end)
end

function TOOL:LeftClick( trace )
	if not self:IsValidTarget( trace.Entity ) then return false end

	self:SetData( trace.Entity )

	return true
end

function TOOL:RightClick( trace )
	self:GetData( trace.Entity )

	return true
end

function TOOL:Reload( trace )
	local ent = trace.Entity

	if not self:IsValidTarget( ent ) then return false end

	ent:SetCamber( self:GetClientInfo("camber") )
	ent:SetCaster( self:GetClientInfo("caster") )
	ent:SetToe( self:GetClientInfo("toe") )
	ent:CheckAlignment()
	ent:PhysWake()

	DuplicatorSaveCarWheels( ent )

	return true
end

list.Set( "lvs_wheels", "models/props_vehicles/tire001b_truck.mdl", {angle = Angle(0,0,0), radius = 24.8} )
list.Set( "lvs_wheels", "models/diggercars/kubel/kubelwagen_wheel.mdl", {angle = Angle(0,0,0), radius = 13.47} )
list.Set( "lvs_wheels", "models/diggercars/willys/wh.mdl", {angle = Angle(0,0,0), radius = 15.64} )
--list.Set( "lvs_wheels", "models/diggercars/dodge_charger/wh.mdl", {angle = Angle(0,0,0), radius = 12.03} )
--list.Set( "lvs_wheels", "models/diggercars/nissan_bluebird910/bluebird_wheel.mdl", {angle = Angle(0,0,0), radius = 11.97} )
--list.Set( "lvs_wheels", "models/diggercars/ferrari_365/f365_wheel.mdl", {angle = Angle(0,0,0), radius = 13.96} )
--list.Set( "lvs_wheels", "models/diggercars/alfa_montreal/monteral_wheel.mdl", {angle = Angle(0,0,0), radius = 12.77} )