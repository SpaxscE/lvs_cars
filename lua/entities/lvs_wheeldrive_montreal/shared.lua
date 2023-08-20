
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Alfa Romeo Montreal"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/alfa_montreal/montreal.mdl"

ENT.MaxVelocity = 2400

ENT.EngineTorque = 105
ENT.EngineIdleRPM = 900
ENT.EngineMaxRPM = 7000

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/montreal/eng_idle_loop.wav",
		Volume = 1,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/montreal/eng_loop.wav",
		Volume = 1,
		Pitch = 55,
		PitchMul = 60,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_UP,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/montreal/eng_revdown_loop.wav",
		Volume = 1,
		Pitch = 55,
		PitchMul = 60,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_DOWN,
		UseDoppler = true,
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(-89.47,4.58,8.3),
		ang = Angle(45,180,0),
	},
	{
		pos = Vector(-89.47,-4.58,8.3),
		ang = Angle(45,180,0),
	}
}

ENT.Lights = {
	{
		Trigger = "main",
		SubMaterialID = 13,
		Sprites = {
			{ pos = Vector(80.15,24.22,23.03), colorB = 200, colorA = 150 },
			{ pos = Vector(80.15,-24.22,23.03), colorB = 200, colorA = 150 },
			{ pos = Vector(-90.42,16.84,27.36), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-90.42,-16.84,27.36), colorG = 0, colorB = 0, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(80.15,24.22,23.03), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(80.15,-24.22,23.03), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "main",
		SubMaterialID = 27,
	},
	{
		Trigger = "high",
		SubMaterialID = 26,
		Sprites = {
			{ pos = Vector(82.14,17.08,23.37), colorB = 200, colorA = 150 },
			{ pos = Vector(82.14,-17.08,23.37), colorB = 200, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(82.14,17.08,23.37), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(82.14,-17.08,23.37), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 22,
		Sprites = {
			{ pos = Vector(-90.1,23.75,26.99), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-90.1,-23.75,26.99), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "reverse",
		SubMaterialID = 23,
		Sprites = {
			{ pos = Vector(-90.46,15.6,24.87), height = 25, width = 25, colorA = 150 },
			{ pos = Vector(-90.46,-15.6,24.87), height = 25, width = 25, colorA = 150 },
		}
	},
	{
		Trigger = "turnright",
		SubMaterialID = 12,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(63.99,-34.41,25.48), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 40, height = 40, pos = Vector(-90.01,-23.25,24.85), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(84.03,-21.24,16.29), colorG = 100, colorB = 0, colorA = 150},
		},
	},
	{
		Trigger = "turnleft",
		SubMaterialID = 11,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(63.99,34.41,25.48), colorG = 100, colorB = 0, colorA = 50 },
			{ width = 40, height = 40, pos = Vector(-90.01,23.25,24.85), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(84.03,21.24,16.29), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
}
