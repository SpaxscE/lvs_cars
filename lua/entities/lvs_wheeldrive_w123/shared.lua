
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Mercedes W123"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/mb_w123/w123.mdl"

ENT.MaxVelocity = 1500

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
		pos = Vector(-81.82,19.46,3.58),
		ang = Angle(30,180,0),
	}
}

ENT.Lights = {
	{
		Trigger = "main",
		SubMaterialID = 24,
		Sprites = {
			{ pos = Vector(95.99,24.72,21.01), colorB = 200, colorA = 150 },
			{ pos = Vector(95.99,-24.72,21.01), colorB = 200, colorA = 150 },
			{ pos = Vector(-86.2,21.51,21.1), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-86.2,-21.51,21.1), colorG = 0, colorB = 0, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(95.99,24.72,21.01), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(95.99,-24.72,21.01), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "high",
		Sprites = {
			{ pos = Vector(95.99,24.72,21.01), colorB = 200, colorA = 150 },
			{ pos = Vector(95.99,-24.72,21.01), colorB = 200, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(95.99,24.72,21.01), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(95.99,-24.72,21.01), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 31,
		Sprites = {
			{ pos = Vector(-86.03,26.09,21.32), colorG = 0, colorB = 0, colorA = 150 },
			{ pos = Vector(-86.03,-26.09,21.32), colorG = 0, colorB = 0, colorA = 150 },
		}
	},
	{
		Trigger = "reverse",
		SubMaterialID = 27,
		Sprites = {
			{ pos = Vector(-86,17.49,21.19), height = 25, width = 25, colorA = 150 },
			{ pos = Vector(-86,-17.49,21.19), height = 25, width = 25, colorA = 150 },
		}
	},
	{
		Trigger = "fog",
		SubMaterialID = 25,
		Sprites = {
			{ pos = Vector(96.88,17.33,20.92), colorB = 200, colorA = 150 },
			{ pos = Vector(96.88,-17.33,20.92), colorB = 200, colorA = 150 },
		},
	},
	{
		Trigger = "turnright",
		SubMaterialID = 29,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(-83.76,-30.27,21.27), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		SubMaterialID = 28,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(-83.76,30.27,21.27), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnright",
		SubMaterialID = 21,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(95.17,-31.15,20.42), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		SubMaterialID = 22,
		Sprites = {
			{ width = 35, height = 35, pos = Vector(95.17,31.15,20.42), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
}