
ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "DOD:S Half-track US"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/m5m16/m5m16.mdl"

ENT.AITEAM = 1

ENT.MaxVelocity = 700
ENT.MaxVelocityReverse = 250

ENT.EngineCurve = 0
ENT.EngineTorque = 175

ENT.TransGears = 3
ENT.TransGearsReverse = 1

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

function ENT:OnSetupDataTables()
	self:AddTracksDT()
end