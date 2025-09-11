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

	self:SetBodygroup( 4, 1 )
	local FlameThrower = self:AddFlameEmitter( self, "muzzle_zippo" )
	self.WPNFlameThrower = FlameThrower

	local DriverSeat = self:AddDriverSeat( Vector(0,0,60), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local GunnerSeat = self:AddPassengerSeat( Vector(88,-20,32), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = true
	self:SetGunnerSeat( GunnerSeat )

	self:AddEngine( Vector(-79.66,0,70), Angle(0,180,0) )
	self:AddFuelTank( Vector(-75,0,40), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL, Vector(0,-20,-18),Vector(18,20,18) )

	-- extra front plate left
	self:AddArmor( Vector(82,20.5,65), Angle(-36,0,0), Vector(-1.2,-11,-12), Vector(1.2,11,12), 1200, self.FrontArmorExtra )
	-- extra front plate right
	self:AddArmor( Vector(82,-20.5,65), Angle(-36,0,0), Vector(-1.2,-11,-12), Vector(1.2,11,12), 1200, self.FrontArmorExtra )

	-- front upper wedge
	self:AddArmor( Vector(70,0,66), Angle(0,0,0), Vector(-26,-48,-16), Vector(26,48,16), 1000, self.FrontArmor )

	-- transmission rib left
	self:AddArmor( Vector(102,12.6,35), Angle(0,0,0), Vector(-16,-1.5,-19), Vector(16,1.5,19), 1200, self.FrontArmorExtra )
	-- transmission rib right
	self:AddArmor( Vector(102,-11.8,35), Angle(0,0,0), Vector(-16,-1.5,-19), Vector(16,1.5,19), 1200, self.FrontArmorExtra )

	-- transmission
	self:AddArmor( Vector(110,1,34), Angle(0,0,0), Vector(-15,-32,-18), Vector(15,32,18), 1000, self.FrontArmor )

	-- extra ammo armor right front
	self:AddArmor( Vector(50,-51,63), Angle(0,0,0), Vector(-14,-1,-9), Vector(14,1,9), 1200, self.FrontArmorExtra )
	-- extra ammo armor right rear
	self:AddArmor( Vector(1,-51,63), Angle(0,0,0), Vector(-14,-1,-10), Vector(14,1,10), 1200, self.FrontArmorExtra )
	-- extra ammo armor left
	self:AddArmor( Vector(50,51,63), Angle(0,0,0), Vector(-14,-1,-9), Vector(14,1,9), 1200, self.FrontArmorExtra )

	-- rear down
	self:AddArmor( Vector(-85,0,34), Angle(0,0,0), Vector(-6,-29,-18), Vector(6,29,18), 800, self.SideArmor )
	-- rear up
	self:AddArmor( Vector(-105,0,63), Angle(0,0,0), Vector(-3,-48,-13), Vector(3,48,13), 800, self.SideArmor )
	-- rear top
	self:AddArmor( Vector(-69,0,66), Angle(0,0,0), Vector(-33,-48,-10), Vector(33,48,10), 600, self.RoofArmor )

	-- roof mid
	self:AddArmor( Vector(4,0,72), Angle(0,0,0), Vector(-40,-48,-4), Vector(40,48,4), 600, self.RoofArmor )

	-- turret neck
	self:AddArmor( Vector(2,0,79), Angle(0,0,0), Vector(-42,-44,-3), Vector(42,44,3), 1200, self.FrontArmorExtra )

	-- right up
	self:AddArmor( Vector(-6,-49,63), Angle(0,0,0), Vector(-102,-1,-13), Vector(102,1,13), 800, self.SideArmor )
	-- left up
	self:AddArmor( Vector(-6,49.5,63), Angle(0,0,0), Vector(-102,-1.5,-13), Vector(102,1.5,13), 800, self.SideArmor )

	-- right down
	self:AddArmor( Vector(2,-30,34), Angle(0,0,0), Vector(-93,-2,-18), Vector(93,2,18), 800, self.SideArmor )
	-- left down
	self:AddArmor( Vector(2,31,34), Angle(0,0,0), Vector(-93,-1,-18), Vector(93,1,18), 800, self.SideArmor )

	-- shelf
	self:AddArmor( Vector(-29,0,51), Angle(0,0,0), Vector(-73,-48,-1), Vector(73,48,1), 600, self.RoofArmor )
	-- bottom
	self:AddArmor( Vector(8,0,17), Angle(0,0,0), Vector(-87,-29,-1), Vector(87,29,1), 600, self.RoofArmor )

	-- turret
	local TurretArmor = self:AddArmor( Vector(2,0,95), Angle(0,0,0), Vector(-42,-44,-13), Vector(42,44,13), 1500, self.TurretArmor )
	TurretArmor:SetLabel( "Turret" )
	self:SetTurretArmor( TurretArmor )

	-- ammo rack weakspot
	self:AddAmmoRack( Vector(0,40,64), Vector(-5,0,70), Angle(0,0,0), Vector(-18,-6,-9), Vector(18,6,9) )
	self:AddAmmoRack( Vector(0,-40,64), Vector(-5,0,70), Angle(0,0,0), Vector(-18,-6,-9), Vector(18,6,9) )

	-- trailer hitch
	self:AddTrailerHitch( Vector(-100,0,24), LVS.HITCHTYPE_MALE )
end
