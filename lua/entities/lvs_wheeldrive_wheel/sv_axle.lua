
AccessorFunc(ENT, "axle", "Axle", FORCE_NUMBER)

function ENT:SetDamaged( new )
	if new == self:GetNWDamaged() then return end

	self:SetNWDamaged( new )

	if new then
		if not self._torqueFactor or self.old_torqueFactor then return end

		self.old_torqueFactor = self._torqueFactor
		self._torqueFactor = self._torqueFactor * 0.25

		return
	end

	if self._torqueFactor and not self.old_torqueFactor then
		self.old_torqueFactor = self._torqueFactor
		self._torqueFactor = 0
	end
end

function ENT:Destroy()
	if self:GetDestroyed() then return end

	self:SetDestroyed( true )
	self:SetDamaged( true )

	if self._torqueFactor and not self.old_torqueFactor then
		self.old_torqueFactor = self._torqueFactor
		self._torqueFactor = 0
	end

	local Master = self:GetMaster()

	if not IsValid( Master ) or IsValid( self.bsLockDMG ) then return end

	local Fric = 0.75

	self.bsLockDMG = constraint.AdvBallsocket(self,Master,0,0,vector_origin,vector_origin,0,0,-180,-180,-180,180,180,180,Fric,Fric,Fric,1,1)
	self.bsLockDMG.DoNotDuplicate = true
end

function ENT:Repair()
	self:SetHP( self:GetMaxHP() )

	self:SetDestroyed( false )
	self:SetDamaged( false )

	if IsValid( self.bsLockDMG ) then
		self.bsLockDMG:Remove()
	end

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
