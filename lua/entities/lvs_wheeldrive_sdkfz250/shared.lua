
ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "Schuetzenpanzerwagen"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.VehicleCategory = "Cars"
ENT.VehicleSubCategory = "Armored"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/sdkfz250/2501.mdl"
ENT.MDL_DESTROYED = "models/diggercars/sdkfz250/250_dead.mdl"

ENT.AITEAM = 1

ENT.DSArmorIgnoreForce = 1000

ENT.MaxHealth = 500
ENT.MaxHealthEngine = 400
ENT.MaxHealthFuelTank = 100

--damage system
ENT.CannonArmorPenetration = 2700

ENT.MaxVelocity = 700
ENT.MaxVelocityReverse = 250

ENT.EngineCurve = 0.7
ENT.EngineTorque = 100

ENT.PhysicsWeightScale = 1.5
ENT.PhysicsInertia = Vector(2500,2500,850)

ENT.TransGears = 3
ENT.TransGearsReverse = 1

ENT.lvsShowInSpawner = true

ENT.HornSound = "lvs/horn1.wav"
ENT.HornPos = Vector(70,0,40)

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/sdkfz250/eng_idle_loop.wav",
		Volume = 0.5,
		Pitch = 85,
		PitchMul = 25,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/sdkfz250/eng_loop.wav",
		Volume = 1,
		Pitch = 20,
		PitchMul = 100,
		SoundLevel = 85,
		SoundType = LVS.SOUNDTYPE_REV_UP,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/sdkfz250/eng_revdown_loop.wav",
		Volume = 1,
		Pitch = 20,
		PitchMul = 100,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_REV_DOWN,
		UseDoppler = true,
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(35.31,39.22,26.35),
		ang = Angle(0,90,0),
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "FrontGunnerSeat" )
	self:AddDT( "Entity", "RearGunnerSeat" )
	self:AddDT( "Bool", "UseHighExplosive" )
end

function ENT:InitWeapons()
	self:AddGunnerWeapons()
	self:AddTopGunnerWeapons()
end


function ENT:GunnerInRange( Dir )
	return self:AngleBetweenNormal( self:GetForward(), Dir ) < 35
end

function ENT:AddGunnerWeapons()
	local COLOR_RED = Color(255,0,0,255)
	local COLOR_WHITE = Color(255,255,255,255)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 1000
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		if not base:GunnerInRange( ent:GetAimVector() ) then

			if not IsValid( base.SNDTurretMGf ) then return true end

			base.SNDTurretMGf:Stop()
	
			return true
		end

		local ID = base:LookupAttachment( "f_muzzle" )

		local Muzzle = base:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= (ent:GetEyeTrace().HitPos - bullet.Src):GetNormalized()
		bullet.Spread 	= Vector(0.015,0.015,0.015)
		bullet.TracerName = "lvs_tracer_yellow_small"
		bullet.Force	= 10
		bullet.HullSize 	= 0
		bullet.Damage	= 25
		bullet.Velocity = 30000
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( Muzzle.Ang:Forward() )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:TakeAmmo( 1 )

		base:PlayAnimation( "shot_f" )

		if not IsValid( base.SNDTurretMGf ) then return end

		base.SNDTurretMGf:Play()
	end
	weapon.StartAttack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not IsValid( base.SNDTurretMGf ) then return end

		base.SNDTurretMGf:Play()
	end
	weapon.FinishAttack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not IsValid( base.SNDTurretMGf ) then return end

		base.SNDTurretMGf:Stop()
	end
	weapon.OnThink = function( ent, active )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		if not ent:GetAI() and not IsValid( ent:GetDriver() ) then
			base:SetPoseParameter("f_pitch",  15 )
			base:SetPoseParameter("f_yaw", 0 )

			return
		end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		base:SetPoseParameter("f_yaw", -Angles.y )
		base:SetPoseParameter("f_pitch",  -Angles.p )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen()

		local Col =  base:GunnerInRange( ent:GetAimVector() ) and COLOR_WHITE or COLOR_RED

		base:PaintCrosshairCenter( Pos2D, Col )
		base:LVSPaintHitMarker( Pos2D )
	end
	weapon.OnOverheat = function( ent )
		ent:EmitSound("lvs/overheat.wav")
	end
	self:AddWeapon( weapon, 2 )
end

function ENT:TopGunnerInRange( ent )
	local AimPos = ent:GetEyeTrace().HitPos
	local AimAng = (AimPos - self:LocalToWorld( Vector(-72.27,0.06,66.07) )):Angle()

	local _, Ang = WorldToLocal( AimPos, AimAng, Vector(-72.27,0,66), self:LocalToWorldAngles( Angle(0,180,0) ) )

	return math.abs( Ang.y ) < 35 and Ang.p < 10 and Ang.p > -80
end

function ENT:AddTopGunnerWeapons()
	local COLOR_RED = Color(255,0,0,255)
	local COLOR_WHITE = Color(255,255,255,255)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 1000
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		if not base:TopGunnerInRange( ent ) then

			if not IsValid( base.SNDTurretMGt ) then return true end

			base.SNDTurretMGt:Stop()
	
			return true
		end

		local ID = base:LookupAttachment( "r_muzzle" )

		local Muzzle = base:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= (ent:GetEyeTrace().HitPos - bullet.Src):GetNormalized()
		bullet.Spread 	= Vector(0.015,0.015,0.015)
		bullet.TracerName = "lvs_tracer_yellow_small"
		bullet.Force	= 10
		bullet.HullSize 	= 0
		bullet.Damage	= 25
		bullet.Velocity = 30000
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( Muzzle.Ang:Forward() )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:TakeAmmo( 1 )

		base:PlayAnimation( "shot_r" )

		if not IsValid( base.SNDTurretMGt ) then return end

		base.SNDTurretMGt:Play()
	end
	weapon.StartAttack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not IsValid( base.SNDTurretMGt ) then return end

		base.SNDTurretMGt:Play()
	end
	weapon.FinishAttack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not IsValid( base.SNDTurretMGt ) then return end

		base.SNDTurretMGt:Stop()
	end
	weapon.OnThink = function( ent, active )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		if not ent:GetAI() and not IsValid( ent:GetDriver() ) then
			base:SetPoseParameter("r_pitch",  80 )
			base:SetPoseParameter("r_yaw", 0 )

			return
		end

		local AimPos = ent:GetEyeTrace().HitPos
		local AimAng = (AimPos - base:LocalToWorld( Vector(-72.27,0.06,66.07) )):Angle()

		local Pos, Ang = WorldToLocal( AimPos, AimAng, Vector(-72.27,0,66), base:LocalToWorldAngles( Angle(0,180,0) ) )

		base:SetPoseParameter("r_pitch",  -Ang.p )
		base:SetPoseParameter("r_yaw", -Ang.y )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen()

		local Col = base:TopGunnerInRange( ent ) and COLOR_WHITE or COLOR_RED

		base:PaintCrosshairCenter( Pos2D, Col )
		base:LVSPaintHitMarker( Pos2D )
	end
	weapon.OnOverheat = function( ent )
		ent:EmitSound("lvs/overheat.wav")
	end
	self:AddWeapon( weapon, 3 )
end


function ENT:CalcMainActivityPassenger( ply )
	local FrontGunnerSeat = self:GetFrontGunnerSeat()
	local RearGunnerSeat = self:GetRearGunnerSeat()

	if not IsValid( FrontGunnerSeat ) or not IsValid( RearGunnerSeat ) then return end

	if FrontGunnerSeat:GetDriver() ~= ply and RearGunnerSeat:GetDriver() ~= ply then return end

	if ply.m_bWasNoclipping then 
		ply.m_bWasNoclipping = nil 
		ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM ) 
		
		if CLIENT then 
			ply:SetIK( true )
		end 
	end 

	ply.CalcIdeal = ACT_STAND
	ply.CalcSeqOverride = ply:LookupSequence( "cwalk_revolver" )

	return ply.CalcIdeal, ply.CalcSeqOverride
end

function ENT:UpdateAnimation( ply, velocity, maxseqgroundspeed )
	ply:SetPlaybackRate( 1 )

	if CLIENT then
		local FrontGunnerSeat = self:GetFrontGunnerSeat()
		local RearGunnerSeat = self:GetRearGunnerSeat()

		if ply == self:GetDriver() then
			ply:SetPoseParameter( "vehicle_steer", self:GetSteer() /  self:GetMaxSteerAngle() )
			ply:InvalidateBoneCache()
		end

		if IsValid( FrontGunnerSeat ) and FrontGunnerSeat:GetDriver() == ply then
			local Pitch = math.Remap( self:GetPoseParameter( "f_pitch" ),0,1,-15,15)
			local Yaw = math.Remap( self:GetPoseParameter( "f_yaw" ),0,1,-35,35) 

			ply:SetPoseParameter( "aim_pitch", Pitch * 1.5 )
			ply:SetPoseParameter( "aim_yaw", Yaw * 1.5 )

			ply:SetPoseParameter( "head_pitch", -Pitch * 2 )
			ply:SetPoseParameter( "head_yaw", -Yaw * 3 )

			ply:SetPoseParameter( "move_x", 0 )
			ply:SetPoseParameter( "move_y", 0 )

			ply:InvalidateBoneCache()
		end

		if IsValid( RearGunnerSeat ) and RearGunnerSeat:GetDriver() == ply then
			local Pitch = math.Remap( self:GetPoseParameter( "r_pitch" ),0,1,-15,15)
			local Yaw = math.Remap( self:GetPoseParameter( "r_yaw" ),0,1,-35,35) 

			ply:SetPoseParameter( "aim_pitch", Pitch * 3 - 10 )
			ply:SetPoseParameter( "aim_yaw", Yaw * 1.5 )

			ply:SetPoseParameter( "head_pitch", -Pitch * 2 )
			ply:SetPoseParameter( "head_yaw", -Yaw * 3 )

			ply:SetPoseParameter( "move_x", 0 )
			ply:SetPoseParameter( "move_y", 0 )

			ply:InvalidateBoneCache()
		end

		GAMEMODE:GrabEarAnimation( ply )
		GAMEMODE:MouthMoveAnimation( ply )
	end

	return false
end

