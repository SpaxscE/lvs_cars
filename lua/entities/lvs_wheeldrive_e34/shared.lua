
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "BMW E34"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/BMW_M5E34/e34.mdl"

ENT.MaxVelocity = 2200

ENT.EnginePower = 750
ENT.EngineTorque = 200

ENT.TransGears = 5
ENT.TransMinGearHoldTime = 1
ENT.TransShiftSpeed = 0.3

ENT.WheelDownForce = 500
ENT.WheelDownForcePowered = 2000

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/bmw_m5e34/engine_low.wav",
		Volume = 1,
		Pitch = 85,
		PitchMul = 25,
		Type = 0,
		SoundLevel = 75,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/bmw_m5e34/engine_mid.wav",
		Volume = 1,
		Pitch = 80,
		PitchMul = 110,
		Type = 1,
		SoundLevel = 75,
		UseDoppler = true,
	},
}
