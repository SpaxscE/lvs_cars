
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
		sound = "lvs/vehicles/halftrack/eng_idle_loop.wav",
		Volume = 0.5,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/halftrack/eng_loop.wav",
		Volume = 1,
		Pitch = 50,
		PitchMul = 100,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_UP,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/halftrack/eng_revdown_loop.wav",
		Volume = 1,
		Pitch = 50,
		PitchMul = 100,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_DOWN,
		UseDoppler = true,
	},
}

function ENT:OnSetupDataTables()
	self:AddTracksDT()
end

ENT.Lights = {
	{
		Trigger = "main",
		SubMaterialID = 1,
		Sprites = {
			[1] = {
				pos = Vector(91.57,29.43,50.18),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(91.57,-29.43,50.18),
				colorB = 200,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(91.57,29.43,50.18),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(91.57,-29.43,50.18),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
	{
		Trigger = "high",
		SubMaterialID = 2,
		Sprites = {
			[1] = {
				pos = Vector(96.81,19.99,49.67),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(96.81,-19.99,49.67),
				colorB = 200,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(96.81,19.99,49.67),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(96.81,-19.99,49.67),
				ang = Angle(0,0,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
}
