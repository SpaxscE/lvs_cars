
ENT.FlyByVelocity = 500
ENT.FlyByMinThrottle = 0
ENT.FlyByAdvance = 1
ENT.FlyBySound = "lvs/vehicles/generic/car_flyby.wav"

function ENT:FlyByThink()
	local ply = LocalPlayer()

	if not IsValid( ply ) then return end

	local veh = ply:lvsGetVehicle()

	if veh == self then self.OldApproaching = false return end

	local ViewEnt = ply:GetViewEntity()

	if not IsValid( ViewEnt ) then return end

	if IsValid( veh ) and ViewEnt == ply then
		ViewEnt = veh
	end

	local Time = CurTime()

	if (self._nextflyby or 0) > Time then return end

	self._nextflyby = Time + 0.1

	local Vel = self:GetVelocity()

	if self:GetThrottle() <= self.FlyByMinThrottle or Vel:Length() <= self.FlyByVelocity then return end

	local Sub = ViewEnt:GetPos() - self:GetPos() - Vel * self.FlyByAdvance
	local ToPlayer = Sub:GetNormalized()
	local VelDir = Vel:GetNormalized()

	local ApproachAngle = self:AngleBetweenNormal( ToPlayer, VelDir  )

	local Approaching = ApproachAngle < 80

	if Approaching ~= self.OldApproaching then
		self.OldApproaching = Approaching

		if Approaching then
			self:StopFlyBy()
		else
			self:OnFlyBy( 60 + 80 * math.min(ApproachAngle / 140,1) )
		end
	end
end

function ENT:OnFlyBy( Pitch )
	if not self.FlyBySound then return end

	self.flybysnd = CreateSound( self, self.FlyBySound )
	self.flybysnd:SetSoundLevel( 95 )
	self.flybysnd:PlayEx( 1, Pitch )
end

function ENT:StopFlyBy()
	if self.flybysnd then
		self.flybysnd:Stop()
		self.flybysnd = nil
	end
end