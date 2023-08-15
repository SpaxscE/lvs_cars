
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Nissan Bluebird 910"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/NISSAN_BLUEBIRD910/BLUEBIRD.mdl"

ENT.MaxVelocity = 2600

ENT.EnginePower = 1800
ENT.EngineTorque = 100

ENT.TransGears = 4
ENT.TransGearsReverse = 1

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/i4/i4_idle_1.wav",
		Volume = 1,
		Pitch = 35,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/i4/i4_idle_2.wav",
		Volume = 1,
		Pitch = 40,
		PitchMul = 110,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_NONE,
		UseDoppler = true,
	},
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
		Trigger = "high",
		ProjectedTextures = {
			{ pos = Vector(79.02,-19.17,25.57), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(79.02,19.17,25.57), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
	Trigger = "main+high",
		SubMaterialID = 20,
		Sprites = {
			{ pos = Vector(79.02,19.17,25.57), colorB = 200, colorA = 150 },
			{ pos = Vector(79.02,-19.17,25.57), colorB = 200, colorA = 150 },
		},
	},
	{
		Trigger = "main+brake",
		SubMaterialID = 19,
		Sprites = {
			{ pos = Vector(-90.14,20.63,26.63), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-90.14,-20.63,26.63), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "reverse",
		SubMaterialID = 11,
		Sprites = {
			{ pos = Vector(-90.33,-13.77,26.55), height = 25, width = 25, colorA = 150 },
			{ pos = Vector(-90.33,13.77,26.55), height = 25, width = 25, colorA = 150 },
		}
	},
	{
		Trigger = "turnright",
		SubMaterialID = 15,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(77.13,-29.8,25.2), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 40, height = 40, pos = Vector(-87.4,-29.24,26.25), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		SubMaterialID = 14,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(77.13,29.8,25.2), colorG = 100, colorB = 0, colorA = 50 },
			{ width = 40, height = 40, pos = Vector(-87.4,29.24,26.25), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "fog",
		SubMaterialID = 18,
		Sprites = {
			{ pos = Vector(77.98,-25.24,25.34), colorB = 200, colorA = 150 },
			{ pos = Vector(77.98,25.24,25.34), colorB = 200, colorA = 150 },
		},
	},
}
