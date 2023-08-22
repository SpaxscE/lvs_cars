
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "BMW E34"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/bmw_m5e34/e34_2.mdl"

ENT.MaxVelocity = 2500

ENT.EngineTorque = 100
ENT.EngineIdleRPM = 660
ENT.EngineMaxRPM = 6750

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/bmw_m5e34/eng_idle_loop.wav",
		Volume = 1,
		Pitch = 80,
		PitchMul = 70,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/bmw_m5e34/eng_loop.wav",
		Volume = 1,
		Pitch = 80,
		PitchMul = 110,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_UP,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/bmw_m5e34/eng_revdown_loop.wav",
		Volume = 1,
		Pitch = 80,
		PitchMul = 110,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_DOWN,
		UseDoppler = true,
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(-97.46,21.75,6.67),
		ang = Angle(20,180,0),
	},
	{
		pos = Vector(-97.37,25.12,6.79),
		ang = Angle(20,180,0),
	}
}

ENT.Lights = {
	{
		Trigger = "main",
		SubMaterialID = 12,
		Sprites = {
			{ pos = Vector(82.02,23.46,16.95), colorB = 200, colorA = 150 },
			{ pos = Vector(82.02,-23.46,16.95), colorB = 200, colorA = 150 },
			{ pos = Vector(-96.56,26.17,23.24), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-96.56,-26.17,23.24), colorG = 0, colorB = 0, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(82.02,23.46,16.95), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(82.02,-23.46,16.95), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "main",
		SubMaterialID = 25,
	},
	{
		Trigger = "main",
		SubMaterialID = 26,
	},
	{
		Trigger = "high",
		SubMaterialID = 18,
		Sprites = {
			{ pos = Vector(83.73,16.51,16.91), colorB = 200, colorA = 150 },
			{ pos = Vector(83.73,-16.51,16.91), colorB = 200, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(83.73,16.51,16.91), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(83.73,-16.51,16.91), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 15,
		Sprites = {
			{ pos = Vector(-96.3,30.3,23.24), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-96.3,-30.3,23.24), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "reverse",
		SubMaterialID = 23,
		Sprites = {
			{ pos = Vector(-96.41,19.49,24.45), height = 25, width = 25, colorA = 150 },
			{ pos = Vector(-96.41,-19.49,24.45), height = 25, width = 25, colorA = 150 },
		}
	},
	{
		Trigger = "turnright",
		SubMaterialID = 11,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(81.05,-28.33,16.98), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 40, height = 40, pos = Vector(37.58,-34.58,14.43), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(-95.08,-28.5,26.96), colorG = 100, colorB = 0, colorA = 150},
		},
	},
	{
		Trigger = "turnleft",
		SubMaterialID = 13,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(81.05,28.33,16.98), colorG = 100, colorB = 0, colorA = 50 },
			{ width = 40, height = 40, pos = Vector(37.58,34.58,14.43), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 35, height = 35, pos = Vector(-95.08,28.5,26.96), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "fog",
		SubMaterialID = 17,
		Sprites = {
			{ pos = Vector(80.75,23.63,4.51), colorB = 200, colorA = 150 },
			{ pos = Vector(80.75,-23.63,4.51), colorB = 200, colorA = 150 },
		},
	},
}
