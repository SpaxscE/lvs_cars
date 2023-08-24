
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "DOD:S Panzerspaehwagen"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/222/222.mdl"

ENT.AITEAM = 1

ENT.MaxVelocity = 1100

ENT.EngineCurve = 0.35
ENT.EngineTorque = 120

ENT.TransGears = 5
ENT.TransGearsReverse = 5

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
