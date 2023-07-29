AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_animations.lua" )
AddCSLuaFile( "sh_collisionfilter.lua" )
include("shared.lua")
include("sh_animations.lua")
include("sv_controls.lua")
include("sh_collisionfilter.lua")
include("sv_components.lua")
include("sv_workarounds.lua")
include("sv_wheelsystem.lua")

ENT.DriverActiveSound = "common/null.wav"
ENT.DriverInActiveSound = "common/null.wav"

function ENT:OnSpawnFinish( PObj )
	self:SetMassCenter( Vector(0,0,5) )

	timer.Simple(0, function()
		if not IsValid( self ) or not IsValid( PObj ) then return end

		if GetConVar( "developer" ):GetInt() ~= 1 then
			PObj:EnableMotion( true )
		end

		self:SetSolid( SOLID_VPHYSICS )
		self:PhysWake()

		for _, Wheel in pairs( self:GetWheels() ) do
			Wheel:SetSolid( SOLID_VPHYSICS )
			self:AddToMotionController( Wheel:GetPhysicsObject() )
		end
	end )
end

function ENT:AlignView( ply )
	if not IsValid( ply ) then return end

	timer.Simple( 0, function()
		if not IsValid( ply ) or not IsValid( self ) then return end
		local Ang = Angle(0,90,0)

		ply:SetEyeAngles( Ang )
	end)
end

function ENT:TakeCollisionDamage( damage, attacker )
end

function ENT:GetVelocityDifference( AngleDirection )
	if not isangle( AngleDirection ) then return vector_origin end

	local Forward = AngleDirection:Forward()

	local Velocity = self:GetVelocity()
	local VelForward = Velocity:GetNormalized()

	local Throttle = math.max( self:GetThrottle(), 0 )

	local TargetVelocity = self.MaxVelocity * self:Sign( Throttle )

	local Force = math.min( math.max( (TargetVelocity - math.cos( math.acos( math.Clamp( Forward:Dot( VelForward ) ,-1,1) ) ) * Velocity:Length()) * 2 * self.TorqueCurveMultiplier * Throttle, 0 ), self.MaxVelocity )

	return Force
end

function ENT:PhysicsSimulate( phys, deltatime )
	local base = phys:GetEntity()

	if not IsValid( base ) or not base.lvsWheel then return vector_origin, vector_origin, SIM_NOTHING end

	phys:Wake()

	local Pos = phys:GetPos()

	local Vel = phys:GetVelocity()
	local VelForward = Vel:GetNormalized()

	local VelL = phys:WorldToLocal( Pos + Vel )
	local data = base:GetAxleData()
	local Axle = data.Axle
	local SteerType = Axle.SteerType

	local WheelRadius = base:GetRadius()

	local Ang = self:LocalToWorldAngles( Axle.ForwardAngle )

	local Force = self:GetVelocityDifference( Ang )

	if SteerType >= LVS.WHEEL_STEER_FRONT then
		local Swap = (LVS.WHEEL_STEER_FRONT == SteerType) and -1 or 1

		Ang:RotateAroundAxis( Ang:Up(), self:GetSteerPercent() * Axle.SteerAngle * Swap )
	end

	local Right = Ang:Right()
	local Up = Ang:Up()

	local trace = util.TraceLine( {
		start = Pos,
		endpos = Pos - Up * WheelRadius,
		filter = function( entity )
			if self:GetCrosshairFilterLookup()[ entity:EntIndex() ] or entity:IsPlayer() or entity:IsNPC() or entity:IsVehicle() or self.CollisionFilter[ entity:GetCollisionGroup() ] then
				return false
			end

			return true
		end,
	} )

	local Forward = trace.HitNormal:Angle()
	Forward:RotateAroundAxis( Ang:Right(), -90 )
	Forward = Forward:Forward()

	local HitPos = trace.HitPos

	local PhysicsTraceFraction = 1 - (trace.Fraction * (WheelRadius + 1) - WheelRadius)
	local PhysicsLoad = PhysicsTraceFraction > 0 and (math.min( PhysicsTraceFraction, 0.7 ) + PhysicsTraceFraction / 10) or 0

	local Ax = math.acos( math.Clamp( Forward:Dot(VelForward) ,-1,1) )
	local Ay = math.asin( math.Clamp( Right:Dot(VelForward) ,-1,1) )

	if IsValid( trace.Entity ) then
		local EntVel = trace.Entity:GetVelocity()

		WheelRadius = WheelRadius + math.max( EntVel.z, 0 ) * deltatime * 7
	end

	local fUp = ((HitPos + trace.HitNormal * WheelRadius - Pos) * 100 - Vel * 10) * 5 * PhysicsLoad
	local aUp = math.acos( math.Clamp( Up:Dot( fUp:GetNormalized() ) ,-1,1) )

	local F = Vel:Length()
	local Fx = math.cos( Ax ) * F
	local Fy = math.sin( Ay ) * F
	local Fz = math.cos( aUp ) * fUp:Length()

	local MaxGrip = 250 * PhysicsLoad ^ 10

	local ForceLinear = Up * Fz

	if trace.Hit then
		ForceLinear = ForceLinear + Right * math.Clamp(-Fy,-MaxGrip,MaxGrip) * 25 + Forward * Force * Axle.TorqueFactor * self.TorqueMultiplier
	end

	return vector_origin, ForceLinear, SIM_GLOBAL_ACCELERATION
end
