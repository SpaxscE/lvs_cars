
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Honda City Turbo"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/honda_city_turbo/city.mdl"

ENT.MaxVelocity = 2200

ENT.EngineCurve = 0.15
ENT.EngineTorque = 72
ENT.EngineIdleRPM = 1000
ENT.EngineMaxRPM = 7000

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.TurboVolume = 0.35

ENT.ExhaustPositions = {
	{
		pos = Vector(-62.14,-17.18,13.04),
		ang = Angle(0,180,0),
	}
}

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


ENT.Lights = {
	{
		Trigger = "main",
		ProjectedTextures = {
			{ pos = Vector(60.8,23.19,26.28), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(60.8,-23.19,26.28), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "high",
		ProjectedTextures = {
			{ pos = Vector(60.8,23.19,26.28), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(60.8,-23.19,26.28), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
	Trigger = "main+high",
		SubMaterialID = 2,
		Sprites = {
			{ pos = Vector(60.8,23.19,26.28), colorB = 200, colorA = 150 },
			{ pos = Vector(60.8,-23.19,26.28), colorB = 200, colorA = 150 },
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 3,
	},
	{
		Trigger = "main+brake",
		SubMaterialID = 19,
		Sprites = {
			{ pos = Vector(-59.24,27.17,32.66), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-59.24,-27.17,32.66), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "reverse",
		SubMaterialID = 16,
		Sprites = {
			{ pos = Vector(-60.44,26.66,27.06), height = 25, width = 25, colorA = 150 },
			{ pos = Vector(-60.44,-26.66,27.06), height = 25, width = 25, colorA = 150 },
		}
	},
	{
		Trigger = "turnright",
		SubMaterialID = 18,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(68.82,-23.21,19.41), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(59.1,-28.33,29.87), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 40, height = 40, pos = Vector(-58.23,-26.76,36.06), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		SubMaterialID = 17,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(68.82,23.21,19.41), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(59.1,28.33,29.87), colorG = 100, colorB = 0, colorA = 50 },
			{ width = 40, height = 40, pos = Vector(-58.23,26.76,36.06), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "fog",
		SubMaterialID = 29,
		Sprites = {
			{ pos = Vector(67.16,23.32,15.18), colorG = 200, colorB = 0, colorA = 100 },
			{ pos = Vector(67.16,-23.32,15.18), colorG = 200, colorB = 0, colorA = 100 },
		},
	},
}
