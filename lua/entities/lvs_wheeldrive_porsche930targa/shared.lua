
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Porsche 911 Targa (-25 0 22)"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/porsche_930/targa.mdl"

ENT.MaxVelocity = 2400

ENT.EnginePower = 2000
ENT.EngineTorque = 150

ENT.TransGears = 5
ENT.TransGearsReverse = 1
ENT.TransMinGearHoldTime = 1
ENT.TransShiftSpeed = 0.3

ENT.PhysicsMass = 700
ENT.PhysicsInertia = Vector(1050,1050,525)

ENT.WheelPhysicsMass = 150
ENT.WheelPhysicsInertia = Vector(15,12,15)

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/ferrari_365/eng_idle_loop.wav",
		Volume = 1,
		Pitch = 70,
		PitchMul = 30,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/ferrari_365/eng_loop.wav",
		Volume = 1,
		Pitch = 80,
		PitchMul = 110,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_UP,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/ferrari_365/eng_revdown_loop.wav",
		Volume = 1,
		Pitch = 80,
		PitchMul = 110,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_DOWN,
		UseDoppler = true,
	},
}
