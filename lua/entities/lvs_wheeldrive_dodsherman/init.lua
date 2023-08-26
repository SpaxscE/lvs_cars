AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "sh_tracks.lua" )
include("shared.lua")
include("sh_turret.lua")
include("sh_tracks.lua")

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

	self:AddEngine( Vector(-79.66,0,72.21) )
	self:AddFuelTank( Vector(-75,0,20), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL, Vector(-10,-30,0),Vector(10,30,40) )

	self:CreateTracks()

	-- front upper wedge
	self:AddArmor( Vector(90,0,60), Angle(30,0,0), Vector(-40,-45,-15), Vector(25,45,-2), 1500, 120000 )

	-- front lower wedge
	self:AddArmor( Vector(105,0,30), Angle(-45,0,0), Vector(-10,-45,-15), Vector(15,45,10), 750, 120000 )

	-- side armor
	self:AddArmor( Vector(0,45,20), Angle(0,0,0), Vector(-100,-15,-20), Vector(120,15,55), 750, 80000 )
	self:AddArmor( Vector(0,-45,20), Angle(0,0,0), Vector(-100,-15,-20), Vector(120,15,55), 750, 80000 )

	-- roof
	self:AddArmor( Vector(0,0,68), Angle(-3,0,0), Vector(-105,-45,0), Vector(55,45,10), 2000 )

	-- turret
	self:AddArmor( Vector(1.5,0,70), Angle(0,0,0), Vector(-50,-40,0), Vector(40,40,40), 2000, 150000 )

	-- rear
	self:AddArmor( Vector(-90,0,20), Angle(-15,0,0), Vector(-10,-30,-5),Vector(10,30,50), 250 )

	-- driver viewport weakstop
	self:AddDriverViewPort( Vector(90,21,58), Angle(0,0,0), Vector(-2,-7,-2), Vector(2,7,2) )
end
