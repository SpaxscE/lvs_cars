
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Nissan Bluebird 910"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/nissan_bluebird910/bluebird.mdl"

ENT.MaxVelocity = 2100

ENT.EngineTorque = 100

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/mercedes_w123/eng_idle_loop.wav",
		Volume = 1,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/mercedes_w123/eng_loop.wav",
		Volume = 1,
		Pitch = 80,
		PitchMul = 110,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_UP,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/mercedes_w123/eng_revdown_loop.wav",
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
		pos = Vector(-88.78,16.23,11.5),
		ang = Angle(30,180,0),
	}
}

ENT.Lights = {
	{
		Trigger = "main",
		ProjectedTextures = {
			{ pos = Vector(79.02,19.17,25.57), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(79.02,-19.17,25.57), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "main",
		SubMaterialID = 7,
	},
	{
		Trigger = "high",
		ProjectedTextures = {
			{ pos = Vector(79.02,-19.17,25.57), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(79.02,19.17,25.57), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
	Trigger = "main+high",
		SubMaterialID = 18,
		Sprites = {
			{ pos = Vector(79.02,19.17,25.57), colorB = 200, colorA = 150 },
			{ pos = Vector(79.02,-19.17,25.57), colorB = 200, colorA = 150 },
		},
	},
	{
		Trigger = "main+brake",
		SubMaterialID = 20,
		Sprites = {
			{ pos = Vector(-90.14,20.63,26.63), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-90.14,-20.63,26.63), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "reverse",
		SubMaterialID = 10,
		Sprites = {
			{ pos = Vector(-90.33,-13.77,26.55), height = 25, width = 25, colorA = 150 },
			{ pos = Vector(-90.33,13.77,26.55), height = 25, width = 25, colorA = 150 },
		}
	},
	{
		Trigger = "turnright",
		SubMaterialID = 13,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(77.13,-29.8,25.2), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 40, height = 40, pos = Vector(-87.4,-29.24,26.25), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		SubMaterialID = 12,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(77.13,29.8,25.2), colorG = 100, colorB = 0, colorA = 50 },
			{ width = 40, height = 40, pos = Vector(-87.4,29.24,26.25), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "fog",
		SubMaterialID = 17,
		Sprites = {
			{ pos = Vector(77.98,-25.24,25.34), colorB = 200, colorA = 150 },
			{ pos = Vector(77.98,25.24,25.34), colorB = 200, colorA = 150 },
		},
	},
}
