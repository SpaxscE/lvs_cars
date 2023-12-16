AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_tracks.lua" )
AddCSLuaFile( "cl_tankview.lua" )
AddCSLuaFile( "cl_attached_playermodels.lua" )
include("shared.lua")
include("sh_tracks.lua")

-- since this is based on a tank we need to reset these to default var values:
ENT.DSArmorDamageReductionType = DMG_BULLET + DMG_CLUB
ENT.DSArmorIgnoreDamageType = DMG_SONIC


function ENT:OnSpawn( PObj )

	local ID = self:LookupAttachment( "f_muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMGf = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ),  "lvs/vehicles/sdkfz250/mg_loop.wav"  )
	self.SNDTurretMGf:SetSoundLevel( 95 )
	self.SNDTurretMGf:SetParent( self, ID )

	local ID = self:LookupAttachment( "r_muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMGt = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ),  "lvs/vehicles/sdkfz250/mg_loop.wav"  )
	self.SNDTurretMGt:SetSoundLevel( 95 )
	self.SNDTurretMGt:SetParent( self, ID )

	local DriverSeat = self:AddDriverSeat( Vector(-10,16,15), Angle(0,-90,0) )
	local GunnerSeat = self:AddPassengerSeat( Vector(-30,0,25), Angle(0,-90,0) )
	local TopGunnerSeat = self:AddPassengerSeat( Vector(-40,0,25), Angle(0,90,0) )
	local PassengerSeat = self:AddPassengerSeat( Vector(0,-16,22), Angle(0,-90,10) )
	local PassengerSeat = self:AddPassengerSeat( Vector(-43,-14,24), Angle(0,-90,10) )
	local PassengerSeat = self:AddPassengerSeat( Vector(-50,14,32), Angle(0,180,0) )
	local PassengerSeat = self:AddPassengerSeat( Vector(-35,14,32), Angle(0,180,0) )
	local PassengerSeat = self:AddPassengerSeat( Vector(-20,14,32), Angle(0,180,0) )

	self:SetFrontGunnerSeat( GunnerSeat )
	self:SetRearGunnerSeat( TopGunnerSeat )

	GunnerSeat.HidePlayer = true
	TopGunnerSeat.HidePlayer = true

	local DoorHandler = self:AddDoorHandler( "trunk", Vector(-81.17,11.74,44.44), Angle(19,0,0), Vector(-1,-15,-15), Vector(1,15,15), Vector(-30,-15,-15), Vector(1,15,15) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "hatch", Vector(53.89,0.17,47.28), Angle(-80,0,0), Vector(-1,-15,-15), Vector(1,15,15), Vector(-30,-15,-15), Vector(1,15,15) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

	local DoorHandler = self:AddDoorHandler( "!hatch1", Vector(9.55,13.84,55.75), Angle(0,0,0), Vector(-3,-10,-3), Vector(3,10,3), Vector(-3,-10,-3), Vector(3,10,3) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

	local DoorHandler = self:AddDoorHandler( "!hatch2", Vector(9.55,-13.84,55.75), Angle(0,0,0), Vector(-3,-10,-3), Vector(3,10,3), Vector(-3,-10,-3), Vector(3,10,3) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

	self:AddEngine( Vector(50,0,45) )
	self:AddFuelTank( Vector(55,0,18), Angle(0,0,0), 600, LVS.FUELTYPE_DIESEL )

	self.SNDTurretMG = self:AddSoundEmitter( Vector(-63,0,85), "lvs/vehicles/halftrack/mc_loop.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )

	local WheelModel = "models/diggercars/sdkfz250/250_wheel.mdl"

	local FLWheel = self:AddWheel( { pos = Vector(67,32,16.5), mdl = WheelModel, mdl_ang = Angle(0,0,0), width = 2 } )
	local FRWheel = self:AddWheel( { pos = Vector(67,-32,16.5), mdl = WheelModel, mdl_ang = Angle(0,180,0), width = 2} )

	self:CreateRigControler( "fl", FLWheel, 10, 17.7 )
	self:CreateRigControler( "fr", FRWheel, 10, 17.7 )

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
			TorqueFactor = 0.5,
			BrakeFactor = 1,
		},
		Wheels = { FLWheel, FRWheel },
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )
	self:AddTrailerHitch( Vector(-92.9,-0.04,23.19), LVS.HITCHTYPE_MALE )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/sdkfz250/engine_start.wav" )
	end
end
