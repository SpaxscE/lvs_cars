AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_tracks.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_optics.lua" )
AddCSLuaFile( "cl_tankview.lua" )
include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")

function ENT:OnSpawn( PObj )
	local ID = self:LookupAttachment( "muzzle_machinegun" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMGf = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
	self.SNDTurretMGf:SetSoundLevel( 95 )
	self.SNDTurretMGf:SetParent( self, ID )

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

	local GunnerSeat = self:AddPassengerSeat( Vector(103,-24,41), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = true
	self:SetGunnerSeat( GunnerSeat )

	self:AddEngine( Vector(-79.66,0,72.21), Angle(0,180,0) )
	self:AddFuelTank( Vector(-80,0,10), Angle(-15,0,0), 600, LVS.FUELTYPE_PETROL, Vector(-10,-40,0),Vector(10,40,60) )

	-- front plate
	self:AddArmor( Vector(115,0,32), Angle(10,0,0), Vector(-20,-70,-20), Vector(20,70,20), 4000, self.FrontArmor )

	-- "windscreen"
	self:AddArmor( Vector(95,0,35), Angle(0,0,0), Vector(-15,-70,-30), Vector(10,70,40), 3000, self.FrontArmor )

	-- side armor
	self:AddArmor( Vector(0,50,30), Angle(0,0,0), Vector(-120,-15,0), Vector(80,15,45), 1500, self.SideArmor )
	self:AddArmor( Vector(0,-50,30), Angle(0,0,0), Vector(-120,-15,0), Vector(80,15,45), 1500, self.SideArmor )

	-- turret
	self:AddArmor( Vector(4,0,70), Angle(0,0,0), Vector(-60,-60,0), Vector(60,60,40), 3000, self.TurretArmor )

	-- rear
	self:AddArmor( Vector(-100,0,10), Angle(-15,0,0), Vector(-10,-45,0),Vector(10,45,65), 500, self.RearArmor )

	-- driver viewport weakspot
	self:AddDriverViewPort( Vector(105,21,55), Angle(0,0,0), Vector(-1,-7,-1), Vector(1,7,1) )

	-- ammo rack weakspot
	self:AddAmmoRack( Vector(0,0,75), Angle(0,0,0), Vector(-15,-30,-20), Vector(15,30,20) )
end
