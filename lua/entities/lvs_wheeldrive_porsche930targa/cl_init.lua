include("shared.lua")

function ENT:OnSpawn()
	local SubMaterialID = 19

	local Mat = self:GetMaterials()[ SubMaterialID + 1 ] 

	local EntID = self:EntIndex()

	local data = util.KeyValuesToTable( file.Read( "materials/"..Mat..".vmt", "GAME" ) )

	self.TestMaterial = CreateMaterial("lights"..EntID, "VertexLitGeneric", data )

	self.TestMaterial:SetFloat("$detailblendfactor", 0 )

	self:SetSubMaterial( SubMaterialID, "!lights"..EntID )
end

function ENT:OnFrameActive()
end

function ENT:OnFrame()
	if not self.TestMaterial then return end

	self.TestMaterial:SetFloat("$detailblendfactor", math.max( math.cos( CurTime() * 2 ), 0 ) )
end

function ENT:OnEngineActiveChanged( Active )
end

function ENT:OnActiveChanged( Active )
end