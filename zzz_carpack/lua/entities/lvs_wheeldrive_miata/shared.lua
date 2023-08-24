
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Mazda Miata"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/mazda_miata/miata.mdl"

ENT.MaxVelocity = 2300

ENT.EngineTorque = 93
ENT.EngineIdleRPM = 800
ENT.EngineMaxRPM = 7000

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/miata/eng_idle_loop.wav",
		Volume = 1,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/miata/eng_loop.wav",
		Volume = 1,
		Pitch = 60,
		PitchMul = 90,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_UP,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/miata/eng_revdown_loop.wav",
		Volume = 1,
		Pitch = 60,
		PitchMul = 90,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_DOWN,
		UseDoppler = true,
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(-74.54,-19.54,11.03),
		ang = Angle(0,180,0),
	}
}

ENT.Lights = {
	{
		Trigger = "main",
		ProjectedTextures = {
			{ pos = Vector(65.4,19.66,30.22), ang = Angle(7,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(65.4,-19.66,30.22), ang = Angle(7,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "main",
		SubMaterialID = 11,
	},
	{
		Trigger = "high",
		ProjectedTextures = {
			{ pos = Vector(65.4,19.66,30.22), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(65.4,-19.66,30.22), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
	Trigger = "main+high",
		SubMaterialID = 31,
		Sprites = {
			{ pos = Vector(65.4,19.66,30.22), colorB = 200, colorA = 150 },
			{ pos = Vector(65.4,-19.66,30.22), colorB = 200, colorA = 150 },
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 29,
		Sprites = {
			{ width = 15, height = 15, pos = Vector(-74.19,-0.08,31.38), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "main+brake",
		SubMaterialID = 28,
		Sprites = {
			{ pos = Vector(-72.29,19.88,26.94), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-72.29,-19.88,26.94), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "reverse",
		SubMaterialID = 23,
		Sprites = {
			{ pos = Vector(-73.35,16.34,26.86), height = 25, width = 25, colorA = 150 },
			{ pos = Vector(-73.35,-16.34,26.86), height = 25, width = 25, colorA = 150 },
		}
	},
	{
		Trigger = "turnright",
		SubMaterialID = 13,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(73.5,-19.7,21.97), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(65.95,-28.87,17.21), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 40, height = 40, pos = Vector(-62.49,-29.83,18.18), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 40, height = 40, pos = Vector(-70.19,-24.2,26.7), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		SubMaterialID = 12,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(73.5,19.7,21.97), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(65.95,28.87,17.21), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 40, height = 40, pos = Vector(-62.49,29.83,18.18), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 40, height = 40, pos = Vector(-70.19,24.2,26.7), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
}
