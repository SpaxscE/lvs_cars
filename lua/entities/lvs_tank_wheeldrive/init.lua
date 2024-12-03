AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

AddCSLuaFile( "modules/cl_tankview.lua" )
AddCSLuaFile( "modules/cl_attachable_playermodels.lua" )
AddCSLuaFile( "modules/sh_turret.lua" )
AddCSLuaFile( "modules/sh_turret_ballistics.lua" )
AddCSLuaFile( "modules/sh_turret_splitsound.lua" )

ENT.DSArmorDamageReductionType = DMG_CLUB
ENT.DSArmorIgnoreDamageType = DMG_BULLET + DMG_SONIC + DMG_ENERGYBEAM

function ENT:CreateWheelChain( wheels )
	if not istable( wheels ) then return end

	local Lock = 0.0001

	for _, wheel in pairs( wheels ) do
		if not IsValid( wheel ) then continue end

		wheel:SetWheelChainMode( true )
		wheel:SetDamageAllowed( true )
		wheel:SetWidth( 0 )
	end

	for i = 2, #wheels do
		local prev = wheels[ i - 1 ]
		local cur = wheels[ i ]

		if not IsValid( cur ) or not IsValid( prev ) then continue end

		local B = constraint.AdvBallsocket(prev,cur,0,0,vector_origin,vector_origin,0,0,-Lock,-180,-180,Lock,180,180,0,0,0,1,1)
		B.DoNotDuplicate = true

		local Rope = constraint.Rope(prev,cur,0,0,vector_origin,vector_origin,(prev:GetPos() - cur:GetPos()):Length(), 0, 0, 0,"cable/cable2", false)
		Rope.DoNotDuplicate = true
	end

	local WheelChain = {}

	WheelChain.OnDestroyed = function()
		for _, wheel in pairs( wheels ) do
			if not IsValid( wheel ) then continue end

			wheel:Destroy()
		end
	end

	WheelChain.OnRepaired = function()
		for _, wheel in pairs( wheels ) do
			if not IsValid( wheel ) then continue end

			wheel:Repair()
		end
	end

	return WheelChain
end

function ENT:AddAmmoRack( pos, fxpos, ang, mins, maxs )
	local AmmoRack = ents.Create( "lvs_wheeldrive_ammorack" )

	if not IsValid( AmmoRack ) then
		self:Remove()

		print("LVS: Failed to create fueltank entity. Vehicle terminated.")

		return
	end

	AmmoRack:SetPos( self:LocalToWorld( pos ) )
	AmmoRack:SetAngles( self:GetAngles() )
	AmmoRack:Spawn()
	AmmoRack:Activate()
	AmmoRack:SetParent( self )
	AmmoRack:SetBase( self )
	AmmoRack:SetEffectPosition( fxpos )

	self:DeleteOnRemove( AmmoRack )

	self:TransferCPPI( AmmoRack )

	mins = mins or Vector(-30,-30,-30)
	maxs = maxs or Vector(30,30,30)

	debugoverlay.BoxAngles( self:LocalToWorld( pos ), mins, maxs, self:LocalToWorldAngles( ang ), 15, Color( 255, 0, 0, 255 ) )

	self:AddDS( {
		pos = pos,
		ang = ang,
		mins = mins,
		maxs =  maxs,
		Callback = function( tbl, ent, dmginfo )
			if not IsValid( AmmoRack ) then return end

			AmmoRack:TakeTransmittedDamage( dmginfo )

			if AmmoRack:GetDestroyed() then return end

			local OriginalDamage = dmginfo:GetDamage()

			dmginfo:SetDamage( math.min( 2, OriginalDamage ) )
		end
	} )

	return AmmoRack
end
