AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_optics.lua" )
include("shared.lua")
include("sh_turret.lua")

function ENT:OnSpawn( PObj )
	self:AddDriverSeat( Vector(0,15,-5), Angle(0,-90,0) )

	self:AddDS( {
		pos = Vector(0,15,0),
		ang = Angle(0,0,0),
		mins = Vector(-16,-16,5),
		maxs = Vector(16,16,50),
		Callback = function( tbl, ent, dmginfo )
			local ply = ent:GetDriver()

			if not IsValid( ply ) then return end

			ent:HurtPlayer( ply, dmginfo:GetDamage(), dmginfo:GetAttacker(), dmginfo:GetInflictor() )
		end
	} )

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/pak40/cannon_fire.wav", "lvs/vehicles/pak40/cannon_fire.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	local WheelModel = "models/blu/pak40_wheel.mdl"

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			SteerAngle = 0,
			BrakeFactor = 1,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(47.2,31,19),
				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),
			} ),

			self:AddWheel( {
				pos = Vector(47.2,-31,19),
				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),

			} ),
		},
		Suspension = {
			Height = 0,
			MaxTravel = 0,
			ControlArmLength = 0,
		},
	} )

	self:AddTrailerHitch( Vector(-98,0,2), LVS.HITCHTYPE_FEMALE )
end

function ENT:OnTick()
	self:AimTurret()
end

function ENT:OnCollision( data, physobj )
	if self:WorldToLocal( data.HitPos ).z < 19 then return true end -- dont detect collision  when the lower part of the model touches the ground

	return false
end

function ENT:OnCoupled( targetVehicle, targetHitch )
	self:SetProngs( true )
end

function ENT:OnDecoupled( targetVehicle, targetHitch )
	self:SetProngs( false )
end

function ENT:OnStartDrag( caller, activator )
	self:SetProngs( true )
end

function ENT:OnStopDrag( caller, activator )
	self:SetProngs( false )
end

function ENT:DoReloadSequence()
	if self._ReloadActive then return end

	self._ReloadActive = true

	self:SetBodygroup(1, 1)

	timer.Simple(0.25, function()
		if not IsValid( self ) then return end

		self:EmitSound("lvs/vehicles/pak40/cannon_unload.wav", 75, 100, 0.5, CHAN_WEAPON )
	end)

	timer.Simple(1, function()
		if not IsValid( self ) then return end

		self:PlayAnimation("reload")

		self:EmitSound("lvs/vehicles/pak40/cannon_reload.wav", 75, 100, 1, CHAN_WEAPON )

		timer.Simple(0.1, function()
			if not IsValid( self ) then return end
			self:SetBodygroup(1, 0)
			self._ReloadActive = nil
		end )
	end )
end

function ENT:DoAttackSequence()
	if not IsValid( self.SNDTurret ) then return end

	self.SNDTurret:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

	self:PlayAnimation("fire2")
	self:DoReloadSequence()
end