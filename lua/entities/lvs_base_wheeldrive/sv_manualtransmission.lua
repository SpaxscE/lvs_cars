function ENT:EnableManualTransmission()
	self:SetReverse( false )
	self:SetNWGear( 1 )
end

function ENT:DisableManualTransmission()
	self:SetNWGear( -1 )
end

function ENT:CalcManualTransmission( ply, EntTable, ShiftUp, ShiftDn )
	if ShiftUp ~= EntTable._oldShiftUp then
		EntTable._oldShiftUp = ShiftUp

		if ShiftUp then
			self:ShiftUp()
		end
	end

	if ShiftDn ~= EntTable._oldShiftDn then
		EntTable._oldShiftDn = ShiftDn

		if ShiftDn then
			self:ShiftDown()
		end
	end
end

function ENT:OnShiftUp()
end

function ENT:OnShiftDown()
end

function ENT:ShiftUp()
	if self:OnShiftUp() == false then return end

	local Reverse = self:GetReverse()

	if Reverse then
		local NextGear = self:GetNWGear() - 1

		self:SetNWGear( math.max( NextGear, 1 ) )

		if NextGear <= 0 then
			self:SetReverse( false )
		end

		return
	end

	self:SetNWGear( math.min( self:GetNWGear() + 1, self.TransGears ) )
end

function ENT:ShiftDown()
	if self:OnShiftDown() == false then return end

	local Reverse = self:GetReverse()

	if Reverse then
		self:SetNWGear( math.min( self:GetNWGear() + 1, self.TransGearsReverse ) )

		return
	end

	local NextGear = self:GetNWGear() - 1

	self:SetNWGear( math.max( NextGear, 1 ) )

	if NextGear <= 0 then
		self:SetReverse( true )
	end
end

function ENT:OnEngineStalled()
	timer.Simple(math.Rand(0.8,1.6), function()
		if not IsValid( self ) or self:GetEngineActive() then return end

		self:StartEngine()
	end)
end

function ENT:StallEngine()
	self:StopEngine()
	self:SetNWGear( 1 )

	self:OnEngineStalled()
end

function ENT:GetEngineTorque()
	if self:IsManualTransmission() then
		local Gear = self:GetGear()
		local EntTable = self:GetTable()

		local NumGears = Reverse and EntTable.TransGearsReverse or EntTable.TransGears
		local MaxVelocity = Reverse and EntTable.MaxVelocityReverse or EntTable.MaxVelocity

		local PitchValue = MaxVelocity / NumGears

		local Vel = self:GetVelocity():Length()

		local preRatio = math.Clamp(Vel / (PitchValue * (Gear - 1)),0,1)
		local Ratio = math.Clamp( 2 - math.max( Vel - PitchValue * (Gear - 1), 0 ) / PitchValue, 0, 1 )

		local RatioIdeal = math.min( Ratio, preRatio )

		if preRatio <= 0.05 and Vel < PitchValue and Gear > 1 then
			self:StallEngine()
		end

		return math.deg( self.EngineTorque ) * RatioIdeal
	end

	return math.deg( self.EngineTorque )
end