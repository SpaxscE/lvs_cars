AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_animations.lua" )
AddCSLuaFile( "sh_collisionfilter.lua" )
include("shared.lua")
include("sh_animations.lua")
include("sv_controls.lua")
include("sh_collisionfilter.lua")
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
