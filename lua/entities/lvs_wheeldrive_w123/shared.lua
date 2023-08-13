
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Mercedes W123"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/mb_w123/v2.mdl"

ENT.MaxVelocity = 1500

ENT.EnginePower = 800
ENT.EngineTorque = 100

ENT.TransGears = 5
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
		SubMaterialID = 24,
		Sprites = {
			[1] = {
				pos = Vector(95.99,24.72,21.01),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(95.99,-24.72,21.01),
				colorB = 200,
				colorA = 150,
			},
			[3] = {
				pos = Vector(-86.2,21.51,21.1),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
			[4] = {
				pos = Vector(-86.2,-21.51,21.1),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(95.99,24.72,21.01),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(95.99,-24.72,21.01),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
	{
		Trigger = "high",
		Sprites = {
			[1] = {
				pos = Vector(95.99,24.72,21.01),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(95.99,-24.72,21.01),
				colorB = 200,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(95.99,24.72,21.01),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(95.99,-24.72,21.01),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 31,
		Sprites = {
			[1] = {
				pos = Vector(-86.03,26.09,21.32),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
			[2] = {
				pos = Vector(-86.03,-26.09,21.32),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
		}
	},
	{
		Trigger = "reverse",
		SubMaterialID = 27,
		Sprites = {
			[1] = {
				pos = Vector(-86,17.49,21.19),
				height = 25,
				width = 25,
				colorA = 150,
			},
			[2] = {
				pos = Vector(-86,-17.49,21.19),
				height = 25,
				width = 25,
				colorA = 150,
			},
		}
	},
	{
		Trigger = "fog",
		SubMaterialID = 25,
		Sprites = {
			[1] = {
				pos = Vector(96.88,17.33,20.92),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(96.88,-17.33,20.92),
				colorB = 200,
				colorA = 150,
			},
		},
	},
}