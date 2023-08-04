local Category = "LVS"

local function GearHandler( ent )
	local FT = FrameTime()
	local SomeNumber = 10

	local TargetPP = ent.GearIDtoPoseParam[ ent:GetGear() ] or 0 -- fallback to 0 if no value present

	if ent.oldTargetPP ~= TargetPP then
		if ent.oldTargetPP then
			ent:EmitSound( ent.GearChangeSound )
		end
		ent.oldTargetPP = TargetPP
	end

	ent.sm_pp_gs = ent.sm_pp_gs and (ent.sm_pp_gs + (TargetPP - ent.sm_pp_gs) * FT * SomeNumber) or 0

	ent:SetPoseParameter( "gears", ent.sm_pp_gs )
end


local function PedalsGauges( ent )
	local throttle_pedal = (ent:GetThrottle())
	local clutch_pedal = (ent:GetClutch())
	local brake_pedal = ent.Brake / ent:GetBrakePower()
	local handbrake_pedal = ent.HandBrake / ent:GetBrakePower()

	ent:SetPoseParameter("throttle_pedal", throttle_pedal)
	ent:SetPoseParameter("brake_pedal", brake_pedal)
	ent:SetPoseParameter("clutch_pedal", clutch_pedal)
	ent:SetPoseParameter("handbrake_pedal", handbrake_pedal)
end



local V = {
	Name = "Ferrari 365GTS",
	Model = "models/DiggerCars/ferrari_365/1.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = Category,

	Members = {


		Mass = 1000,
		IsArmored = false,
		FrontWheelRadius = 13,
		RearWheelRadius = 13,
		CustomMassCenter = Vector(2,0,4),
		SeatOffset = Vector(-20.6,-14.5,40),
		SeatPitch = -8,
		SeatYaw = 90,
		CustomSteerAngle = 35,
                MaxHealth = 1100,	

		EnginePos = Vector(63,0,20),

		FrontWheelMass = 80,
                RearWheelMass = 80,	
		
		ExhaustPositions = {
			{
				pos = Vector(-78,12.1,5.35),
				ang = Angle(90,90,0)
			},
		},

		PassengerSeats = {
			{
				pos = Vector(9,-13,1),
				ang = Angle(0,-90,20)
			},

		},

		GearIDtoPoseParam = {0,2,4,6,9,11,14},
		GearChangeSound = "simulated_vehicles/satsuma/gear_shift2.WAV",

		OnTick = function(ent)

			PedalsGauges( ent )

			GearHandler( ent )
		end,

		SpeedoMax = 115,
		RPMGaugePP = "tacho_gauge",
		RPMGaugeMax = 8000,

		FuelTankSize = 40,
		FuelType = FUELTYPE_PETROL,
		FuelFillPos = Vector(-58, -28, 24),

		FrontHeight = 8,
		FrontConstant = 35000,
		FrontDamping = 3200,
		FrontRelativeDamping = 3200,
		
		RearHeight = 8,
		RearConstant = 35000,
		RearDamping = 3200,
		RearRelativeDamping = 3200,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 4,
		
		MaxGrip = 29,
		Efficiency = 1.0,
		GripOffset = 0,
		BrakePower = 10,
		
		IdleRPM = 750,
		LimitRPM = 8000,
		PeakTorque = 135,
		PowerbandStart = 3000,
		PowerbandEnd = 7000,
		Turbocharged = false,
                Supercharged = false,
		Revlimiter = 1,	
		PowerBias = 1,
		Backfire = true,
		EngineSoundPreset = 8,
		
		DifferentialGear = 1.1,
		Gears = {-0.04,0,0.04,0.08,0.14,0.17,0.21}
	}
}
if (file.Exists( "models/DiggerCars/ferrari_365/1.mdl", "GAME" )) then
	list.Set( "simfphys_vehicles", "sim_fphys_f365", V )
end
