
if CLIENT then
	function ENT:CalcTurret()
		local pod = self:GetDriverSeat()

		if not IsValid( pod ) then return end

		local plyL = LocalPlayer()
		local ply = pod:GetDriver()

		if ply ~= plyL then return end

		self:AimTurret()
	end
else
	function ENT:OnTick()
		self:AimTurret()
	end
end

function ENT:AimTurret()
	local AimAngles = self:WorldToLocalAngles( self:GetAimVector():Angle() )

	self:SetPoseParameter("turret_pitch", -AimAngles.p )
	self:SetPoseParameter("turret_yaw", AimAngles.y - 90 )
end
