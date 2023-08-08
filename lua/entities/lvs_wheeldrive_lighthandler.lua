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

	if not IsValid( base ) then

		timer.Simple( 1, function()
			if not IsValid( self ) then return end

			self:Initialize()
		end )

		return
	end

	self:InitializeLights( base )
	self:InitializeSubMaterials( base )
end

function ENT:InitializeLights( base )
	local data = base.Lights

	if not istable( data ) then return end

	for id, lightsdata in pairs( data.Main.Sprites ) do

		data.Main.Sprites[ id ].PixVis = util.GetPixelVisibleHandle()

		data.Main.Sprites[ id ].mat = data.Main.Sprites[ id ].mat or Material( "sprites/light_ignorez" )
		data.Main.Sprites[ id ].width = lightsdata.width or 50
		data.Main.Sprites[ id ].height = lightsdata.height or 50
		data.Main.Sprites[ id ].colorR = lightsdata.colorR or 255
		data.Main.Sprites[ id ].colorG = lightsdata.colorG or 255
		data.Main.Sprites[ id ].colorB = lightsdata.colorB or 255
		data.Main.Sprites[ id ].colorA = lightsdata.colorA or 255
	end
end

function ENT:InitializeSubMaterials( base )
	local data = base.Lights

	if not istable( data ) then return end

	local SubMaterialID = data.Main.SubMaterialID

	if not SubMaterialID then return end

	local Mat = base:GetMaterials()[ SubMaterialID + 1 ] 

	local EntID = base:EntIndex()

	local string_data = file.Read( "materials/"..Mat..".vmt", "GAME" )

	if not string_data then return end

	local data = util.KeyValuesToTable( string_data )

	self.MainLights = CreateMaterial("lights"..EntID, "VertexLitGeneric", data )

	PrintChat("runs")

	base:SetSubMaterial( SubMaterialID, "!lights"..EntID )
end

function ENT:GetMain()
	return (self._smLights or 0)
end

function ENT:LightsThink()
	local Target = self:GetActive() and 1 or 0

	self._smLights = self:GetMain() + (Target - self:GetMain()) * RealFrameTime() * 25

	if not self.MainLights then return end

	self.MainLights:SetFloat("$detailblendfactor", self:GetMain() )
end

function ENT:RenderLights( base, data )
	local Mul = self:GetMain()

	if Mul <= 0.01 then return end

	for id, lightsdata in pairs( data.Main.Sprites ) do
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

function ENT:Think()
	local base = self:GetBase()

	if not IsValid( base ) then
		self:SetNextClientThink( CurTime() + 1 )

		return true
	end

	self:LightsThink()

	self:SetNextClientThink( CurTime() )

	return true
end

function ENT:OnRemove()
end

function ENT:Draw()
end

function ENT:DrawTranslucent()
end
