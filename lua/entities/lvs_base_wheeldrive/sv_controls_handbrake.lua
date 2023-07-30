
function ENT:EnableHandbrake()
	if self:IsHandbrakeActive() then return end

	self._HandbrakeEnabled = true

	for _, Wheel in pairs( self:GetWheels() ) do
		if not self:GetAxleData( Wheel:GetAxle() ).UseHandbrake then continue end

		Wheel:SetHandbrake( true )
	end

	self:OnHandbrakeActiveChanged( true )
end

function ENT:ReleaseHandbrake()
	if not self:IsHandbrakeActive() then return end

	self._HandbrakeEnabled = nil

	for _, Wheel in pairs( self:GetWheels() ) do
		if not self:GetAxleData( Wheel:GetAxle() ).UseHandbrake then continue end

		Wheel:SetHandbrake( false )
	end

	self:OnHandbrakeActiveChanged( false )
end

function ENT:SetHandbrake( enable )
	if enable then

		self:EnableHandbrake()

		return
	end

	self:ReleaseHandbrake()
end

function ENT:IsHandbrakeActive()
	return self._HandbrakeEnabled == true
end

function ENT:OnHandbrakeActiveChanged( Active )
	if Active then
		self:EmitSound( "buttons/lever4.wav", 75, 255, 0.25 )
	else
		self:EmitSound( "buttons/lever7.wav", 75, 80, 0.25 )
	end
end