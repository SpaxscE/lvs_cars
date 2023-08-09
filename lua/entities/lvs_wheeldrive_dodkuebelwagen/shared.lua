
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Kuebelwagen"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/kubel/kubelwagen.mdl"

ENT.MaxVelocity = 1200

ENT.EnginePower = 2.5
ENT.EngineTorque = 275

ENT.TransGears = 4
ENT.TransGearsReverse = 1
ENT.TransMinGearHoldTime = 1
ENT.TransShiftSpeed = 0.3

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/kuebelwagen/eng_idle_loop.wav",
		Volume = 0.5,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/kuebelwagen/eng_loop.wav",
		Volume = 1,
		Pitch = 100,
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
				pos = Vector(70.57,25.1,33.49),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(70.57,-25.1,33.49),
				colorB = 200,
				colorA = 150,
			},
			[3] = {
				pos = Vector(-71.74,20.47,40.6),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
			[4] = {
				pos = Vector(-71.74,-20.47,40.6),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
		}
	},
	{
		Trigger = "brake",
		SubMaterialID = 2,
		Sprites = {
			[1] = {
				pos = Vector(-71.36,20.51,39.48),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
			[2] = {
				pos = Vector(-71.36,-20.51,39.48),
				colorG = 0,
				colorB = 0,
				colorA = 150,
			},
		}
	},
}