AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_effects.lua" )
AddCSLuaFile( "cl_skidmarks.lua" )
include("shared.lua")
include("sv_axle.lua")
include("sv_brakes.lua")

function ENT:Initialize()
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:AddEFlags( EFL_NO_PHYSCANNON_INTERACTION )
end

function ENT:Think()
	return false
end

function ENT:OnRemove()
end

function ENT:OnTakeDamage( dmginfo )
	if dmginfo:IsDamageType( DMG_BLAST ) then return end

	local base = self:GetBase()

	if not IsValid( base ) then return end

	base:OnTakeDamage( dmginfo )
end

function ENT:lvsMakeSpherical( radius )
	if not radius or radius <= 0 then
		radius = (self:OBBMaxs() - self:OBBMins()) * 0.5
		radius = math.max( radius.x, radius.y, radius.z )
	end

	self:PhysicsInitSphere( radius, "jeeptire" )

	self:SetRadius( radius )

	self:DrawShadow( not self:GetHideModel() )
end

function ENT:PhysicsOnGround( PhysObj )
	if not PhysObj then
		PhysObj = self:GetPhysicsObject()
	end

	local EntLoad,_ = PhysObj:GetStress()

	return EntLoad > 0
end

function ENT:PhysicsCollide( data )
end