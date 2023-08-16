AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:CreateWheelChain( wheels )
	if not istable( wheels ) then return end

	
	local Lock = 0.0001

	for i = 2, #wheels do
		local prev = wheels[ i - 1 ]
		local cur = wheels[ i ]

		if not IsValid( cur ) or not IsValid( prev ) then continue end

		local B = constraint.AdvBallsocket(prev,cur,0,0,vector_origin,vector_origin,0,0,-Lock,-180,-180,Lock,180,180,0,0,0,1,1)
		B.DoNotDuplicate = true
	end
end