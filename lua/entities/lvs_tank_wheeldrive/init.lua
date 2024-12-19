AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")
include("sv_tracksystem.lua")

AddCSLuaFile( "modules/cl_tankview.lua" )
AddCSLuaFile( "modules/cl_attachable_playermodels.lua" )
AddCSLuaFile( "modules/sh_turret.lua" )
AddCSLuaFile( "modules/sh_turret_ballistics.lua" )
AddCSLuaFile( "modules/sh_turret_splitsound.lua" )

ENT.DSArmorDamageReductionType = DMG_CLUB
ENT.DSArmorIgnoreDamageType = DMG_BULLET + DMG_SONIC + DMG_ENERGYBEAM

function ENT:AddAmmoRack( pos, fxpos, ang, mins, maxs, target )
	local AmmoRack = ents.Create( "lvs_wheeldrive_ammorack" )

	if not IsValid( AmmoRack ) then
		self:Remove()

		print("LVS: Failed to create fueltank entity. Vehicle terminated.")

		return
	end

	if not target then target = self end

	AmmoRack:SetPos( target:LocalToWorld( pos ) )
	AmmoRack:SetAngles( target:GetAngles() )
	AmmoRack:Spawn()
	AmmoRack:Activate()
	AmmoRack:SetParent( target )
	AmmoRack:SetBase( self )
	AmmoRack:SetEffectPosition( fxpos )

	self:DeleteOnRemove( AmmoRack )

	self:TransferCPPI( AmmoRack )

	mins = mins or Vector(-30,-30,-30)
	maxs = maxs or Vector(30,30,30)

	debugoverlay.BoxAngles( target:LocalToWorld( pos ), mins, maxs, target:LocalToWorldAngles( ang ), 15, Color( 255, 0, 0, 255 ) )

	self:AddDS( {
		pos = pos,
		ang = ang,
		mins = mins,
		maxs =  maxs,
		entity = target,
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
