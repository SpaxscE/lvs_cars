
ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "T1"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/t1/t1.mdl"

ENT.AITEAM = 2

ENT.MaxHealth = 250

ENT.MaxVelocity = 1200
ENT.MaxVelocityReverse = 1200

ENT.EngineTorque = 200

ENT.TransGears = 1
ENT.TransGearsReverse = 1

ENT.PhysicsWeightScale = 1

ENT.DeleteOnExplode = true

ENT.FastSteerActiveVelocity = 100
ENT.FastSteerAngleClamp = 10

ENT.GibModels = {
	"models/diggerthings/t1/gib1.mdl",
	"models/diggerthings/t1/gib2.mdl",
	"models/diggerthings/t1/gib3.mdl",
	"models/diggerthings/t1/gib4.mdl",
	"models/diggerthings/t1/gib5.mdl",
	"models/diggerthings/t1/gib6.mdl",
	"models/diggerthings/t1/gib7.mdl",
	"models/diggerthings/t1/gib8.mdl",
	"models/diggerthings/t1/gib9.mdl",
	"models/diggerthings/t1/gib10.mdl",
}

ENT.EngineSounds = {
	{
		sound = "npc/turret_wall/turret_loop1.wav",
		Volume = 1,
		Pitch = 20,
		PitchMul = 80,
		SoundLevel = 85,
		SoundType = LVS.SOUNDTYPE_NONE,
		UseDoppler = true,
	},
}

function ENT:OnSetupDataTables()
	self:AddTracksDT()
end

function ENT:InitWeapons()
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/bullet.png")
	weapon.Ammo = 1000
	weapon.Delay = 0.015
	weapon.HeatRateUp = 0.1
	weapon.HeatRateDown = 0.5
	weapon.Attack = function( ent )
		local ID_L = ent:LookupAttachment( "muzzle_left" )
		local ID_R = ent:LookupAttachment( "muzzle_right" )
		local MuzzleL = ent:GetAttachment( ID_L )
		local MuzzleR = ent:GetAttachment( ID_R )

		if not MuzzleL or not MuzzleR then return end

		ent.MirrorPrimary = not ent.MirrorPrimary

		local Pos = ent.MirrorPrimary and MuzzleL.Pos or MuzzleR.Pos

		local bullet = {}
		bullet.Src 	= Pos
		bullet.Dir 	= (ent:GetEyeTrace().HitPos - Pos):GetNormalized()
		bullet.Spread 	= Vector(0.01,0.01,0.01)
		bullet.TracerName = "lvs_tracer_orange"
		bullet.Force	= 10
		bullet.HullSize 	= 1
		bullet.Damage	= 5
		bullet.Velocity = 30000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo) end
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( (ent.MirrorPrimary and MuzzleL.Ang or MuzzleR.Ang):Forward() )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:TakeAmmo( 1 )
	end
	weapon.StartAttack = function( ent )
		if not IsValid( ent.SNDTurret ) then return end
		ent.SNDTurret:Play()
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent.SNDTurret ) then return end
		ent.SNDTurret:Stop()
	end

	self:AddWeapon( weapon )
end
