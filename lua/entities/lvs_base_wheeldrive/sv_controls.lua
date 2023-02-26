
function ENT:CalcSteer( ply, cmd )
	local KeyLeft = cmd:KeyDown( IN_MOVELEFT )
	local KeyRight = cmd:KeyDown( IN_MOVERIGHT )
	local Steer = (KeyRight and 1 or 0) - (KeyLeft and 1 or 0)

	local Rate = FrameTime() * 3.5
	local Cur = self:GetSteer()

	local Mul = self:GetVelocity():Length() < 500 and 1 or 0.25

	local New = Cur + math.Clamp(Steer * Mul - Cur,-Rate,Rate)

	self:SetSteer( New )
end

function ENT:CalcThrottle( ply, cmd )
	local KeyThrottle = cmd:KeyDown( IN_FORWARD )
	local KeyBoost = cmd:KeyDown( IN_SPEED )

	local Throttle = KeyThrottle and (KeyBoost and 1 or 0.5) or 0

	local Rate = FrameTime() * 3.5
	local Cur = self:GetThrottle()
	local New = Cur + math.Clamp(Throttle - Cur,-Rate,Rate)

	self:SetThrottle( New )
end

function ENT:StartCommand( ply, cmd )
	if self:GetDriver() ~= ply then return end

	self:CalcSteer( ply, cmd )
	self:CalcThrottle( ply, cmd )
end
