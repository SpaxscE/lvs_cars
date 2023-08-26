
AccessorFunc(ENT, "axle", "Axle", FORCE_NUMBER)

function ENT:SetMaster( master )
	self._Master = master
end

function ENT:GetMaster()
	return self._Master
end

function ENT:GetDirectionAngle()
	local master = self:GetMaster()

	if not IsValid( master ) then return self:GetAngles() end

	return master:GetAngles()
end

function ENT:GetRotationAxis()
	local base = self:GetBase()

	if not IsValid( base ) then return vector_origin end

	local WorldAngleDirection = -self:WorldToLocalAngles( self:GetDirectionAngle() )

	return WorldAngleDirection:Right()
end

function ENT:GetTorqueFactor()
	if self._torqueFactor then return self._torqueFactor end

	local base = self:GetBase()

	if not IsValid( base ) then return 0 end

	self._torqueFactor = base:GetAxleData( self:GetAxle() ).TorqueFactor or 0

	return self._torqueFactor
end

function ENT:GetBrakeFactor()
	if self._brakeFactor then return self._brakeFactor end

	local base = self:GetBase()

	if not IsValid( base ) then return 0 end

	self._brakeFactor = base:GetAxleData( self:GetAxle() ).BrakeFactor or 0

	return self._brakeFactor
end
