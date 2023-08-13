
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Dodge Charger"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/dodge_charger/charger.mdl"

ENT.MaxVelocity = 2400

ENT.EnginePower = 600
ENT.EngineTorque = 170
ENT.EngineIdleRPM = 750
ENT.EngineMaxRPM = 5000

ENT.TransGears = 4
ENT.TransGearsReverse = 1
ENT.TransMinGearHoldTime = 1
ENT.TransShiftSpeed = 0.3

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/dodge_charger/engine_00791.wav",
		Volume = 1,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/dodge_charger/engine_02021.wav",
		Volume = 1,
		Pitch = 80,
		PitchMul = 90,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_UP,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/dodge_charger/engine_01835.wav",
		Volume = 1,
		Pitch = 80,
		PitchMul = 110,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_DOWN,
		UseDoppler = true,
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		SubMaterialID = 25,
		Sprites = {
			{ pos = Vector(98.77,27.7,16.51), colorB = 200, colorA = 150 },
			{ pos = Vector(98.77,-27.7,16.51), colorB = 200, colorA = 150 },
			{ pos = Vector(-102,10,20), width = 30, height = 20, colorG = 0, colorB = 0, colorA = 80 },
			{ pos = Vector(-102,-10,20), width = 30, height = 20, colorG = 0, colorB = 0, colorA = 80 },
		},
		ProjectedTextures = {
			{ pos = Vector(97.66,27.7,16.51), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(97.66,-27.7,16.51), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "high",
		SubMaterialID = 28,
		Sprites = {
			{ pos = Vector(97.66,20.39,16.58), colorB = 200, colorA = 150 },
			{ pos = Vector(97.66,-20.39,16.58), colorB = 200, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(97.66,20.39,16.58), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(97.66,-20.39,16.58), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "main+brake+turnleft",
		SubMaterialID = 26,
		Sprites = {
			{ pos = Vector(-102,18,20), width = 45, height = 20, colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-102,26,20), width = 30, height = 20, colorG = 0, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "main+brake+turnright",
		SubMaterialID = 27,
		Sprites = {
			{ pos = Vector(-102,-18,20), width = 45, height = 20, colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-102,-26,20), width = 30, height = 20, colorG = 0, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnright",
		SubMaterialID = 22,
		Sprites = {
			{ width = 40, height = 40, pos = Vector(99.23,-24.9,5.96), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		SubMaterialID = 23,
		Sprites = {
			{ width = 40, height = 40, pos = Vector(99.23,24.9,5.96), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "reverse",
		SubMaterialID = 24,
		Sprites = {
			{ pos = Vector(-102.14,-15.04,8.9), height = 25, width = 25, colorA = 150 },
			{ pos = Vector(-102.14,15.04,8.9), height = 25, width = 25, colorA = 150 },
		}
	},
}

