
AccessorFunc(ENT, "axle", "Axle", FORCE_NUMBER)

function ENT:SetDamageAllowed( allow )
	self._AllowDamage = allow
end

function ENT:GetDamageAllowed()
	return self._AllowDamage == true
end

function ENT:Destroy()
	if not self:GetDamageAllowed() then return end

	if self:GetDestroyed() then return end

	self:SetDestroyed( true )

	if not self._torqueFactor then return end

	self.old_torqueFactor = self._torqueFactor
	self._torqueFactor = self._torqueFactor * 0.25
end

function ENT:Repair()
	if not self:GetDestroyed() then return end

	self:SetHP( self:GetMaxHP() )

	self:SetDestroyed( false )

	if not self.old_torqueFactor then return end

	self._torqueFactor = self.old_torqueFactor
	self.old_torqueFactor = nil
end

function ENT:SetMaster( master )
	self._Master = master
end

function ENT:GetMaster()
	return self._Master
end

function ENT:GetDirectionAngle()
	if not IsValid( self._Master ) then return angle_zero end

	return self._Master:GetAngles()
end

function ENT:GetRotationAxis()
	local WorldAngleDirection = -self:WorldToLocalAngles( self:GetDirectionAngle() )

	return WorldAngleDirection:Right()
end

function ENT:GetSteerType()
	if self._steerType then return self._steerType end

	local base = self:GetBase()

	if not IsValid( base ) then return 0 end

	self._steerType = base:GetAxleData( self:GetAxle() ).SteerType

	return self._steerType
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
