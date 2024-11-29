
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "Panzerspaehwagen"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.VehicleCategory = "Cars"
ENT.VehicleSubCategory = "Armored"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/222/222.mdl"

ENT.AITEAM = 1

ENT.MaxHealth = 750
ENT.MaxHealthEngine = 400
ENT.MaxHealthFuelTank = 100

--damage system
ENT.DSArmorIgnoreForce = 1200
ENT.CannonArmorPenetration = 3900


ENT.MaxVelocity = 1000

ENT.EngineCurve = 0.2
ENT.EngineTorque = 200

ENT.TransGears = 5
ENT.TransGearsReverse = 5

ENT.FastSteerAngleClamp = 5
ENT.FastSteerDeactivationDriftAngle = 12

ENT.PhysicsWeightScale = 1.5
ENT.PhysicsDampingForward = true
ENT.PhysicsDampingReverse = true

ENT.lvsShowInSpawner = true

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/222/eng_idle_loop.wav",
		Volume = 0.5,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/222/eng_loop.wav",
		Volume = 1,
		Pitch = 70,
		PitchMul = 100,
		SoundLevel = 75,
		UseDoppler = true,
	},
}

ENT.Lights = {
	{
		Trigger = "main",
		SubMaterialID = 1,
		Sprites = {
			[1] = {
				pos = Vector(-21.76,92.74,44.5),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(21.76,92.74,44.5),
				colorB = 200,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(-21.76,92.74,44.5),
				ang = Angle(0,90,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(21.76,92.74,44.5),
				ang = Angle(0,90,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
	{
		Trigger = "high",
		Sprites = {
			[1] = {
				pos = Vector(-21.76,92.74,44.5),
				colorB = 200,
				colorA = 150,
			},
			[2] = {
				pos = Vector(21.76,92.74,44.5),
				colorB = 200,
				colorA = 150,
			},
		},
		ProjectedTextures = {
			[1] = {
				pos = Vector(-21.76,92.74,44.5),
				ang = Angle(0,90,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
			[2] = {
				pos = Vector(21.76,92.74,44.5),
				ang = Angle(0,90,0),
				colorB = 200,
				colorA = 150,
				shadows = true,
			},
		},
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
end

function ENT:InitWeapons()
	local COLOR_WHITE = Color(255,255,255,255)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 1000
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )
		local ID = ent:LookupAttachment( "muzzle_mg" )

		local Muzzle = ent:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= Muzzle.Ang:Forward()
		bullet.Spread = Vector(0.01,0.01,0.01)
		bullet.TracerName = "lvs_tracer_yellow_small"
		bullet.Force	= 10
		bullet.EnableBallistics = true
		bullet.HullSize 	= 0
		bullet.Damage	= 25
		bullet.Velocity = 15000
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( bullet.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:TakeAmmo( 1 )
	end
	weapon.StartAttack = function( ent )
		if not IsValid( ent.SNDTurretMG ) then return end
		ent.SNDTurretMG:Play()
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent.SNDTurretMG ) then return end
		ent.SNDTurretMG:Stop()
	end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	weapon.HudPaint = function( ent, X, Y, ply )
		local ID = ent:LookupAttachment( "muzzle_mg" )

		local Muzzle = ent:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
				filter = ent:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			ent:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )
			ent:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	weapon.OnOverheat = function( ent )
		ent:EmitSound("lvs/overheat.wav")
	end
	self:AddWeapon( weapon )


	local weapon = {}
	weapon.Icon = Material("lvs/weapons/bullet_ap.png")
	weapon.Ammo = 250
	weapon.Delay = 0.25
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.2
	weapon.Attack = function( ent )
		local ID = ent:LookupAttachment( "muzzle_turret" )

		local Muzzle = ent:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= Muzzle.Ang:Forward()
		bullet.Spread 	= Vector(0.01,0.01,0.01)
		bullet.TracerName = "lvs_tracer_autocannon"
		bullet.Force	= ent.CannonArmorPenetration
		bullet.EnableBallistics = true
		bullet.HullSize 	= 0
		bullet.Damage	= 100
		bullet.Velocity = 14000
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( bullet.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:PlayAnimation( "turret_fire" )

		local PhysObj = ent:GetPhysicsObject()
		if IsValid( PhysObj ) then
			PhysObj:ApplyForceOffset( -bullet.Dir * 10000, bullet.Src )
		end

		ent:TakeAmmo( 1 )

		if not IsValid( ent.SNDTurret ) then return end

		ent.SNDTurret:PlayOnce( 100 + math.cos( CurTime() + ent:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local ID = ent:LookupAttachment(  "muzzle_turret" )

		local Muzzle = ent:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
				filter = ent:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			ent:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )
			ent:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	weapon.OnOverheat = function( ent )
		ent:EmitSound("lvs/vehicles/222/cannon_overheat.wav")
	end
	self:AddWeapon( weapon )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.OnSelect = function( ent )
		if ent.SetTurretEnabled then
			ent:SetTurretEnabled( false )
		end
	end
	weapon.OnDeselect = function( ent )
		if ent.SetTurretEnabled then
			ent:SetTurretEnabled( true )
		end
	end
	self:AddWeapon( weapon )
end


ENT.ExhaustPositions = {
	{
		pos = Vector(-20.98,-56.09,17.55),
		ang = Angle(90,0,0),
	},
	{
		pos = Vector(20.98,-56.09,17.55),
		ang = Angle(90,0,0),
	},
}
