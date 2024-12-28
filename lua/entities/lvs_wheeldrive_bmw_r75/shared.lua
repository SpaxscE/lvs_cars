
ENT.Base = "lvs_bike_wheeldrive"

ENT.PrintName = "BMW R75"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.VehicleCategory = "Cars"
ENT.VehicleSubCategory = "Military"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/bmw_r75/r75_bike.mdl"

ENT.AITEAM = 1

ENT.MaxHealth = 750

ENT.MaxVelocity = 1250
ENT.MaxVelocityReverse = 100

ENT.EngineCurve = 0.4
ENT.EngineTorque = 250

ENT.TransGears = 4
ENT.TransGearsReverse = 1

ENT.PhysicsRollMul = 1
ENT.PhysicsDampingRollMul = 1
ENT.PhysicsWheelGyroMul = 1

ENT.lvsShowInSpawner = true

ENT.KickStarter = true
ENT.KickStarterSound = "lvs/vehicles/bmw_r75/moped_crank.wav"
ENT.KickStarterMinAttempts = 2
ENT.KickStarterMaxAttempts = 4
ENT.KickStarterAttemptsInSeconds = 5

ENT.DriverBoneManipulateIdle = {
	["ValveBiped.Bip01_L_Thigh"] = Angle(-25,45,0),
	["ValveBiped.Bip01_L_Calf"] = Angle(0,-30,0),
	["ValveBiped.Bip01_L_Foot"] = Angle(0,0,0),
}

ENT.DriverBoneManipulateParked = {
	["ValveBiped.Bip01_R_Thigh"] = Angle(25,45,0),
	["ValveBiped.Bip01_R_Calf"] = Angle(0,-30,0),
	["ValveBiped.Bip01_R_Foot"] = Angle(0,0,0),
}

ENT.DriverBoneManipulateKickStart = {
	Start = {
		["ValveBiped.Bip01_L_Thigh"] = Angle(-20,60,25),
		["ValveBiped.Bip01_L_Calf"] = Angle(0,0,0),
		["ValveBiped.Bip01_L_Foot"] = Angle(0,-10,0),
	},
	End = {
		["ValveBiped.Bip01_L_Thigh"] = Angle(-20,-10,25),
		["ValveBiped.Bip01_L_Calf"] = Angle(0,70,0),
		["ValveBiped.Bip01_L_Foot"] = Angle(0,-10,0),
	},
}

ENT.PlayerBoneManipulate = {
	[1] = {
		["ValveBiped.Bip01_Pelvis"] = Angle(0,0,23),
		
		["ValveBiped.Bip01_R_Thigh"] = Angle(14,10,-5),
		["ValveBiped.Bip01_L_Thigh"] = Angle(-14,10,5),

		["ValveBiped.Bip01_R_Calf"] = Angle(0,40,0),
		["ValveBiped.Bip01_L_Calf"] = Angle(0,40,0),
		
		["ValveBiped.Bip01_R_Foot"] = Angle(0,-20,0),
		["ValveBiped.Bip01_L_Foot"] = Angle(0,-20,0),

		["ValveBiped.Bip01_R_UpperArm"] = Angle(10,25,0),
		["ValveBiped.Bip01_L_UpperArm"] = Angle(-5,25,0),

		["ValveBiped.Bip01_R_Forearm"] = Angle(0,-10,0),
		["ValveBiped.Bip01_L_Forearm"] = Angle(0,-10,0),
	},
	[2] = {
		["ValveBiped.Bip01_R_Thigh"] = Angle(14,10,0),
		["ValveBiped.Bip01_L_Thigh"] = Angle(-14,10,0),
	},
}

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/bmw_r75/eng_idle.wav",
		Volume = 0.7,
		Pitch = 85,
		PitchMul = 50,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/bmw_r75/eng_loop.wav",
		Volume = 1,
		Pitch = 50,
		PitchMul = 50,
		SoundLevel = 75,
		UseDoppler = true,
	},
}

ENT.Lights = {
	{
		Trigger = "main+high",
		SubMaterialID = 0,
		Sprites = {
			{ pos = "lamp", colorB = 200, colorA = 150 },
		},
	},
	{
		Trigger = "main",
		Sprites = {
			{ pos = "back1", colorG = 0, colorB = 0, colorA = 150, width = 10, height = 10 },
		},
		ProjectedTextures = {
			{ pos = "lamp", ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "high",
		ProjectedTextures = {
			{ pos = "lamp", ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "main",
		SubMaterialID = 4,
	},
	{
		Trigger = "brake",
		SubMaterialBrightness = 1,
		Sprites = {
			{ pos = "back1", colorG = 0, colorB = 0, colorA = 150, width = 20, height = 20 },
		},
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(-38.43,-5,16),
		ang = Angle(0,180,0),
	},
}
