AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_tankview.lua" )
AddCSLuaFile( "cl_attachable_playermodels.lua" )
include("shared.lua")

ENT.DSArmorDamageReductionType = DMG_CLUB
ENT.DSArmorIgnoreDamageType = DMG_BULLET + DMG_SONIC + DMG_ENERGYBEAM

function ENT:CreateWheelChain( wheels )
	if not istable( wheels ) then return end

	local Lock = 0.0001

	for i = 2, #wheels do
		local prev = wheels[ i - 1 ]
		local cur = wheels[ i ]

		if not IsValid( cur ) or not IsValid( prev ) then continue end

		local B = constraint.AdvBallsocket(prev,cur,0,0,vector_origin,vector_origin,0,0,-Lock,-180,-180,Lock,180,180,0,0,0,1,1)
		B.DoNotDuplicate = true

		local Rope = constraint.Rope(prev,cur,0,0,vector_origin,vector_origin,(prev:GetPos() - cur:GetPos()):Length(), 0, 0, 0,"cable/cable2", false)
		Rope.DoNotDuplicate = true
	end
end