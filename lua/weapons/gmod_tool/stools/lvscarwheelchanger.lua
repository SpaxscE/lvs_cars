

TOOL.Category		= "LVS"
TOOL.Name			= "#Wheel Editor"

TOOL.ClientConVar[ "model" ] = "models/diggercars/kubel/kubelwagen_wheel.mdl"
TOOL.ClientConVar[ "camber" ] = 0
TOOL.ClientConVar[ "caster" ] = 0
TOOL.ClientConVar[ "toe" ] = 0
TOOL.ClientConVar[ "skin" ] = 0
TOOL.ClientConVar[ "bodygroup0" ] = 0
TOOL.ClientConVar[ "bodygroup1" ] = 0
TOOL.ClientConVar[ "bodygroup2" ] = 0
TOOL.ClientConVar[ "bodygroup3" ] = 0
TOOL.ClientConVar[ "bodygroup4" ] = 0
TOOL.ClientConVar[ "bodygroup5" ] = 0
TOOL.ClientConVar[ "bodygroup6" ] = 0
TOOL.ClientConVar[ "bodygroup7" ] = 0
TOOL.ClientConVar[ "bodygroup8" ] = 0
TOOL.ClientConVar[ "bodygroup9" ] = 0
TOOL.ClientConVar[ "r" ] = 255
TOOL.ClientConVar[ "g" ] = 255
TOOL.ClientConVar[ "b" ] = 255
TOOL.ClientConVar[ "a" ] = 255

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

	local ContextMenuPanel

	local cvarmdl = GetConVar( "lvscarwheelchanger_model" )
	local mdl = cvarmdl and cvarmdl:GetString() or ""
	local skins = 0
	local bodygroups = {}

	local ConVarsDefault = TOOL:BuildConVarList()
	local function BuildContextMenu()
		if not IsValid( ContextMenuPanel ) then return end

		ContextMenuPanel:Clear()

		ContextMenuPanel:AddControl( "Header", { Text = "#tool.lvscarwheelchanger.name", Description = "#tool.lvscarwheelchanger.desc" } )
		ContextMenuPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "lvswheels", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

		ContextMenuPanel:ColorPicker( "Wheel Color", "lvscarwheelchanger_r", "lvscarwheelchanger_g", "lvscarwheelchanger_b", "lvscarwheelchanger_a" )

		if #bodygroups > 0 then
			ContextMenuPanel:AddControl( "Label",  { Text = "" } )
			ContextMenuPanel:AddControl( "Label",  { Text = "BodyGroup" } )
	
			for group, data in pairs( bodygroups ) do
				ContextMenuPanel:AddControl("Slider", { Label = data.name, Type = "int", Min = "0", Max = tostring( data.submodels ), Command = "lvscarwheelchanger_bodygroup"..group } )
			end
		end

		if skins > 0 then
			ContextMenuPanel:AddControl( "Label",  { Text = "" } )
			ContextMenuPanel:AddControl( "Label",  { Text = "Skins" } )
			ContextMenuPanel:AddControl("Slider", { Label = "Skin", Type = "int", Min = "0", Max = tostring( skins ), Command = "lvscarwheelchanger_skin" } )
		end

		ContextMenuPanel:AddControl( "Label",  { Text = "" } )
		ContextMenuPanel:AddControl( "Label",  { Text = "Wheel Alignment Specs" } )
		ContextMenuPanel:AddControl("Slider", { Label = "Camber", Type = "float", Min = "-15", Max = "15", Command = "lvscarwheelchanger_camber" } )
		ContextMenuPanel:AddControl("Slider", { Label = "Caster", Type = "float", Min = "-15", Max = "15", Command = "lvscarwheelchanger_caster" } )
		ContextMenuPanel:AddControl("Slider", { Label = "Toe", Type = "float", Min = "-30", Max = "30", Command = "lvscarwheelchanger_toe" } )

		-- purpose: avoid bullshit concommand system and avoid players abusing it
		for mdl, _ in pairs( list.Get( "lvs_wheels" ) or {} ) do
			list.Set( "lvs_wheels_selection", mdl, {} )
		end
		ContextMenuPanel:AddControl( "Label",  { Text = "" } )
		ContextMenuPanel:AddControl( "Label",  { Text = "Wheel Models" } )
		ContextMenuPanel:AddControl( "PropSelect", { Label = "", ConVar = "lvscarwheelchanger_model", Height = 0, Models = list.Get( "lvs_wheels_selection" ) } )
	end

	local function SetModel( name )
		local ModelInfo = util.GetModelInfo( name )

		if ModelInfo and ModelInfo.SkinCount then
			skins = ModelInfo.SkinCount - 1
		else
			skins = 0
		end

		local bgroupmdl = ents.CreateClientProp()
		bgroupmdl:SetModel( name )
		bgroupmdl:Spawn()

		table.Empty( bodygroups )

		for _, bgroup in pairs( bgroupmdl:GetBodyGroups() ) do
			bodygroups[ bgroup.id ] = {
				name = bgroup.name,
				submodels = #bgroup.submodels,
			}
		end

		bgroupmdl:Remove()

		BuildContextMenu()
	end

	function TOOL.BuildCPanel( panel )
		ContextMenuPanel = panel

		BuildContextMenu()
	end

	cvars.AddChangeCallback( "lvscarwheelchanger_model", function( convar, oldValue, newValue ) 
		if oldValue ~= newValue and newValue ~= "" then
			SetModel( newValue )

			local ply = LocalPlayer()

			if not IsValid( ply ) or not ply.ConCommand then return end

			ply:ConCommand( [[lvscarwheelchanger_bodygroups ""]] )
			ply:ConCommand( [[lvscarwheelchanger_skin 0]] )
		end
	end)

	net.Receive( "lvscarwheelchanger_updatemodel", function( len )
		SetModel( net.ReadString() )
	end )
else
	util.AddNetworkString( "lvscarwheelchanger_updatemodel" )
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

		wheeldata.BodyGroups = {}
		for id = 0, 9 do
			wheeldata.BodyGroups[ id ] = wheel:GetBodygroup( id )
		end

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

				if wheeldata.BodyGroups then
					for group, subgroup in pairs( wheeldata.BodyGroups ) do
						if subgroup == 0 then continue end

						wheel:SetBodygroup( group, subgroup )
					end
				end

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

	local ply = self:GetOwner()

	if self:IsValidTarget( ent ) then
		self.radius = ent:GetRadius() * (1 / ent:GetModelScale())
		self.ang = ent:GetAlignmentAngle()
		self.mdl = ent:GetModel()

		ply:ConCommand( [[lvscarwheelchanger_model ""]] )

		net.Start( "lvscarwheelchanger_updatemodel" )
			net.WriteString( self.mdl )
		net.Send( ply )
	else
		local data = list.Get( "lvs_wheels" )[ mdl ]

		if data then
			ply:ConCommand( [[lvscarwheelchanger_model "]]..mdl..[["]] )
		end
	end

	ply:ConCommand( "lvscarwheelchanger_skin "..ent:GetSkin() )

	local clr = ent:GetColor()
	ply:ConCommand( "lvscarwheelchanger_r " .. clr.r )
	ply:ConCommand( "lvscarwheelchanger_g " .. clr.g )
	ply:ConCommand( "lvscarwheelchanger_b " .. clr.b )
	ply:ConCommand( "lvscarwheelchanger_a " .. clr.a )

	for id = 0, 9 do
		local group = ent:GetBodygroup( id ) or 0
		ply:ConCommand( "lvscarwheelchanger_bodygroup"..id.." "..group )
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

	local r = self:GetClientNumber( "r", 0 )
	local g = self:GetClientNumber( "g", 0 )
	local b = self:GetClientNumber( "b", 0 )
	local a = self:GetClientNumber( "a", 0 )

	ent:SetColor( Color( r, g, b, a ) )
	ent:SetSkin( self:GetClientNumber( "skin", 0 ) )

	for id = 0, 9 do
		ent:SetBodygroup( id, self:GetClientNumber( "bodygroup"..id, 0 ) )
	end

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