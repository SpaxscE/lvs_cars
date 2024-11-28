
ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "Half-track"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.VehicleCategory = "Cars"
ENT.VehicleSubCategory = "Armored"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/m5m16/m5m16.mdl"

ENT.AITEAM = 2

ENT.MaxHealth = 500
ENT.MaxHealthEngine = 400
ENT.MaxHealthFuelTank = 100

--damage system
ENT.CannonArmorPenetration = 2700
ENT.CannonArmorPenetration1km = 1200

ENT.MaxVelocity = 700
ENT.MaxVelocityReverse = 250

ENT.EngineCurve = 0
ENT.EngineTorque = 175

ENT.TransGears = 3
ENT.TransGearsReverse = 1

ENT.lvsShowInSpawner = true

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

ENT.ExhaustPositions = {
	{
		pos = Vector(-49.71,-39.44,25.4),
		ang = Angle(0,-142.92,-24.29),
	},
}

function ENT:InitWeapons()
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/bullet.png")
	weapon.Ammo = 2000
	weapon.Delay = 0.02
	weapon.HeatRateUp = 0.25
	weapon.HeatRateDown = 0.15
	weapon.Attack = function( ent )
		if not ent:TurretInRange() then
			if IsValid( ent.SNDTurretMG ) then
				ent.SNDTurretMG:Stop()
			end

			return true
		end

		ent._MuzzleID = ent._MuzzleID and ent._MuzzleID + 1 or 1

		if ent._MuzzleID > 4 then
			ent._MuzzleID = 1
		end

		local ID = ent:LookupAttachment( "muzzle_"..ent._MuzzleID )

		local Muzzle = ent:GetAttachment( ID )

		if not Muzzle then return end

		local Pos = Muzzle.Pos
		local Dir =  Muzzle.Ang:Forward()

		local bullet = {}
		bullet.Src 	= Pos
		bullet.Dir 	= (ent:GetEyeTrace().HitPos - Pos):GetNormalized()
		bullet.Spread 	= Vector(0.03,0.03,0.03)
		bullet.TracerName = "lvs_tracer_white"
		bullet.Force	= ent.CannonArmorPenetration
		bullet.Force1km = ent.CannonArmorPenetration1km
		bullet.HullSize 	= 1
		bullet.Damage	= 50
		bullet.Velocity = 20000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo) end
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( Pos )
		effectdata:SetNormal( Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:TakeAmmo( 1 )

		if not IsValid( ent.SNDTurretMG ) then return end

		ent.SNDTurretMG:Play()
	end
	weapon.StartAttack = function( ent )
		if not IsValid( ent.SNDTurretMG ) then return end
		ent.SNDTurretMG:Play()
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent.SNDTurretMG ) then return end
		if not ent.SNDTurretMG:GetActive() then return end

		ent.SNDTurretMG:Stop()
		ent.SNDTurretMG:EmitSound( "lvs/vehicles/halftrack/mc_lastshot.wav" )
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

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/horn.png")
	weapon.Ammo = -1
	weapon.Delay = 0.5
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.UseableByAI = false
	weapon.Attack = function( ent ) end
	weapon.StartAttack = function( ent )
		if not IsValid( ent.HornSND ) then return end
		ent.HornSND:Play()
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent.HornSND ) then return end
		ent.HornSND:Stop()
	end
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
	weapon.OnThink = function( ent, active )
		ent:SetHeat( self.WEAPONS[1][ 1 ]._CurHeat or 0 )
	end
	self:AddWeapon( weapon )
end

