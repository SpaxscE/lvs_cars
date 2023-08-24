
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "MGB GT"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/mg_mgb/mgbgt.mdl"

ENT.MaxVelocity = 2600

ENT.EngineTorque = 100

ENT.TransGears = 4
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
		pos = Vector(-75.13,13.86,4.25),
		ang = Angle(30,180,0),
	}
}

ENT.Lights = {
	{
		Trigger = "main",
		SubMaterialID = 13,
		Sprites = {
			[1] = {
				pos = Vector(65.84,23.41,16.03),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(65.84,-23.41,16.03),
				colorB = 200,
				colorA = 150,
			},
			[3] = {
				pos = Vector(-72.67,25.13,16.73),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
			[4] = {
				pos = Vector(-72.67,-25.13,16.73),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(65.84,23.41,16.03),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(65.84,-23.41,16.03),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
	{
		Trigger = "main",
		SubMaterialID = 19,
	},
	{
		Trigger = "main",
		SubMaterialID = 21,
	},
	{
		Trigger = "high",
		Sprites = {
			[1] = {
				pos = Vector(65.84,23.41,16.03),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(65.84,-23.41,16.03),
				colorB = 200,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(65.84,23.41,16.03),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(65.84,-23.41,16.03),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
	{
		Trigger = "brake",
		SubMaterialID = 18,
		Sprites = {
			[1] = {
				pos = Vector(-70.63,25.11,20.39),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
			[2] = {
				pos = Vector(-70.63,-25.11,20.39),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
		}
	},
	{
		Trigger = "fog",
		SubMaterialID = 4,
		Sprites = {
			[1] = {
				pos = Vector(70.08,21.01,8.93),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(70.08,-21.01,8.93),
				colorB = 200,
				colorA = 150,
			},
		},
	},
}
