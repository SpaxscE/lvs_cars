AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_tracks.lua" )
AddCSLuaFile( "sh_turret.lua" )
include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(0,-20,30), Angle(0,0,0) )
	DriverSeat.HidePlayer = true

	self:AddEngine( Vector(0,0,50) )

	self:CreateTracks()

	self.SNDTurret = self:AddSoundEmitter( Vector(0,-20,30), "npc/combine_gunship/gunship_fire_loop1.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
end
