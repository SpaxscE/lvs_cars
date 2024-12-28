AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

-- code relies on this forward angle...
ENT.ForcedForwardAngle = Angle(0,0,0)

ENT.TippingForceMul = 1

ENT.LeanAngleIdle = -10
ENT.LeanAnglePark = -10

function ENT:PhysicsSimulateOverride( ForceAngle, phys, deltatime, simulate )
	if self._IsDismounted then

		local Pod = self:GetDriverSeat()

		if IsValid( Pod ) then
			local Gravity = self:GetWorldUp() * self:GetWorldGravity() * phys:GetMass() * deltatime
			phys:ApplyForceCenter( Gravity * 1.5 * self.TippingForceMul )
			phys:ApplyForceOffset( -Gravity * 3 * self.TippingForceMul, Pod:GetPos() )
		end

		return vector_origin, vector_origin, SIM_NOTHING
	end

	local Steer = self:GetSteer()

	local VelL = self:WorldToLocal( self:GetPos() + phys:GetVelocity() )

	local ShouldIdle = self:ShouldPutFootDown()

	if ShouldIdle then
		Steer = self:GetEngineActive() and self.LeanAngleIdle or self.LeanAnglePark
		VelL.x = self.MaxVelocity
	end

	local Mul = (math.max( self:GetUp().z, 0 ) ^ 2) * 50 * (math.max( VelL.x / self.MaxVelocity, 0 ) ^ 2) * self.PhysicsWheelGyroMul
	local Diff = (Steer - self:GetAngles().r)

	ForceAngle.x = (Diff * 2.5 * self.PhysicsRollMul - phys:GetAngleVelocity().x * self.PhysicsDampingRollMul) * Mul

	if ShouldIdle and math.abs( Diff ) > 1 then
		simulate = SIM_GLOBAL_ACCELERATION
	end

	return ForceAngle, vector_origin, simulate
end

function ENT:CalcDismount( data, physobj )
	if self._IsDismounted then return end

	self._IsDismounted = true

	if self:GetEngineActive() then
		self:StopEngine()
	end

	local LocalSpeed = self:WorldToLocal( self:GetPos() + data.OurOldVelocity )

	for _, ply in pairs( self:GetEveryone() ) do
		if ply:GetNoDraw() then continue end

		ply:SetNoDraw( true )
		ply:SetAbsVelocity( LocalSpeed )
		ply:CreateRagdoll()
		ply:SetNWBool( "lvs_camera_follow_ragdoll", true )
		ply:lvsSetInputDisabled( true )

		timer.Simple( math.Rand(3.5,4.5), function()
			if not IsValid( ply ) then return end

			ply:SetNoDraw( false )
			ply:SetNWBool( "lvs_camera_follow_ragdoll", false)
			ply:lvsSetInputDisabled( false )

			local ragdoll = ply:GetRagdollEntity()

			if not IsValid( ragdoll ) then return end

			ragdoll:Remove()
		end)
	end

	timer.Simple(3, function()
		if not IsValid( self ) then return end

		self._IsDismounted = nil
	end)
end

function ENT:OnWheelCollision( data, physobj )
	local Speed = math.abs(data.OurOldVelocity:Length() - data.OurNewVelocity:Length())

	if Speed < 200 then return end

	local ent = physobj:GetEntity()

	local pos, ang = WorldToLocal( data.HitPos, angle_zero, ent:GetPos(), ent:GetDirectionAngle() )
	local radius = ent:GetRadius() - 2

	if Speed > 300 then
		if math.abs( pos.y ) > radius and self:GetUp().z < 0.5 then
			self:CalcDismount( data, physobj )
		end
	end

	if math.abs( pos.x ) < radius or pos.z < -1 then return end

	self:CalcDismount( data, physobj )
end

util.AddNetworkString( "lvs_kickstart_network" )

function ENT:ToggleEngine()
	if self:GetEngineActive() then
		self:StopEngine()

		self._KickStartAttemt = 0
	else
		if self.KickStarter and not self:GetAI() then
			local T = CurTime()

			if (self._KickStartTime or 0) > T then return end

			self:EmitSound( self.KickStarterSound, 70, 100, 0.5 )

			if not self._KickStartAttemt or ((T - (self.KickStarterStart or 0)) > (self.KickStarterAttemptsInSeconds or 0)) then
				self._KickStartAttemt = 0
				self.KickStarterStart = T
			end

			net.Start( "lvs_kickstart_network" )
				net.WriteEntity( self:GetDriver() )
			net.Broadcast()

			self._KickStartAttemt = self._KickStartAttemt + 1
			self._KickStartTime = T + self.KickStarterMinDelay

			if self._KickStartAttemt >= math.random( self.KickStarterMinAttempts, self.KickStarterMaxAttempts ) then
				self._KickStartAttemt = nil

				self:StartEngine()
			end
		else
			self:StartEngine()
		end
	end
end

function ENT:OnDriverEnterVehicle( ply )
	ply:SetCollisionGroup( COLLISION_GROUP_PLAYER )
end

function ENT:OnDriverExitVehicle( ply )
end
