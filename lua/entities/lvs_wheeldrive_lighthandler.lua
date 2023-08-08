AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )
	self:NetworkVar( "Bool",0, "Active" )
end

if SERVER then
	function ENT:Initialize()	
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		self:DrawShadow( false )
	end

	function ENT:Think()
		return false
	end

	function ENT:OnTakeDamage( dmginfo )
	end

	return
end

function ENT:Initialize()
	local base = self:GetBase()

	if not IsValid( base )then

		timer.Simple( 1, function()
			if not IsValid( self ) then return end

			self:Initialize()
		end )

		return
	end

	self:InitializeLights( base )
end

function ENT:InitializeLights( base )
	local data = base.Lights

	if not istable( data ) then return end

	for typeid, typedata in pairs( data ) do
		if not typedata.Trigger then
			data[typeid] = nil
		end

		if typedata.SubMaterialID then
			data[typeid].SubMaterial = self:CreateSubMaterial( typedata.SubMaterialID, typedata.Trigger )
		end

		if not typedata.Sprites then continue end

		for lightsid, lightsdata in pairs( typedata.Sprites ) do
			data[typeid].Sprites[ lightsid ].PixVis = util.GetPixelVisibleHandle()
			data[typeid].Sprites[ lightsid ].mat = lightsdata.mat or Material( "sprites/light_ignorez" )
			data[typeid].Sprites[ lightsid ].width = lightsdata.width or 50
			data[typeid].Sprites[ lightsid ].height = lightsdata.height or 50
			data[typeid].Sprites[ lightsid ].colorR = lightsdata.colorR or 255
			data[typeid].Sprites[ lightsid ].colorG = lightsdata.colorG or 255
			data[typeid].Sprites[ lightsid ].colorB = lightsdata.colorB or 255
			data[typeid].Sprites[ lightsid ].colorA = lightsdata.colorA or 255
		end
	end
end

function ENT:CreateSubMaterial( SubMaterialID, name )
	local base = self:GetBase()

	if not IsValid( base ) or not SubMaterialID then return end

	local string_data = file.Read( "materials/"..base:GetMaterials()[ SubMaterialID + 1 ]..".vmt", "GAME" )

	if not string_data then return end

	return CreateMaterial( name..base:EntIndex(), "VertexLitGeneric", util.KeyValuesToTable( string_data ) )
end

function ENT:SubMaterialThink( base )
	local EntID = base:EntIndex() 
	local data = base.Lights

	if not istable( data ) then return end

	for typeid, typedata in pairs( data ) do
		if not typedata.SubMaterialID or not typedata.SubMaterial then continue end

		local Mul = self:GetTypeActivator( typedata.Trigger )

		typedata.SubMaterial:SetFloat("$detailblendfactor", Mul and 1 or 0 )

		if typedata.SubMaterialValue ~= Mul then
			data[typeid].SubMaterialValue = Mul
			base:SetSubMaterial(typedata.SubMaterialID, "!"..typedata.Trigger..EntID)
		end
	end
end

function ENT:GetTypeActivator( trigger )
	if trigger == "main" then return self:GetActive() end

	local base = self:GetBase()

	if not IsValid( base ) then return false end

	if trigger == "brake" then return base:GetBrake() > 0 end

	if trigger == "reverse" then return base:GetReverse() end

	return false
end

function ENT:RenderLights( base, data )
	for _, typedata in pairs( data ) do
		if not typedata.Sprites then continue end

		local Mul = self:GetTypeActivator( typedata.Trigger ) and 1 or 0

		for id, lightsdata in pairs( typedata.Sprites ) do
			if not lightsdata.PixVis then
				continue
			end

			local pos = base:LocalToWorld( lightsdata.pos )

			local visible = util.PixelVisible( pos, 2, lightsdata.PixVis )

			if not visible then continue end

			if visible <= 0.1 then continue end

			render.SetMaterial( lightsdata.mat )
			render.DrawSprite( pos, lightsdata.width, lightsdata.height , Color(lightsdata.colorR,lightsdata.colorG,lightsdata.colorB,lightsdata.colorA*Mul*visible^2) )
		end
	end
end

function ENT:Think()
	local base = self:GetBase()

	if not IsValid( base ) then
		self:SetNextClientThink( CurTime() + 1 )

		return true
	end

	self:SubMaterialThink( base )
end

function ENT:OnRemove()
end

function ENT:Draw()
end

function ENT:DrawTranslucent()
end
