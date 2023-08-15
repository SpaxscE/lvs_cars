
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "DOD:S Sherman Tank"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/blu/tanks/sherman.mdl"

ENT.PhysicsWeightScale = 2

ENT.MaxVelocity = 400
ENT.MaxVelocityReverse = 400

ENT.EnginePower = 0
ENT.EngineTorque = 1000

ENT.TransGears = 3
ENT.TransGearsReverse = 3

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/conapc/eng_idle_loop.wav",
		Volume = 0.5,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/conapc/eng_loop.wav",
		Volume = 1,
		Pitch = 50,
		PitchMul = 100,
		SoundLevel = 75,
		UseDoppler = true,
	},
}
