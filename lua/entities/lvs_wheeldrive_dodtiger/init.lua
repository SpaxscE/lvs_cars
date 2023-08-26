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
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/tiger/cannon_fire.wav", "lvs/vehicles/tiger/cannon_fire.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos - Muzzle.Ang:Up() * 140 - Muzzle.Ang:Forward() * 15 ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, ID )

	local DriverSeat = self:AddDriverSeat( Vector(0,0,60), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	self:AddEngine( Vector(-79.66,0,72.21) )
	self:AddFuelTank( Vector(-80,0,10), Angle(-15,0,0), 600, LVS.FUELTYPE_PETROL, Vector(-10,-40,0),Vector(10,40,60) )

	self:CreateTracks()

	-- front plate
	self:AddArmor( Vector(115,0,32), Angle(10,0,0), Vector(-20,-70,-20), Vector(20,70,20), 3000, 150000 )

	-- "windscreen"
	self:AddArmor( Vector(95,0,35), Angle(0,0,0), Vector(-15,-70,-30), Vector(10,70,40), 1500, 150000 )

	-- side armor
	self:AddArmor( Vector(0,50,20), Angle(0,0,0), Vector(-120,-15,-30), Vector(80,15,50), 1500, 150000 )
	self:AddArmor( Vector(0,-50,20), Angle(0,0,0), Vector(-120,-15,-30), Vector(80,15,50), 1500, 150000 )

	-- roof
	self:AddArmor( Vector(0,0,70), Angle(0,0,0), Vector(-110,-40,0), Vector(80,40,5), 4000 )

	-- turret
	self:AddArmor( Vector(4,0,70), Angle(0,0,0), Vector(-60,-60,0), Vector(60,60,40), 4000, 150000 )

	-- rear
	self:AddArmor( Vector(-100,0,10), Angle(-15,0,0), Vector(-10,-45,0),Vector(10,45,65), 500 )

	-- driver viewport weakstop
	self:AddDriverViewPort( Vector(105,21,55), Angle(0,0,0), Vector(-1,-7,-1), Vector(1,7,1) )
end
