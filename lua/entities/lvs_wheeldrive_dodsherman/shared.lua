
ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "DOD:S Sherman Tank"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/blu/tanks/sherman.mdl"

ENT.AITEAM = 2

ENT.MaxHealth = 2700

ENT.MaxVelocity = 450
ENT.MaxVelocityReverse = 450

ENT.EnginePower = 200
ENT.EngineTorque = 200

ENT.TransGears = 2
ENT.TransGearsReverse = 2

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/sherman/eng_idle_loop.wav",
		Volume = 1,
		Pitch = 70,
		PitchMul = 30,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/sherman/eng_loop.wav",
		Volume = 1,
		Pitch = 20,
		PitchMul = 90,
		SoundLevel = 85,
		SoundType = LVS.SOUNDTYPE_NONE,
		UseDoppler = true,
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "DriveWheelFL" )
	self:AddDT( "Entity", "DriveWheelFR" )
end
