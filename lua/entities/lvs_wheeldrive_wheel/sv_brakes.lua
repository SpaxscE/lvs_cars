
function ENT:SetHandbrake( enable )
	if enable then

		self:EnableHandbrake()

		return
	end

	self:ReleaseHandbrake()
end

function ENT:IsHandbrakeActive()
	return self._handbrakeActive == true
end

function ENT:EnableHandbrake()
	if self._handbrakeActive then return end

	self._handbrakeActive = true

	self:LockRotation()
end

function ENT:ReleaseHandbrake()
	if not self._handbrakeActive then return end

	self._handbrakeActive = nil

	self:ReleaseRotation()
end

function ENT:LockRotation()
	if self:IsRotationLocked() then return end

	local Master = self:GetMaster()

	if not IsValid( Master ) then return end

	self.bsLock = constraint.AdvBallsocket(self,Master,0,0,vector_origin,vector_origin,0,0,-0.1,-0.1,-0.1,0.1,0.1,0.1,0,0,0,1,1)
	self.bsLock.DoNotDuplicate = true
end

function ENT:ReleaseRotation()
	if not self:IsRotationLocked() then return end

	self.bsLock:Remove()
end

function ENT:IsRotationLocked()
	return IsValid( self.bsLock )
end
