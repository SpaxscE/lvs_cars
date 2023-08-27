
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Nissan Skyline"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/nissan_skyline_gtr34/gtr.mdl"

ENT.MaxVelocity = 2750

ENT.EngineCurve = 0.15
ENT.EngineTorque = 135
ENT.EngineIdleRPM = 1000
ENT.EngineMaxRPM = 8500

ENT.TransGears = 6
ENT.TransGearsReverse = 1

ENT.WheelPhysicsMass = 120

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/skyline/eng_idle_loop.wav",
		Volume = 1,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/skyline/eng_loop.wav",
		Volume = 1,
		Pitch = 50,
		PitchMul = 75,
		SoundLevel = 105,
		SoundType = LVS.SOUNDTYPE_REV_UP,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/skyline/eng_revdown_loop.wav",
		Volume = 1,
		Pitch = 50,
		PitchMul = 75,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_DOWN,
		UseDoppler = true,
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(-90.33,14.84,12.82),
		ang = Angle(0,180,0),
	},
	{
		pos = Vector(-90.21,18.63,12.87),
		ang = Angle(0,180,0),
	}
}

ENT.Lights = {
	{
		Trigger = "main",
		SubMaterialID = 27,
		Sprites = {
			{ pos = Vector(81.5,24.61,26.71), colorB = 200, colorA = 150 },
			{ pos = Vector(81.5,-24.61,26.71), colorB = 200, colorA = 150 },
			{ pos = Vector(78.37,28.75,26.41), colorB = 200, colorA = 150 },
			{ pos = Vector(78.37,-28.75,26.41), colorB = 200, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(81.5,24.61,26.71), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(81.5,-24.61,26.71), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "main",
		SubMaterialID = 3,
	},
	{
		Trigger = "high",
		SubMaterialID = 26,
		Sprites = {
			{ pos = Vector(83.53,19.34,25.91), colorB = 200, colorA = 150 },
			{ pos = Vector(83.53,-19.34,25.91), colorB = 200, colorA = 150 },

		},
		ProjectedTextures = {
			{ pos = Vector(83.53,19.34,25.91), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(83.53,-19.34,25.91), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},

	{
		Trigger = "brake",
		SubMaterialID = 31,
		Sprites = {
			{ width = 55, height = 15, pos = Vector(-87.95,-0.11,39.11), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "main+brake",
		SubMaterialID = 24,
		Sprites = {
			{ width = 75, height = 75, pos = Vector(-86.35,26.09,33.79), colorG = 0, colorB = 0, colorA = 150 },
			{ width = 75, height = 75, pos = Vector(-86.35,-26.09,33.79), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "reverse",
		SubMaterialID = 30,
		Sprites = {
			{ pos = Vector(-91.79,10.73,21.85), height = 25, width = 25, colorA = 150 },
		}
	},
	{
		Trigger = "turnright",
		SubMaterialID = 23,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(85.86,-25.24,18.39), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 20, height = 20, pos = Vector(34.69,-35.06,27.14), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 40, height = 40, pos = Vector(-87.93,-18.22,33.07), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		SubMaterialID = 22,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(85.86,25.24,18.39), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 20, height = 20, pos = Vector(34.69,35.06,27.14), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 40, height = 40, pos = Vector(-87.93,18.22,33.07), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
}
