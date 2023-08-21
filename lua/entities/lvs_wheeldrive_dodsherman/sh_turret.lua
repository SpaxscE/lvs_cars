
if CLIENT then
	function ENT:CalcTurret()
		local pod = self:GetDriverSeat()

		if not IsValid( pod ) then return end

		local plyL = LocalPlayer()
		local ply = pod:GetDriver()

		if ply ~= plyL then return end

		self:AimTurret()
	end
end

function ENT:AddTurretDT()
	self:AddDT( "Float", "TurretPitch" )
	self:AddDT( "Float", "TurretYaw" )
	self:AddDT( "Bool", "TurretEnabled" )

	if SERVER then
		self:SetTurretEnabled( true )
	end
end

function ENT:IsTurretEnabled()
	if not self:GetTurretEnabled() then return false end

	return IsValid( self:GetDriver() ) or self:GetAI()
end

function ENT:CalcTurretSound( DeltaPitch, DeltaYaw, AimRate )
	if CLIENT then return end

	local PitchVolume = math.abs( DeltaPitch ) / AimRate
	local YawVolume = math.abs( DeltaYaw ) / AimRate

	local PlayPitch = PitchVolume > 0.95
	local PlayYaw = YawVolume > 0.95
end
--vehicles/tank_turret_start1.wav
--vehicles/tank_turret_stop1.wav
--vehicles/tank_turret_loop1.wav

function ENT:AimTurret()
	if not self:IsTurretEnabled() then return end

	local AimAngles = self:WorldToLocalAngles( self:GetAimVector():Angle() )

	local AimRate = 25 * FrameTime() 

	local Pitch = math.ApproachAngle( self:GetTurretPitch(), AimAngles.p, AimRate )
	local Yaw = math.ApproachAngle( self:GetTurretYaw(), AimAngles.y, AimRate )

	local DeltaPitch = Pitch - self:GetTurretPitch()
	local DeltaYaw = Yaw - self:GetTurretYaw()

	self:CalcTurretSound( DeltaPitch, DeltaYaw, AimRate )

	self:SetTurretPitch( Pitch )
	self:SetTurretYaw( Yaw )

	self:SetPoseParameter("turret_pitch", self:GetTurretPitch() )
	self:SetPoseParameter("turret_yaw", self:GetTurretYaw() )
end

function ENT:OnTick()
	self:AimTurret()
end
