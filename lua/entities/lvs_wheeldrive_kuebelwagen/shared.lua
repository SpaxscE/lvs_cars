
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Kuebelwagen"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/kubel/kubelwagen.mdl"

ENT.MaxVelocity = 1200

ENT.EnginePower = 25
ENT.EngineTorque = 350

ENT.TransGears = 4
ENT.TransMinGearHoldTime = 1
ENT.TransShiftSpeed = 0.3

ENT.WheelDownForce = 1000
ENT.WheelDownForcePowered = 1000

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/kuebelwagen/engine_low.wav",
		Volume = 0.5,
		Pitch = 85,
		PitchMul = 25,
		Type = 0,
		SoundLevel = 75,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/kuebelwagen/engine_mid.wav",
		Volume = 1,
		Pitch = 100,
		PitchMul = 100,
		Type = 1,
		SoundLevel = 75,
		UseDoppler = true,
	},
}
