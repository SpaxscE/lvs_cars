
ENT.Base = "lvs_base_wheeldrive_trailer"

ENT.PrintName = "PAK40"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/blu/pak40.mdl"

ENT.WheelPhysicsMass = 350
ENT.WheelPhysicsInertia = Vector(10,8,10)

ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = Vector(98.77,27.7,16.51), colorB = 200, colorA = 150 },
			{ pos = Vector(98.77,-27.7,16.51), colorB = 200, colorA = 150 },
			{ pos = Vector(-102,10,20), width = 60, height = 50, colorG = 0, colorB = 0, colorA = 80, mat = Material( "sprites/lvs/glow_smooth" ) },
			{ pos = Vector(-102,-10,20), width = 60, height = 50, colorG = 0, colorB = 0, colorA = 80, mat = Material( "sprites/lvs/glow_smooth" ) },
		},
		ProjectedTextures = {
			{ pos = Vector(97.66,27.7,16.51), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(97.66,-27.7,16.51), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "high",
		Sprites = {
			{ pos = Vector(97.66,20.39,16.58), colorB = 200, colorA = 150 },
			{ pos = Vector(97.66,-20.39,16.58), colorB = 200, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = Vector(97.66,20.39,16.58), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
			{ pos = Vector(97.66,-20.39,16.58), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "main+brake+turnleft",
		Sprites = {
			{ pos = Vector(-102,18,20), width = 80, height = 50, colorG = 0, colorB = 0, colorA = 150, mat = "sprites/lvs/glow_smooth" },
			{ pos = Vector(-102,26,20), width = 60, height = 50, colorG = 0, colorB = 0, colorA = 150, mat = "sprites/lvs/glow_smooth" },
		},
	},
	{
		Trigger = "main+brake+turnright",
		Sprites = {
			{ pos = Vector(-102,-18,20), width = 80, height = 50, colorG = 0, colorB = 0, colorA = 150, mat = "sprites/lvs/glow_smooth" },
			{ pos = Vector(-102,-26,20), width = 60, height = 50, colorG = 0, colorB = 0, colorA = 150, mat = "sprites/lvs/glow_smooth" },
		},
	},
	{
		Trigger = "turnright",
		Sprites = {
			{ width = 40, height = 40, pos = Vector(99.23,-24.9,5.96), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "turnleft",
		Sprites = {
			{ width = 40, height = 40, pos = Vector(99.23,24.9,5.96), colorG = 100, colorB = 0, colorA = 150 },
		},
	},
	{
		Trigger = "reverse",
		Sprites = {
			{ pos = Vector(-102.14,-15.04,8.9), height = 25, width = 25, colorA = 150 },
			{ pos = Vector(-102.14,15.04,8.9), height = 25, width = 25, colorA = 150 },
		}
	},
}
