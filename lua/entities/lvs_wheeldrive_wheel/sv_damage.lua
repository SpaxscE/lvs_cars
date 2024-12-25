
function ENT:Pop()
	if self:GetNWDamaged() then return end

	self:SetNWDamaged( true )

	local PhysObj = self:GetPhysicsObject()

	if not IsValid( PhysObj ) then return end

	PhysObj:SetMaterial( "metal" )

	if not IsValid( self.SuspensionConstraintElastic ) then return end

	local Length = (self.SuspensionConstraintElastic:GetTable().length or 25) - self.RimOffset

	self.SuspensionConstraintElastic:Fire( "SetSpringLength", math.max( Length - self.RimOffset, 1 ) )
end

function ENT:SetDamaged( new )
	if new == self:GetNWDamaged() then return end

	self:SetNWDamaged( new )

	if new then
		if not self._torqueFactor or self.old_torqueFactor then return end

		self.old_torqueFactor = self._torqueFactor
		self._torqueFactor = self._torqueFactor * 0.25

		return
	end

	if not self.old_torqueFactor then return end

	self._torqueFactor = self.old_torqueFactor
	self.old_torqueFactor = nil
end

function ENT:Destroy()
	if self:GetDestroyed() then return end

	self:SetDestroyed( true )
	self:SetDamaged( true )

	local Master = self:GetMaster()

	if not IsValid( Master ) or IsValid( self.bsLockDMG ) then return end

	local Fric = 10

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
end