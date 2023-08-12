AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )
	self:NetworkVar( "Bool",0, "Active" )
	self:NetworkVar( "Bool",1, "HighActive" )
	self:NetworkVar( "Bool",2, "FogActive" )
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
				data[typeid].ProjectedTextures[ projid ].mat = projdata.mat or (typedata.Trigger == "high" and "effects/flashlight/soft" or "effects/lvs/car_projectedtexture")
				data[typeid].ProjectedTextures[ projid ].farz = projdata.farz or (typedata.Trigger == "high" and 2500 or 1000)
				data[typeid].ProjectedTextures[ projid ].nearz = projdata.nearz or 75
				data[typeid].ProjectedTextures[ projid ].fov = projdata.fov or (typedata.Trigger == "high" and 90 or 60)
				data[typeid].ProjectedTextures[ projid ].colorR = projdata.colorR or 255
				data[typeid].ProjectedTextures[ projid ].colorG = projdata.colorG or 255
				data[typeid].ProjectedTextures[ projid ].colorB = projdata.colorB or 255
				data[typeid].ProjectedTextures[ projid ].colorA = projdata.colorA or 255
				data[typeid].ProjectedTextures[ projid ].color = Color( projdata.colorR or 255, projdata.colorG or 255, projdata.colorB or 255 )
				data[typeid].ProjectedTextures[ projid ].brightness = projdata.brightness or (typedata.Trigger == "high" and 5 or 5)
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
	if not mat then return end

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

		local mul = self:GetTypeActivator( typedata.Trigger )
		local active = mul > 0.01

		if typedata.Trigger == "main" then
			if self:GetHighActive() then
				active = false
			end
		end

		if typedata.ProjectedTextures then
			for projid, projdata in pairs( typedata.ProjectedTextures ) do
				local id = typeid.."-"..projid

				local proj = self:GetProjectedTexture( id )

				if IsValid( proj ) then
					if active then
						proj:SetBrightness( projdata.brightness * mul ) 
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

		typedata.SubMaterial:SetFloat("$detailblendfactor", mul )

		if typedata.SubMaterialValue ~= active then
			data[typeid].SubMaterialValue = active
			base:SetSubMaterial(typedata.SubMaterialID, "!"..typedata.Trigger..typedata.SubMaterialID..Class..EntID)
		end
	end
end

function ENT:GetTypeActivator( trigger )
	if trigger == "main" then return (self._smMain or 0) ^ 2 end

	if trigger == "high" then return (self._smHigh or 0) ^ 2 end

	if trigger == "fog" then return (self._smFog or 0) ^ 2 end

	if trigger == "brake" then return (self._smBrake or 0) ^ 2  end

	if trigger == "reverse" then return (self._smReverse or 0) ^ 2 end

	if trigger == "turnleft" then return (self._smTurnLeft or 0) end

	if trigger == "turnright" then return (self._smTurnRight or 0) end

	return 0
end

local Left = {
	[1] = true,
	[3] = true,
}
local Right = {
	[2] = true,
	[3] = true,
}

function ENT:CalcTypeActivators( base )
	local base = self:GetBase()

	if not IsValid( base ) then return end

	self._smMain = self._smMain or 0
	self._smHigh = self._smHigh or 0
	self._smFog = self._smFog or 0
	self._smBrake = self._smBrake or 0
	self._smReverse = self._smReverse or 0
	self._smTurnLeft = self._smTurnLeft or 0
	self._smTurnRight = self._smTurnRight or 0

	local main = self:GetActive() and 1 or 0
	local high = self:GetHighActive() and 1 or 0
	local fog = self:GetFogActive() and 1 or 0
	local brake = base:GetBrake() > 0 and 1 or 0
	local reverse = base:GetReverse() and 1 or 0

	local Flasher = base:GetTurnFlasher()
	local TurnMode = base:GetTurnMode()

	local turnleft = (Left[ TurnMode ] and Flasher) and 1 or 0
	local turnright = (Right[ TurnMode ] and Flasher) and 1 or 0

	local Rate = RealFrameTime() * 10

	self._smMain = self._smMain + (main - self._smMain) * Rate
	self._smHigh = self._smHigh + (high - self._smHigh) * Rate
	self._smFog = self._smFog + (fog - self._smFog) * Rate
	self._smBrake = self._smBrake + (brake - self._smBrake) * Rate
	self._smReverse = self._smReverse + (reverse - self._smReverse) * Rate
	self._smTurnLeft = self._smTurnLeft + (turnleft - self._smTurnLeft) * Rate * 2
	self._smTurnRight = self._smTurnRight + (turnright - self._smTurnRight) * Rate * 2
end

ENT.LightMaterial = Material( "effects/lvs/car_spotlight" )

function ENT:RenderLights( base, data )
	if not self.Enabled then return end

	for _, typedata in pairs( data ) do

		local mul = self:GetTypeActivator( typedata.Trigger )

		if mul < 0.01 then continue end

		if typedata.ProjectedTextures then
			for projid, projdata in pairs( typedata.ProjectedTextures ) do
				local pos = base:LocalToWorld( projdata.pos )
				local dir = base:LocalToWorldAngles( projdata.ang ):Forward()
	
				render.SetMaterial( self.LightMaterial )
				render.DrawBeam( pos, pos + dir * 100, 50, -0.01, 0.99, Color( projdata.colorR * mul, projdata.colorG * mul, projdata.colorB * mul, projdata.brightness ) )
			end
		end

		if not typedata.Sprites then continue end

		for id, lightsdata in pairs( typedata.Sprites ) do
			if not lightsdata.PixVis then
				continue
			end

			local pos = base:LocalToWorld( lightsdata.pos )

			local visible = util.PixelVisible( pos, 2, lightsdata.PixVis )

			if not visible then continue end

			if visible <= 0.1 then continue end

			render.SetMaterial( lightsdata.mat )
			render.DrawSprite( pos, lightsdata.width, lightsdata.height , Color(lightsdata.colorR,lightsdata.colorG,lightsdata.colorB,lightsdata.colorA*mul*visible^2) )
		end
	end
end

function ENT:Think()
	local base = self:GetBase()

	if not IsValid( base ) or not self.Enabled then
		self:SetNextClientThink( CurTime() + 1 )

		return true
	end

	self:CalcTypeActivators( base )
	self:LightsThink( base )
end

function ENT:OnRemove()
	self:ClearProjectedTextures()
end

function ENT:Draw()
end

function ENT:DrawTranslucent()
end
