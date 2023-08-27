
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Audi Quattro"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/audi_quattro/quattro.mdl"

ENT.MaxVelocity = 2000

ENT.EngineCurve = 0.15
ENT.EngineTorque = 115

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/bmw_m5e34/eng_idle_loop.wav",
		Volume = 1,
		Pitch = 85,
		PitchMul = 25,
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
		pos = Vector(-84.54,9.83,2.46),
		ang = Angle(30,180,0),
	},
	{
		pos = Vector(-84.23,13.93,2.6),
		ang = Angle(30,180,0),
	}
}

ENT.Lights = {
	{
		Trigger = "main",
		ProjectedTextures = {
			{ pos = Vector(80.98,24.6,15.34), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(80.98,-24.6,15.34), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "high",
		ProjectedTextures = {
			{ pos = Vector(80.98,24.6,15.34), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(80.98,-24.6,15.34), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
	Trigger = "main+high",
		SubMaterialID = 23,
		Sprites = {
			{ pos = Vector(80.98,24.6,15.34), colorB = 200, colorA = 150 },
			{ pos = Vector(80.98,-24.6,15.34), colorB = 200, colorA = 150 },
		},
	},
	{
	Trigger = "main",
		SubMaterialID = 30,
	},
	{
		Trigger = "main+brake",
		SubMaterialID = 25,
		Sprites = {
			{ pos = Vector(-85.02,28.51,17.52), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-85.02,-28.51,17.52), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "brake",
		SubMaterialID = 21,
		Sprites = {
			{ pos = Vector(-88.23,28.24,11.09), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-88.23,-28.24,11.09), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "reverse",
		SubMaterialID = 27,
		Sprites = {
			{ pos = Vector(-85.51,28.64,20.34), height = 25, width = 25, colorA = 150 },
			{ pos = Vector(-85.51,-28.64,20.34), height = 25, width = 25, colorA = 150 },
		}
	},
	{
		Trigger = "turnright",
		SubMaterialID = 17,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(85.19,-28.92,8.62), colorG = 100, colorB = 0, colorA = 150 },
			{ width = 15, height = 15, pos = Vector(76.69,-33.32,11.03), colorG = 100, colorB = 0, colorA = 50 },
			{ width = 40, height = 40, pos = Vector(-84.04,-28.82,22.36), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		SubMaterialID = 26,
	},
	{
		Trigger = "turnright",
		SubMaterialID = 28,
	},
	{
		Trigger = "turnleft",
		SubMaterialID = 16,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(85.19,28.92,8.62), colorG = 100, colorB = 0, colorA = 50 },
			{ width = 15, height = 15, pos = Vector(76.69,33.32,11.03), colorG = 100, colorB = 0, colorA = 50 },
			{ width = 40, height = 40, pos = Vector(-84.04,28.82,22.36), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "fog",
		SubMaterialID = 18,
		Sprites = {
			{ pos = Vector(82.71,17.83,15.9), colorB = 200, colorA = 150 },
			{ pos = Vector(82.71,-17.83,15.9), colorB = 200, colorA = 150 },
			{ pos = Vector(87.39,23.18,8.88), colorB = 200, colorA = 150 },
			{ pos = Vector(87.39,-23.18,8.88), colorB = 200, colorA = 150 },
		},
	},
	{
		Trigger = "fog",
		SubMaterialID = 24,
	},
}

