
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "MGB GT"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/MG_MGB/mgbgt.mdl"

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
		}
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
}
