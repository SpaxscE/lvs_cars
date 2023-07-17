AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_animations.lua" )
include("shared.lua")
include("sh_animations.lua")
include("sv_controls.lua")
include("sv_wheelsystem.lua")
include("sv_setupvehicle.lua")
include("sv_setupwheels.lua")

ENT.DriverActiveSound = "common/null.wav"
ENT.DriverInActiveSound = "common/null.wav"

DEFINE_BASECLASS( "lvs_base" )

function ENT:Initialize()
	self:InitFromList()

	BaseClass.Initialize( self )

	self:SetSolid( SOLID_NONE )

	self:SetupDriverSeat()
	self:SetupPassengerSeat()
	self:SetupPhysics()

	local PObj = self:GetPhysicsObject()

	timer.Simple( (self:SetupWheels() or 0), function()
		if not IsValid( self ) or not IsValid( PObj ) then print("LVS: ERROR couldn't initialize vehicle.") return end

		BaseClass.PostInitialize(self, PObj )

		self:SetSolid( SOLID_VPHYSICS )

		for _, Wheel in pairs( self:GetWheels() ) do
			if not IsValid( Wheel ) then print("LVS: ERROR couldn't initialize vehicle.") self:Remove() break end

			Wheel:SetSolid( SOLID_VPHYSICS )
		end
	end)
end

function ENT:AlignView( ply )
	if not IsValid( ply ) then return end

	timer.Simple( 0, function()
		if not IsValid( ply ) or not IsValid( self ) then return end
		local Ang = Angle(0,90,0)

		ply:SetEyeAngles( Ang )
	end)
end

function ENT:PostInitialize( PObj )
	-- prevent call of:
	-- self:OnSpawn( PObj )
	-- self:OnSpawnFinished( PObj )
end

function ENT:TakeCollisionDamage( damage, attacker )
end

function ENT:OnTick()
	for ID, Wheel in pairs( self:GetWheels() ) do
		local Master = Wheel:GetMaster()

		if not IsValid( Master ) then continue end

		local PhysObj = Master:GetPhysicsObject()

		if PhysObj:IsMotionEnabled() then PhysObj:EnableMotion( false ) continue end

		Wheel:PhysWake()

		local ID = Wheel:GetAxle()

		local Axle = self:GetAxleData( ID )

		local AxleAng = self:LocalToWorldAngles( Axle.ForwardAngle )

		local Camber, Caster, Toe = Wheel:GetAlignment()

		AxleAng:RotateAroundAxis( AxleAng:Right(), Caster * self:GetCaster() )
		AxleAng:RotateAroundAxis( AxleAng:Forward(), Camber * self:GetCamber() )
		AxleAng:RotateAroundAxis( AxleAng:Up(), Toe * self:GetToe() )

		if Axle.SteerType == LVS.WHEEL_STEER_REAR then
			AxleAng:RotateAroundAxis( AxleAng:Up(), self:GetSteer() * Axle.SteerAngle )
		else
			if Axle.SteerType == LVS.WHEEL_STEER_FRONT then
				AxleAng:RotateAroundAxis( AxleAng:Up(), -self:GetSteer() * Axle.SteerAngle )
			end
		end

		Master:SetAngles( AxleAng )
	end
end

function ENT:PhysicsSimulate( phys, deltatime )
	--phys:Wake()

	return vector_origin, vector_origin, SIM_NOTHING
end