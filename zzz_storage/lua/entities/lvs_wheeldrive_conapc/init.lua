AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_prediction.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(0,30,20), Angle(0,0,0) )
	local PassengerSeat = self:AddPassengerSeat( Vector(-15,-20,25), Angle(0,180,0) )
	local PassengerSeat1 = self:AddPassengerSeat( Vector(-10,0,50), Angle(0,0,0) )

	self:AddEngine( Vector(-16.1,-81.68,47.25) )

	local DoorHandler = self:AddDoorHandler( "right_door", Vector(30,0,55), Angle(0,90,0), Vector(-10,-6,-20), Vector(18,6,14), Vector(-40,-6,-20), Vector(18,6,14) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/classiccar_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "left_door", Vector(-30,-30,50), Angle(0,100,0), Vector(-7,-2,-20), Vector(18,2,14), Vector(-7,-2,-20), Vector(38,2,14) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/classiccar_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat )

	local DoorHandler = self:AddDoorHandler( "h1", Vector(-3,53.77,68.94), Angle(0,0,-70), Vector(-13,0,-3), Vector(18,15,3), Vector(-13,0,-3), Vector(18,15,3) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/classiccar_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )

	local DoorHandler = self:AddDoorHandler( "mid_door", Vector(3,-23,78.94), Angle(180,0,-60), Vector(-15,-10,-3), Vector(20,18,3), Vector(-15,-10,-3), Vector(20,18,3) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/classiccar_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat1 )

	local DoorHandler = self:AddDoorHandler( "h5", Vector(10,-30,68.94), Angle(180,0,-70), Vector(-20,-10,-3), Vector(10,0,3), Vector(-20,-10,-3), Vector(10,0,3) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/classiccar_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )

	local DoorHandler = self:AddDoorHandler( "h4", Vector(-20,-30,68.94), Angle(180,0,-70), Vector(-18,-10,-3), Vector(7,0,3), Vector(-18,-10,-3), Vector(7,0,3) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/classiccar_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )

	local DoorHandler = self:AddDoorHandler( "h6", Vector(10,6,95), Angle(0,0,0), Vector(-18,-20,-3), Vector(7,10,3), Vector(-18,-20,-3), Vector(7,10,3) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/classiccar_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )

	local DoorHandler = self:AddDoorHandler( "h7", Vector(-10,-60,57), Angle(180,-90,-10), Vector(-26,-15,-5), Vector(15,10,5), Vector(-26,-15,-5), Vector(15,30,5) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/classiccar_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )

	local DoorHandler = self:AddDoorHandler( "h2", Vector(20,53.77,53), Angle(0,90,90), Vector(-13,0,-3), Vector(0,15,3), Vector(-13,0,-3), Vector(0,15,3) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/classiccar_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )

	local DoorHandler = self:AddDoorHandler( "h3", Vector(-20,53.77,53), Angle(0,90,90), Vector(-13,0,-3), Vector(0,15,3), Vector(-13,0,-3), Vector(0,15,3) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/classiccar_door_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/classiccar_door_close.wav" )

	local WheelModel = "models/diggercars/amd35/amd_wheel.mdl"

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,90,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
			TorqueFactor = 0.5,
			BrakeFactor = 1,
		},
		Wheels = {
			self:AddWheel( {
				width = 15,
				pos = Vector(-32,63,25),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),

			self:AddWheel( {
				width = 15,
				pos = Vector(32,63,25),
				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),
			} ),
		},
		Suspension = {
			Height = 20,
			MaxTravel = 15,
			ControlArmLength = 150,
			SpringConstant = 20000,
			SpringDamping = 1000,
			SpringRelativeDamping = 2000,
		},
	} )

	local RearAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,90,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 1,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				width = 15,
				pos = Vector(-32,-64,25),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),

			self:AddWheel( {
				width = 15,
				pos = Vector(32,-64,25),
				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),
			} ),
		},
		Suspension = {
			Height = 20,
			MaxTravel = 15,
			ControlArmLength = 150,
			SpringConstant = 20000,
			SpringDamping = 1000,
			SpringRelativeDamping = 2000,
		},
	} )

	local ID = self:LookupAttachment( "muzzle_turret" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/weapons/gunner_mg_loop.wav", "lvs/weapons/gunner_mg_loop_interior.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )
end
