include("shared.lua")
include("cl_effects.lua")
include("cl_skidmarks.lua")

function ENT:Draw()
	self:SetRenderAngles( self:LocalToWorldAngles( self:GetAlignmentAngle() ) )
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:CalcWheelEffects()
end

function ENT:Think()
	return false
end

function ENT:OnRemove()
	self:StopWheelEffects()
end