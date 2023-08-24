
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Chryslus Highwayman"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/highwayman/highwayman.mdl"

ENT.MaxVelocity = 1200

ENT.EngineTorque = 350

ENT.TransGears = 4
ENT.TransGearsReverse = 1

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/dodge_charger/eng_idle_loop.wav",
		Volume = 1,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/dodge_charger/eng_loop.wav",
		Volume = 1,
		Pitch = 60,
		PitchMul = 110,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_UP,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/dodge_charger/eng_revdown_loop.wav",
		Volume = 1,
		Pitch = 60,
		PitchMul = 110,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_DOWN,
		UseDoppler = true,
	},
}


ENT.ExhaustPositions = {
	{
		pos = Vector(-40.92,35.96,-1.57),
		ang = Angle(0,100,0),
	},
	{
		pos = Vector(-40.92,-35.96,-1.57),
		ang = Angle(0,-100,0),
	}
}

ENT.Lights = {
	{
		Trigger = "main",
		SubMaterialID = 14,
		Sprites = {
			{ pos = Vector(87.86,-31.52,21.87), colorB = 200, colorA = 150 },
			{ pos = Vector(87.86,31.52,21.87), colorB = 200, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(87.86,-31.52,21.87), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(87.86,31.52,21.87), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "high",
		SubMaterialID = 15,
		Sprites = {
			{ pos = Vector(88.27,25.49,21.81), colorB = 200, colorA = 150 },
			{ pos = Vector(88.27,-25.49,21.81), colorB = 200, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(88.27,25.49,21.81), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(88.27,-25.49,21.81), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "main+brake",
		SubMaterialID = 16,
		Sprites = {
			{ pos = Vector(-109.7,-32.56,17.38), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
}
