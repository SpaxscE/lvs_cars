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
	local ID = self:LookupAttachment( "machinegun" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMGf = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
	self.SNDTurretMGf:SetSoundLevel( 95 )
	self.SNDTurretMGf:SetParent( self, ID )

	local ID = self:LookupAttachment( "turret_machinegun" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, ID )

	local ID = self:LookupAttachment( "turret_cannon" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/cannon_fire.wav", "lvs/vehicles/sherman/cannon_fire.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	local DriverSeat = self:AddDriverSeat( Vector(0,0,60), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local GunnerSeat = self:AddPassengerSeat( Vector(88,-20,32), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = true
	self:SetGunnerSeat( GunnerSeat )

	self:AddEngine( Vector(-79.66,0,70), Angle(0,180,0) )
	self:AddFuelTank( Vector(-75,0,20), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL, Vector(-10,-30,0),Vector(10,30,40) )

	-- front upper wedge
	self:AddArmor( Vector(90,0,60), Angle(30,0,0), Vector(-40,-55,-15), Vector(25,55,-2), 1200, self.FrontArmor )

	-- front lower wedge
	self:AddArmor( Vector(105,0,30), Angle(-45,0,0), Vector(-10,-55,-15), Vector(15,55,10), 1200, self.FrontArmor )

	-- front bottom wedge
	self:AddArmor( Vector(110,0,22), Angle(-10,0,0), Vector(-40,-55,-10), Vector(0,55,10), 1200, self.FrontArmor )

	-- front side wedge
	self:AddArmor( Vector(40,45,85), Angle(30,0,0), Vector(0,-15,-35), Vector(80,15,0), 500, self.FrontArmor )
	self:AddArmor( Vector(40,-45,85), Angle(30,0,0), Vector(0,-15,-35), Vector(80,15,0), 500, self.FrontArmor )

	-- side armor
	self:AddArmor( Vector(40,45,40), Angle(0,0,0), Vector(-150,-15,0), Vector(10,15,40), 500, self.SideArmor )
	self:AddArmor( Vector(40,-45,40), Angle(0,0,0), Vector(-150,-15,0), Vector(10,15,40), 500, self.SideArmor )

	-- turret
	self:AddArmor( Vector(1.5,0,70), Angle(0,0,0), Vector(-50,-40,0), Vector(40,40,40), 1500, self.TurretArmor )

	-- rear
	self:AddArmor( Vector(-90,0,20), Angle(-15,0,0), Vector(-10,-30,-5),Vector(10,30,50), 500, self.RearArmor )

	-- driver viewport weakspot
	self:AddDriverViewPort( Vector(90,21,58), Angle(0,0,0), Vector(-2,-7,-2), Vector(2,7,2) )

	-- ammo rack weakspot
	self:AddAmmoRack( Vector(-5,0,70), Angle(0,0,0), Vector(-15,-30,-15), Vector(0,30,0) )
end
