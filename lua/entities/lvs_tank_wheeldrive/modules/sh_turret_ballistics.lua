
ENT.TurretBallisticsProjectileVelocity = 10000
ENT.TurretBallisticsMuzzleAttachment = "muzzle"
ENT.TurretBallisticsViewAttachment = "sight"

ENT.OpticsScreenCentered = true

function ENT:TurretSystemDT()
	self:AddDT( "Bool", "TurretEnabled" )
	self:AddDT( "Bool", "TurretDestroyed" )
	self:AddDT( "Entity", "TurretArmor" )
	self:AddDT( "Float", "TurretCompensation" )

	if SERVER then
		self:SetTurretEnabled( true )
		self:SetTurretPitch( self.TurretPitchOffset )
		self:SetTurretYaw( self.TurretYawOffset )
	end
end

function ENT:TurretUpdateBallistics( newvelocity, newmuzzle, newsight )
	if newvelocity then
		self.TurretBallisticsProjectileVelocity = newvelocity
	end

	if newmuzzle then
		self.TurretBallisticsMuzzleAttachment = newmuzzle
	end

	if newsight then
		self.TurretBallisticsViewAttachment = newsight
	end
end

local function GetTurretEyeTrace( base, weapon )
	local ID = base:LookupAttachment( base.TurretBallisticsViewAttachment )

	local Muzzle = base:GetAttachment( ID )

	if not Muzzle then return weapon:GetEyeTrace() end

	local startpos = Muzzle.Pos

	local pod = weapon:GetDriverSeat()

	if IsValid( pod ) and pod:GetThirdPersonMode() then
		if weapon == base then
			startpos = pod:LocalToWorld( pod:OBBCenter() )
		else
			startpos = weapon:GetPos()
		end
	end

	local data = {
		start = startpos,
		endpos = (startpos + weapon:GetAimVector() * 50000),
		filter = base:GetCrosshairFilterEnts(),
	}

	local trace = util.TraceLine( data )

	return trace
end

function ENT:CalcTurretAngles()
	local weapon = self:GetWeaponHandler( self.TurretPodIndex )

	if not IsValid( weapon ) or self:GetUp().z < 0.6 then return self:WorldToLocalAngles( weapon:GetAimVector():Angle() ) end

	local pod = weapon:GetDriverSeat()

	if IsValid( pod ) and pod:GetThirdPersonMode() then
		return self:WorldToLocalAngles( weapon:GetAimVector():Angle() )
	end

	local ID = self:LookupAttachment( self.TurretBallisticsMuzzleAttachment )

	local Muzzle = self:GetAttachment( ID )

	if not Muzzle then return self:WorldToLocalAngles( weapon:GetAimVector():Angle() ) end

	local MuzzlePos = Muzzle.Pos
	local MuzzleDir = Muzzle.Ang:Forward()
	local MuzzleAng = MuzzleDir:Angle()

	local AimPos = GetTurretEyeTrace( self, weapon ).HitPos

	local StartPos = MuzzlePos

	local ProjectileVelocity = self.TurretBallisticsProjectileVelocity
	local Dist = (AimPos - MuzzlePos):Length()

	local TimeAlive = Dist / ProjectileVelocity

	local OffsetPredicted = physenv.GetGravity() * (TimeAlive ^ 2)

	self:SetTurretCompensation( OffsetPredicted.z )

	local EndPos1 = AimPos - OffsetPredicted
	local EndPos2 = MuzzlePos + MuzzleDir

	local Dir1 = (EndPos1 - StartPos):GetNormalized()
	local Dir2 = (EndPos2 - StartPos):GetNormalized()

	local Pos, Ang = WorldToLocal( Muzzle.Pos, Dir1:Angle(), Muzzle.Pos, MuzzleAng )

	return Angle( self:GetTurretPitch() + Ang.p, self:GetTurretYaw() + Ang.y, 0 )
end

function ENT:AimTurret()
	if CLIENT then return end

	if not self:IsTurretEnabled() then self:StopTurretSound() self:StopTurretSoundDMG() return end

	local AimAngles = self:CalcTurretAngles()

	local AimRate = self.TurretAimRate * FrameTime() 

	if self:GetTurretDestroyed() then
		AimRate = AimRate * self.TurretRateDestroyedMul
	end

	local Pitch = math.Clamp( math.ApproachAngle( self:GetTurretPitch(), AimAngles.p, AimRate ), self.TurretPitchMin, self.TurretPitchMax )
	local Yaw = math.ApproachAngle( self:GetTurretYaw(), AimAngles.y, AimRate )

	if self.TurretYawMin and self.TurretYawMax then
		Yaw = math.Clamp( Yaw, self.TurretYawMin, self.TurretYawMax )
	end

	self:CalcTurretSound( Pitch, Yaw, AimRate )

	self:SetTurretPitch( Pitch )
	self:SetTurretYaw( Yaw )

	self:SetPoseParameter(self.TurretPitchPoseParameterName, self.TurretPitchOffset + self:GetTurretPitch() * self.TurretPitchMul )
	self:SetPoseParameter(self.TurretYawPoseParameterName, self.TurretYawOffset + self:GetTurretYaw() * self.TurretYawMul )
end
