
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Mercedes W123"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/DiggerCars/MB_W123/v2.mdl"

ENT.MaxVelocity = 1900

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
