
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Dodge Charger"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/dodge_charger/charger.mdl"

ENT.MaxVelocity = 2600

ENT.EnginePower = 1800
ENT.EngineTorque = 100

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
		SubMaterialID = 23,
		Sprites = {
			[1] = {
				pos = Vector(98.77,27.7,16.51),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(98.77,-27.7,16.51),
				colorB = 200,
				colorA = 150,
			},
			[3] = {
				pos = Vector(97.66,20.39,16.58),
				colorB = 200,
				colorA = 150,
			},
			[4] = {
				pos = Vector(97.66,-20.39,16.58),
				colorB = 200,
				colorA = 150,
			},
			[5] = {
				pos = Vector(-98.62,21.53,20.44),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
			[6] = {
				pos = Vector(-98.62,-21.53,20.44),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(100,20.39,16.58),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(100,-20.39,16.58),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
}
