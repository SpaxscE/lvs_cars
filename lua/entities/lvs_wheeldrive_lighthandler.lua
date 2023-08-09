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

		if typedata.Sprites then
			for lightsid, lightsdata in pairs( typedata.Sprites ) do
				data[typeid].Sprites[ lightsid ].PixVis = util.GetPixelVisibleHandle()
				data[typeid].Sprites[ lightsid ].pos = lightsdata.pos or vector_origin
				data[typeid].Sprites[ lightsid ].mat = lightsdata.mat or Material( "sprites/light_ignorez" )
				data[typeid].Sprites[ lightsid ].width = lightsdata.width or 50
				data[typeid].Sprites[ lightsid ].height = lightsdata.height or 50
				data[typeid].Sprites[ lightsid ].colorR = lightsdata.colorR or 255
				data[typeid].Sprites[ lightsid ].colorG = lightsdata.colorG or 255
				data[typeid].Sprites[ lightsid ].colorB = lightsdata.colorB or 255
				data[typeid].Sprites[ lightsid ].colorA = lightsdata.colorA or 255
			end
		end

		if typedata.ProjectedTextures then
			for projid, projdata in pairs( typedata.ProjectedTextures ) do
				data[typeid].ProjectedTextures[ projid ].pos = projdata.pos or vector_origin
				data[typeid].ProjectedTextures[ projid ].ang = projdata.ang or angle_zero
				data[typeid].ProjectedTextures[ projid ].mat = projdata.mat or "effects/flashlight/soft"
				data[typeid].ProjectedTextures[ projid ].farz = projdata.farz or 2500
				data[typeid].ProjectedTextures[ projid ].nearz = projdata.nearz or 75
				data[typeid].ProjectedTextures[ projid ].fov = projdata.fov or 60
				data[typeid].ProjectedTextures[ projid ].color = Color( projdata.colorR or 255, projdata.colorG or 255, projdata.colorB or 255 )
				data[typeid].ProjectedTextures[ projid ].brightness = projdata.brightness or 10
				data[typeid].ProjectedTextures[ projid ].shadows = projdata.shadows == true
			end
		end
	end

	self.Enabled = true
end

function ENT:CreateSubMaterial( SubMaterialID, name )
	local base = self:GetBase()

	if not IsValid( base ) or not SubMaterialID then return end

	local string_data = file.Read( "materials/"..base:GetMaterials()[ SubMaterialID + 1 ]..".vmt", "GAME" )

	if not string_data then return end

	return CreateMaterial( name..SubMaterialID..base:GetClass()..base:EntIndex(), "VertexLitGeneric", util.KeyValuesToTable( string_data ) )
end

function ENT:CreateProjectedTexture( id, mat, col, brightness, shadows, nearz, farz, fov )
	local thelamp = ProjectedTexture()
	thelamp:SetTexture( mat )
	thelamp:SetColor( col )
	thelamp:SetBrightness( brightness ) 
	thelamp:SetEnableShadows( shadows ) 
	thelamp:SetNearZ( nearz ) 
	thelamp:SetFarZ( farz ) 
	thelamp:SetFOV( fov )

	if istable( self._ProjectedTextures ) then
		if IsValid( self._ProjectedTextures[ id ] ) then
			self._ProjectedTextures[ id ]:Remove()
			self._ProjectedTextures[ id ] = nil
		end
	else
		self._ProjectedTextures = {}
	end

	self._ProjectedTextures[ id ] = thelamp

	return thelamp
end

function ENT:GetProjectedTexture( id )
	if not id or not istable( self._ProjectedTextures ) then return end

	return self._ProjectedTextures[ id ]
end

function ENT:RemoveProjectedTexture( id )
	if not id or not istable( self._ProjectedTextures ) then return end

	if IsValid( self._ProjectedTextures[ id ] ) then
		self._ProjectedTextures[ id ]:Remove()
		self._ProjectedTextures[ id ] = nil
	end
end

function ENT:ClearProjectedTextures()
	if not istable( self._ProjectedTextures ) then return end

	for id, proj in pairs( self._ProjectedTextures ) do
		if IsValid( proj ) then
			proj:Remove()
		end

		self._ProjectedTextures[ id ] = nil
	end
end

function ENT:LightsThink( base )
	local EntID = base:EntIndex()
	local Class = base:GetClass()
	local data = base.Lights

	if not istable( data ) then return end

	for typeid, typedata in pairs( data ) do

		local active = self:GetTypeActivator( typedata.Trigger )

		if typedata.ProjectedTextures then
			for projid, projdata in pairs( typedata.ProjectedTextures ) do
				local id = typeid.."-"..projid

				local proj = self:GetProjectedTexture( id )

				if IsValid( proj ) then
					if active then
						proj:SetPos( base:LocalToWorld( projdata.pos ) )
						proj:SetAngles( base:LocalToWorldAngles( projdata.ang ) )
						proj:Update()
					else
						self:RemoveProjectedTexture( id )
					end
				else
					if active then
						self:CreateProjectedTexture( id, projdata.mat, projdata.color, projdata.brightness, projdata.shadows, projdata.nearz, projdata.farz, projdata.fov )
					else
						self:RemoveProjectedTexture( id )
					end
				end
			end
		end

		if not typedata.SubMaterialID or not typedata.SubMaterial then continue end

		typedata.SubMaterial:SetFloat("$detailblendfactor", active and 1 or 0 )

		if typedata.SubMaterialValue ~= active then
			data[typeid].SubMaterialValue = active
			base:SetSubMaterial(typedata.SubMaterialID, "!"..typedata.Trigger..typedata.SubMaterialID..Class..EntID)
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
	if not self.Enabled then return end

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

	if not IsValid( base ) or not self.Enabled then
		self:SetNextClientThink( CurTime() + 1 )

		return true
	end

	self:LightsThink( base )
end

function ENT:OnRemove()
	self:ClearProjectedTextures()
end

function ENT:Draw()
end

function ENT:DrawTranslucent()
end
