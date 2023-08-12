
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
ENT.TransMinGearHoldTime = 1
ENT.TransShiftSpeed = 0.3

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

ENT.Lights = {
	{
		Trigger = "main",
		SubMaterialID = 11,
		Sprites = {
			[1] = {
				pos = Vector(79.02,19.17,25.57),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(79.02,-19.17,25.57),
				colorB = 200,
				colorA = 150,
			},
			[3] = {
				pos = Vector(-90.14,20.63,26.63),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
			[4] = {
				pos = Vector(-90.14,-20.63,26.63),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(79.02,19.17,25.57),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(79.02,-19.17,25.57),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
	{
		Trigger = "reverse",
		SubMaterialID = 12,
		Sprites = {
			[1] = {
				pos = Vector(-90.33,-13.77,26.55),
				height = 25,
				width = 25,
				colorA = 150,
			},
			[2] = {
				pos = Vector(-90.33,13.77,26.55),
				height = 25,
				width = 25,
				colorA = 150,
			},
		}
	},
	{
		Trigger = "turnright",
		SubMaterialID = 16,
		Sprites = {
			[1] = {
				width = 35,
				height = 35,
				pos = Vector(77.13,-29.8,25.2),
				colorG = 100,
				colorB = 0,
				colorA = 150,
			},
			[2] = {
				width = 40,
				height = 40,
				pos = Vector(-87.4,-29.24,26.25),
				colorG = 100,
				colorB = 0,
				colorA = 150,
			},
		},
	},
	{
		Trigger = "turnleft",
		SubMaterialID = 15,
		Sprites = {
			[1] = {
				width = 35,
				height = 35,
				pos = Vector(77.13,29.8,25.2),
				colorG = 100,
				colorB = 0,
				colorA = 50,
			},
			[2] = {
				width = 40,
				height = 40,
				pos = Vector(-87.4,29.24,26.25),
				colorG = 100,
				colorB = 0,
				colorA = 150,
			},
		},
	},

}
