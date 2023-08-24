
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "DOD:S Panzerspaehwagen"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/222/222.mdl"

ENT.AITEAM = 1

ENT.MaxVelocity = 1000

ENT.EngineCurve = 0.2
ENT.EngineTorque = 200

ENT.TransGears = 5
ENT.TransGearsReverse = 5

ENT.FastSteerAngleClamp = 5
ENT.FastSteerDeactivationDriftAngle = 12

ENT.PhysicsWeightScale = 1.5
ENT.PhysicsDampingForward = true
ENT.PhysicsDampingReverse = true

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
		SubMaterialID = 1,
		Sprites = {
			[1] = {
				pos = Vector(-21.76,92.74,44.5),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(21.76,92.74,44.5),
				colorB = 200,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(-21.76,92.74,44.5),
				ang = Angle(0,90,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(21.76,92.74,44.5),
				ang = Angle(0,90,0),
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
				pos = Vector(-21.76,92.74,44.5),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(21.76,92.74,44.5),
				colorB = 200,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(-21.76,92.74,44.5),
				ang = Angle(0,90,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(21.76,92.74,44.5),
				ang = Angle(0,90,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
}

