AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "sh_tracks.lua" )
include("shared.lua")
include("sh_turret.lua")
include("sh_tracks.lua")

function ENT:OnSpawn( PObj )
	local DriverSeat = self:AddDriverSeat( Vector(0,21,30), Angle(0,-90,0) )
	local PassengerSeat = self:AddPassengerSeat( Vector(15,-21,37), Angle(0,-90,10) )

	local DoorHandler = self:AddDoorHandler( "left_door", Vector(20,30,48), Angle(0,0,0), Vector(-17,-3,-12), Vector(20,6,12), Vector(-17,-15,-12), Vector(20,30,12) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "right_door", Vector(20,-30,48), Angle(0,180,0), Vector(-17,-3,-12), Vector(20,6,12), Vector(-17,-15,-12), Vector(20,30,12) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( PassengerSeat )

	local DoorHandler = self:AddDoorHandler( "hatch", Vector(35,0,70), Angle(0,0,0), Vector(-10,-30,-10), Vector(10,30,10), Vector(-10,-30,-10), Vector(10,30,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_open.wav" )

	local DoorHandler = self:AddDoorHandler( "trunk", Vector(-115,0,60), Angle(0,0,0), Vector(-1,-15,-15), Vector(1,15,15), Vector(-30,-15,-15), Vector(1,15,15) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

	self:AddEngine( Vector(68,0,50) )
	self:AddFuelTank( Vector(-85,0,22), 600, LVS.FUELTYPE_PETROL )

	self.SNDTurretMG = self:AddSoundEmitter( Vector(-63,0,85), "lvs/vehicles/halftrack/mc_loop.wav", "lvs/vehicles/halftrack/mc_loop.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )

	local WheelModel = "models/diggercars/m5m16/m5_wheel.mdl"

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
			TorqueFactor = 0.5,
			BrakeFactor = 1,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(81,-32,20),
				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),
			} ),

			self:AddWheel( {
				pos = Vector(81,32,20),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),
		},
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )

	self:CreateTracks()
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/halftrack/engine_start.wav" )
	end
end