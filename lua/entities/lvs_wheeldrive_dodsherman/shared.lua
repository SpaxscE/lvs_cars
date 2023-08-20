
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

ENT.EngineTorque = 200

ENT.TransGears = 3
ENT.TransGearsReverse = 3

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

	self:AddDT( "Float", "TurretPitch" )
	self:AddDT( "Float", "TurretYaw" )
end

function ENT:AimTurret()
	local AimAngles = self:WorldToLocalAngles( self:GetAimVector():Angle() )

	local AimRate = 25 * FrameTime() 

	self:SetTurretPitch( math.ApproachAngle( self:GetTurretPitch(), AimAngles.p, AimRate ) )
	self:SetTurretYaw( math.ApproachAngle( self:GetTurretYaw(), AimAngles.y, AimRate ) )

	self:SetPoseParameter("turret_pitch", self:GetTurretPitch() )
	self:SetPoseParameter("turret_yaw", self:GetTurretYaw() )
end

function ENT:InitWeapons()
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/bullet.png")
	weapon.Ammo = 1000
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )
		local ID = ent:LookupAttachment( "turret_cannon" )

		local Muzzle = ent:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= Muzzle.Ang:Up()
		bullet.Spread 	= Vector( 0.015,  0.015, 0 )
		bullet.TracerName = "lvs_tracer_orange"
		bullet.Force	= 10
		bullet.HullSize 	= 15
		bullet.Damage	= 10
		bullet.Velocity = 30000
		bullet.SplashDamage = 150
		bullet.SplashDamageRadius = 150
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo) end
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( bullet.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:TakeAmmo( 1 )
	end
	weapon.OnThink = function( ent, active )
		ent:AimTurret()
	end
	weapon.StartAttack = function( ent )
		if not IsValid( ent.SNDTurret ) then return end
		ent.SNDTurret:Play()
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent.SNDTurret ) then return end
		ent.SNDTurret:Stop()
	end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end

	self:AddWeapon( weapon )
end

