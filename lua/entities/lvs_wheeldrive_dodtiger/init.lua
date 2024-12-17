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
	self:AddFuelTank( Vector(-80,0,60), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL, Vector(-12,-50,-12),Vector(12,50,0) )

	-- turret
	local TurretArmor = self:AddArmor( Vector(0,0,88), Angle(0,0,0), Vector(-52,-52,-18), Vector(52,52,18), 4000, self.TurretArmor )
	TurretArmor:SetLabel( "Turret" )
	self:SetTurretArmor( TurretArmor )

	-- front upper plate
	self:AddArmor( Vector(105,0,62), Angle(0,0,0), Vector(-8,-65,-12), Vector(8,65,12), 4000, self.FrontArmor )

	-- front mid plate
	self:AddArmor( Vector(122,0,49), Angle(8,0,0), Vector(-10,-37,-1), Vector(10,37,1), 1200, self.RearArmor )

	-- front lower plate
	self:AddArmor( Vector(127,0,35), Angle(-67,0,0), Vector(-15,-37,-1), Vector(15,37,1), 4000, self.FrontArmor )

	-- front bottom plate
	self:AddArmor( Vector(111,0,18), Angle(-22,0,0), Vector(-11,-37,-1), Vector(11,37,1), 500, self.RoofArmor )

	--left up
	self:AddArmor( Vector(-8,64,56), Angle(0,0,0), Vector(-105,-1,-18), Vector(105,1,18), 1600, self.SideArmor )
	--right up
	self:AddArmor( Vector(-8,-64,56), Angle(0,0,0), Vector(-105,-1,-18), Vector(105,1,18), 1600, self.SideArmor )

	--left down
	self:AddArmor( Vector(12,37,35), Angle(0,0,0), Vector(-120,-1,-22), Vector(120,1,22), 1200, self.RearArmor )
	--right down
	self:AddArmor( Vector(12,-37,35), Angle(0,0,0), Vector(-120,-1,-22), Vector(120,1,22), 1200, self.RearArmor )

	-- rear
	self:AddArmor( Vector(-105,0,42), Angle(0,0,0), Vector(-8,-65,-29), Vector(8,65,29), 1600, self.SideArmor )

	--top
	self:AddArmor( Vector(0,0,69), Angle(0,0,0), Vector(-97,-63,-1), Vector(97,63,1), 500, self.RoofArmor )
	--bottom
	self:AddArmor( Vector(2,0,14), Angle(0,0,0), Vector(-99,-36,-1), Vector(99,36,1), 500, self.RoofArmor )

	-- hole
	self:AddArmor( Vector(82,0,52), Angle(0,0,0), Vector(-15,-63,-2), Vector(15,63,2), 500, self.RoofArmor )

	-- ammo rack weakspot
	self:AddAmmoRack( Vector(0,50,55), Vector(0,0,65), Angle(0,0,0), Vector(-54,-12,-6), Vector(54,12,6) )
	self:AddAmmoRack( Vector(0,-50,55), Vector(0,0,65), Angle(0,0,0), Vector(-54,-12,-6), Vector(54,12,6) )
	self:AddAmmoRack( Vector(0,30,30), Vector(0,0,65), Angle(0,0,0), Vector(-30,-6,-12), Vector(30,6,12) )
	self:AddAmmoRack( Vector(0,-30,30), Vector(0,0,65), Angle(0,0,0), Vector(-30,-6,-12), Vector(30,6,12) )

	-- trailer hitch
	self:AddTrailerHitch( Vector(-112,0,22), LVS.HITCHTYPE_MALE )
end
