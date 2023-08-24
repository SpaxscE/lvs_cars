
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Ferrari 365 GTB4"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/ferrari_365/ferrari_365norig.mdl"

ENT.MaxVelocity = 2600

ENT.EngineTorque = 150

ENT.TransGears = 5
ENT.TransGearsReverse = 1

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/ferrari_365/eng_idle_loop.wav",
		Volume = 1,
		Pitch = 70,
		PitchMul = 30,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/ferrari_365/eng_loop.wav",
		Volume = 1,
		Pitch = 80,
		PitchMul = 110,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_UP,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/ferrari_365/eng_revdown_loop.wav",
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
		pos = Vector(-90.01,17.61,13.31),
		ang = Angle(0,180,0),
	},
	{
		pos = Vector(-90.01,21,13.31),
		ang = Angle(0,180,0),
	},
	{
		pos = Vector(-90.01,-17.61,13.31),
		ang = Angle(0,180,0),
	},
	{
		pos = Vector(-90.01,-21,13.31),
		ang = Angle(0,180,0),
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		SubMaterialID = 16,
		Sprites = {
			[1] = {
				pos = Vector(84.95,21.9,25.42),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(84.95,-21.9,25.42),
				colorB = 200,
				colorA = 150,
			},
			[3] = {
				pos = Vector(-88.03,21.44,27.81),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
			[4] = {
				pos = Vector(-88.03,-21.44,27.81),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(84.95,-21.9,25.42),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(84.95,21.9,25.42),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
	{
		Trigger = "high",
		SubMaterialID = 21,
		Sprites = {
			[1] = {
				pos = Vector(86.34,-15.93,25.76),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(86.34,15.93,25.76),
				colorB = 200,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(86.34,-15.93,25.76),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(86.34,15.93,25.76),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 20,
		Sprites = {
			[1] = {
				pos = Vector(-88.25,24.19,24.23),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
			[2] = {
				pos = Vector(-88.25,-24.19,24.23),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
		}
	},
	{
		Trigger = "reverse",
		SubMaterialID = 15,
		Sprites = {
			[1] = {
				pos = Vector(-89.84,0,19.94),
				height = 25,
				width = 25,
				colorA = 150,
			},
		}
	},
	{
		Trigger = "turnright",
		SubMaterialID = 13,
		Sprites = {
			[1] = {
				width = 35,
				height = 35,
				pos = Vector(74.22,-31.15,24.05),
				colorG = 100,
				colorB = 0,
				colorA = 150,
			},
			[2] = {
				width = 40,
				height = 40,
				pos = Vector(-87.04,-26.58,28.13),
				colorG = 100,
				colorB = 0,
				colorA = 150,
			},
			[3] = {
				width = 15,
				height = 15,
				pos = Vector(-80.73,-31.11,27.34),
				colorG = 100,
				colorB = 0,
				colorA = 150,
			},
		},
	},
	{
		Trigger = "turnleft",
		SubMaterialID = 14,
		Sprites = {
			[1] = {
				width = 35,
				height = 35,
				pos = Vector(74.22,31.15,24.05),
				colorG = 100,
				colorB = 0,
				colorA = 50,
			},
			[2] = {
				width = 40,
				height = 40,
				pos = Vector(-87.04,26.58,28.13),
				colorG = 100,
				colorB = 0,
				colorA = 150,
			},
			[3] = {
				width = 15,
				height = 15,
				pos = Vector(-80.73,31.11,27.34),
				colorG = 100,
				colorB = 0,
				colorA = 150,
			},
		},
	},
}

