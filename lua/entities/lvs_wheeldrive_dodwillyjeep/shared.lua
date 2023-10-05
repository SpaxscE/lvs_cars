
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Willys Jeep"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/willys/willys.mdl"

ENT.AITEAM = 2

ENT.MaxVelocity = 1200

ENT.EngineCurve = 0.25
ENT.EngineTorque = 150

ENT.TransGears = 4
ENT.TransGearsReverse = 1

ENT.HornSound = "lvs/horn2.wav"
ENT.HornPos = Vector(40,0,35)

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/willy/eng_idle_loop.wav",
		Volume = 0.5,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/willy/eng_loop.wav",
		Volume = 1,
		Pitch = 50,
		PitchMul = 100,
		SoundLevel = 75,
		UseDoppler = true,
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		SubMaterialID = 0,
		Sprites = {
			[1] = {
				pos = Vector(60.34,-17.52,34.46),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(60.34,17.52,34.46),
				colorB = 200,
				colorA = 150,
			},
			[3] = {
				pos = Vector(-63.41,-20.49,21.1),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(60.34,-17.52,34.46),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(60.34,17.52,34.46),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
	{
		Trigger = "main",
		SubMaterialID = 3,
	},
	{
		Trigger = "high",
		Sprites = {
			[1] = {
				pos = Vector(60.34,-17.52,34.46),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(60.34,17.52,34.46),
				colorB = 200,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(60.34,-17.52,34.46),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(60.34,17.52,34.46),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
	{

		Trigger = "brake",
		SubMaterialID = 2,
		Sprites = {
			[1] = {
				pos = Vector(-63.41,20.49,21.1),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
		}
	},
	{
		Trigger = "fog",
		SubMaterialID = 1,
		Sprites = {
			[1] = {
				pos = Vector(61.03,14.6,28.6),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(61.03,-14.6,28.6),
				colorB = 200,
				colorA = 150,
			},
			[3] = {
				pos = Vector(53.09,26.85,35.88),
				colorB = 200,
				colorA = 150,
			},
		},
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(-59.32,13.07,12.77),
		ang = Angle(0,180,0),
	},
}
