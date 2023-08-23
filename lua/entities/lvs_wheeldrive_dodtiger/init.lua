AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "sh_tracks.lua" )
include("shared.lua")
include("sh_turret.lua")
include("sh_tracks.lua")

function ENT:OnSpawn( PObj )
	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/cannon_fire1.wav", "lvs/vehicles/sherman/cannon_fire2.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )


	self:AddDriverSeat( Vector(0,0,60), Angle(0,-90,0) )

	self:AddEngine( Vector(-79.66,0,72.21) )

	self:CreateTracks()
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/tiger/engine_start.wav" )
	else
		self:EmitSound( "lvs/vehicles/tiger/engine_stop.wav" )
	end
end