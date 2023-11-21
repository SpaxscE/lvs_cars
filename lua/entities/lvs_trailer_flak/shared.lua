
ENT.Base = "lvs_base_wheeldrive_trailer"

ENT.PrintName = "FlaK"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS]"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/blu/flak38.mdl"

ENT.AITEAM = 1

ENT.PhysicsWeightScale = 0
ENT.PhysicsMass = 450
ENT.PhysicsInertia = Vector(475,452,162)
ENT.PhysicsDampingSpeed = 4000
ENT.PhysicsDampingForward = false
ENT.PhysicsDampingReverse = false

function ENT:InitWeapons()
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/bullet_ap.png")
	weapon.Ammo = 1500
	weapon.Delay = 0.25
	weapon.HeatRateUp = 0.25
	weapon.HeatRateDown = 0.5
	weapon.Attack = function( ent )

		if not ent:TurretInRange() then
			return true
		end

		local ID = ent:LookupAttachment( "muzzle" )

		local Muzzle = ent:GetAttachment( ID )

		if not Muzzle then return end

		local Pos = Muzzle.Pos
		local Dir = (ent:GetEyeTrace().HitPos - Pos):GetNormalized()

		local bullet = {}
		bullet.Src 	= Pos
		bullet.Dir 	= Dir
		bullet.Spread 	= Vector(0,0,0)
		bullet.TracerName = "lvs_tracer_autocannon"
		bullet.Force	= 1500
		bullet.HullSize 	= math.Round( math.min( 200 * math.abs( Dir.z ), 50 ), 0 )
		bullet.Damage	= 5
		bullet.SplashDamage = 75
		bullet.SplashDamageRadius = 180
		bullet.SplashDamageEffect = "lvs_defence_explosion"
		bullet.SplashDamageType = DMG_BLAST
		bullet.Velocity = 30000
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( bullet.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:PlayAnimation( "fire" )

		ent:TakeAmmo( 1 )

		if not IsValid( ent.SNDTurret ) then return end

		ent.SNDTurret:PlayOnce( 100 + math.cos( CurTime() + ent:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	weapon.OnOverheat = function( ent )
		ent:EmitSound("lvs/vehicles/222/cannon_overheat.wav")
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen()

		local Col =  ent:TurretInRange() and Color(255,255,255,255) or Color(255,0,0,255)

		ent:PaintCrosshairCenter( Pos2D, Col )
		ent:PaintCrosshairOuter( Pos2D, Col )
		ent:LVSPaintHitMarker( Pos2D )
	end
	self:AddWeapon( weapon )
end

