
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "DOD:S Kuebelwagen"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/kubel/kubelwagen.mdl"

ENT.AITEAM = 1

ENT.MaxVelocity = 1200

ENT.EngineTorque = 150
ENT.EngineCurve = 0.25

ENT.TransGears = 4
ENT.TransGearsReverse = 1

ENT.HornSound = "lvs/horn1.wav"
ENT.HornPos = Vector(40,0,35)

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/kuebelwagen/eng_idle_loop.wav",
		Volume = 0.5,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/kuebelwagen/eng_loop.wav",
		Volume = 1,
		Pitch = 100,
		PitchMul = 100,
		SoundLevel = 75,
		UseDoppler = true,
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = Vector(-71.74,20.47,40.6), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-71.74,-20.47,40.6), colorG = 0, colorB = 0, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(70.57,25.1,33.49), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(70.57,-25.1,33.49), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "high",
		ProjectedTextures = {
			{ pos = Vector(70.57,25.1,33.49), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(70.57,-25.1,33.49), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "main+high",
		SubMaterialID = 1,
		Sprites = {
			{ pos = Vector(70.57,25.1,33.49), colorB = 200, colorA = 150 },
			{ pos = Vector(70.57,-25.1,33.49), colorB = 200, colorA = 150 },
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 2,
		Sprites = {
			{ pos = Vector(-71.36,20.51,39.48), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-71.36,-20.51,39.48), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "fog",
		SubMaterialID = 3,
		Sprites = {
			{ pos = Vector(33.15,-25.63,48.61), colorB = 200, colorA = 150 },
		},
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(-72.3,15.49,17.61),
		ang = Angle(0,180,0),
	},
}
