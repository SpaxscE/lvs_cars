
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Toyota Supra"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/toyota_supra/supra.mdl"

ENT.MaxVelocity = 2650

ENT.EngineCurve = 0.15
ENT.EngineTorque = 135
ENT.EngineIdleRPM = 1000
ENT.EngineMaxRPM = 7000

ENT.TransGears = 6
ENT.TransGearsReverse = 1

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/supra/eng_idle_loop.wav",
		Volume = 1,
		Pitch = 45,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/supra/eng_loop.wav",
		Volume = 1,
		Pitch = 40,
		PitchMul = 65,
		SoundLevel = 105,
		SoundType = LVS.SOUNDTYPE_REV_UP,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/supra/eng_revdown_loop.wav",
		Volume = 1,
		Pitch = 40,
		PitchMul = 65,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_DOWN,
		UseDoppler = true,
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(-97.32,24.34,13.36),
		ang = Angle(-11.67,164.32,-0.19),
	}
}

ENT.Lights = {
	{
		Trigger = "main",
		SubMaterialID = 29,
		Sprites = {
			{ pos = Vector(78.06,-21.57,24.23), colorB = 200, colorA = 150 },
			{ pos = Vector(78.06,21.57,24.23), colorB = 200, colorA = 150 },
			{ width = 15, height = 15, pos = Vector(80.39,-26.11,17.66), colorB = 200, colorA = 150 },
			{ width = 15, height = 15, pos = Vector(80.39,26.11,17.66), colorB = 200, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(78.06,-21.57,24.23), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(78.06,21.57,24.23), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "main",
		SubMaterialID = 27,
	},
	{
		Trigger = "high",
		SubMaterialID = 14,
		Sprites = {
			{ pos = Vector(77.73,-16.83,24.28), colorB = 200, colorA = 150 },
			{ pos = Vector(77.73,16.83,24.28), colorB = 200, colorA = 150 },

		},
		ProjectedTextures = {
			{ pos = Vector(77.73,-16.83,24.28), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(77.73,16.83,24.28), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},

	{
		Trigger = "brake",
		SubMaterialID = 11,
		Sprites = {
			{ width = 55, height = 15, pos = Vector(-84.91,0,37.5), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "main+brake",
		SubMaterialID = 10,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(-83.37,-18.7,31.54), colorG = 0, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(-83.37,18.7,31.54), colorG = 0, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(-84.81,-14.3,31.71), colorG = 0, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(-84.81,14.3,31.71), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "reverse",
		SubMaterialID = 7,
		Sprites = {
			{ pos = Vector(-85.6,-10.12,31.61), height = 25, width = 25, colorA = 150 },
			{ pos = Vector(-85.6,10.12,31.61), height = 25, width = 25, colorA = 150 },
		}
	},
	{
		Trigger = "turnright",
		SubMaterialID = 9,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(82.08,-23.6,17.52), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 20, height = 20, pos = Vector(68.3,-33.94,18.76), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 20, height = 20, pos = Vector(-75.54,-31.76,22.94), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 40, height = 40, pos = Vector(-82.14,-22.89,31.63), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		SubMaterialID = 8,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(82.08,23.6,17.52), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 20, height = 20, pos = Vector(68.3,33.94,18.76), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 20, height = 20, pos = Vector(-75.54,31.76,22.94), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 40, height = 40, pos = Vector(-82.14,22.89,31.63), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "fog",
		SubMaterialID = 30,
		Sprites = {
			{ pos = Vector(74.9,-25.48,23.86), colorB = 200, colorA = 150 },
			{ pos = Vector(74.9,25.48,23.86), colorB = 200, colorA = 150 },
		},
	},
}
