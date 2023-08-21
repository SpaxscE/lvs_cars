include("shared.lua")
include("cl_prediction.lua")

function ENT:OnFrame()
	self:PredictPoseParamaters()
end

function ENT:LVSPreHudPaint( X, Y, ply )

	if ply == self:GetDriver() then
		local Col = Color(255,255,255,255)

		local Pos2D = self:GetEyeTrace().HitPos:ToScreen() 

		self:PaintCrosshairCenter( Pos2D, Col )
		self:PaintCrosshairOuter( Pos2D, Col )
		self:LVSPaintHitMarker( Pos2D )
	end

	return true
end

function ENT:CalcViewOverride( ply, pos, angles, fov, pod )
	if ply == self:GetDriver() then
		pos = pos + self:GetUp() * 100
	end

	return pos, angles, fov
end

