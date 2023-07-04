AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_animations.lua" )
include("shared.lua")
include("sh_animations.lua")
include("sv_controls.lua")
include("sv_wheelsystem.lua")

ENT.DriverActiveSound = "common/null.wav"
ENT.DriverInActiveSound = "common/null.wav"

function ENT:OnSpawn( PObj )
	PObj:SetMass( 1000 )

	self:AddDriverSeat( Vector(-14,14.94,-6), Angle(0,-90,7.8) )
	self:AddPassengerSeat( Vector(-3,-14.94,3), Angle(0,-90,20) )

	local WheelModel = "models/sprops/trans/wheel_a/t_wheel25.mdl"

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT, --LVS.WHEEL_STEER_REAR   LVS.WHEEL_STEER_NONE
			SteerAngle = 35,
		},
		Wheels = {
			self:AddWheel( Vector(50.814,-29,0), Angle(0,-90,0), WheelModel ),
			self:AddWheel( Vector(50.814,29,0), Angle(0,90,0), WheelModel ),
		},
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )

	local RearAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
		},
		Wheels = {
			self:AddWheel( Vector(-50.814,-29,0), Angle(0,-90,0), WheelModel ),
			self:AddWheel( Vector(-50.814,29,0), Angle(0,90,0), WheelModel ),
		},
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )
end

function ENT:OnSpawnFinish( PObj )
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

function ENT:OnCollision( data, physobj )
	if not self._CollisionIgnoreBelow then return end

	if self:WorldToLocal( data.HitPos ).z < self._CollisionIgnoreBelow then return true end

	return
end

function ENT:PhysicsSimulate( phys, deltatime )
	--[[
	local base = phys:GetEntity()

	if not IsValid( base ) or not base.lvsWheel then return VectorZero, VectorZero, SIM_NOTHING end

	phys:Wake()

	local Pos = phys:GetPos()

	local Vel = phys:GetVelocity()
	local VelForward = Vel:GetNormalized()

	local VelL = phys:WorldToLocal( Pos + Vel )
	local data = base:GetAxleData()
	local Axle = data.Axle
	local SteerType = Axle.SteerType

	local ModelRadius = base:GetOBBRadius()
	local WheelRadius = base:GetRadius()

	local Ang = self:LocalToWorldAngles( Axle.ForwardAngle )

	if SteerType >= LVS.WHEEL_STEER_FRONT then
		local Swap = (LVS.WHEEL_STEER_FRONT == SteerType) and -1 or 1

		Ang:RotateAroundAxis( Ang:Up(), self:GetSteer() * Axle.SteerAngle * Swap )
	end

	local Forward = Ang:Forward()
	local Right = Ang:Right()
	local Up = Ang:Up()

	local IsRayCast = WheelRadius > ModelRadius

	local Len = IsRayCast and WheelRadius or ModelRadius + HullSize
	local HullSize = IsRayCast and VectorZero or HullVector

	local trace = util.TraceHull( {
		start = Pos,
		endpos = Pos - Up * Len,
		maxs = HullSize,
		mins = -HullSize,
		filter = function( entity )
			if self:GetCrosshairFilterLookup()[ entity:EntIndex() ] or entity:IsPlayer() or entity:IsNPC() or entity:IsVehicle() or self.CollisionFilter[ entity:GetCollisionGroup() ] then
				return false
			end

			return true
		end,
	} )

	local HitPos = trace.HitPos
	local WheelLoad = math.Clamp( (1 - trace.Fraction) * Len,0,1.5)

	local Ax = math.acos( math.Clamp( Forward:Dot(VelForward) ,-1,1) )
	local Ay = math.asin( math.Clamp( Right:Dot(VelForward) ,-1,1) )

	if IsValid( trace.Entity ) then
		local EntVel = trace.Entity:GetVelocity()
		WheelRadius = WheelRadius + math.max( EntVel.z, 0 ) * deltatime * 7
	end

	local fUp = ((HitPos + trace.HitNormal * WheelRadius - Pos) * 100 - Vel * 10) * 5 * WheelLoad
	local aUp = math.acos( math.Clamp( Up:Dot( fUp:GetNormalized() ) ,-1,1) )

	local F = Vel:Length()
	local Fx = math.cos( Ax ) * F
	local Fy = math.sin( Ay ) * F
	local Fz = IsRayCast and math.cos( aUp ) * fUp:Length() or 0

	local ForceLinear = Up * Fz + (Right * -Fy * 25 + Forward * -Fx) * WheelLoad

	return VectorZero, ForceLinear, SIM_GLOBAL_ACCELERATION
	]]
end
