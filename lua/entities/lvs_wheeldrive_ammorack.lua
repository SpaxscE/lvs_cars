AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )

	self:NetworkVar( "Float",0, "HP" )
	self:NetworkVar( "Float",1, "MaxHP" )

	self:NetworkVar( "Bool",0, "Destroyed" )

	if SERVER then
		self:SetMaxHP( 500 )
		self:SetHP( 500 )
	end
end

if SERVER then
	function ENT:Initialize()	
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		self:DrawShadow( false )
		debugoverlay.Cross( self:GetPos(), 20, 5, Color( 255, 93, 0 ) )
	end

	function ENT:ExtinguishAndRepair()
		self:SetHP( self:GetMaxHP() )
		self:SetDestroyed( false )
	end

	function ENT:Think()
		self:NextThink( CurTime() + 1 )

		if self:GetDestroyed() then
			local Base = self:GetBase()

			if not IsValid( Base ) then return end

			local dmg = DamageInfo()
			dmg:SetDamage( 100 )
			dmg:SetAttacker( IsValid( Base.LastAttacker ) and Base.LastAttacker or game.GetWorld() )
			dmg:SetInflictor( IsValid(  Base.LastInflictor ) and Base.LastInflictor or game.GetWorld() )
			dmg:SetDamageType( DMG_BURN )
			Base:TakeDamageInfo( dmg )
		end

		return true
	end

	function ENT:TakeTransmittedDamage( dmginfo )
		if self:GetDestroyed() then return end

		local Damage = dmginfo:GetDamage()

		if Damage <= 0 then return end

		local CurHealth = self:GetHP()

		local NewHealth = math.Clamp( CurHealth - Damage, 0, self:GetMaxHP() )

		self:SetHP( NewHealth )

		if NewHealth <= 0 then
			self:SetDestroyed( true )
		end
	end

	function ENT:OnTakeDamage( dmginfo )
	end

	return
end

function ENT:Initialize()
end

function ENT:RemoveFireSound()
	if self.FireBurnSND then
		self.FireBurnSND:Stop()
		self.FireBurnSND = nil
	end

	self.ShouldStopFire = nil
end

function ENT:StopFireSound()
	if self.ShouldStopFire or not self.FireBurnSND then return end

	self.ShouldStopFire = true

	self:EmitSound("ambient/fire/mtov_flame2.wav")

	self.FireBurnSND:ChangeVolume( 0, 0.5 )

	timer.Simple( 1, function()
		if not IsValid( self ) then return end

		self:RemoveFireSound()
	end )
end

function ENT:StartFireSound()
	if self.ShouldStopFire or self.FireBurnSND then return end

	self.FireBurnSND = CreateSound( self, "lvs/ammo_fire_loop.wav" )
	self.FireBurnSND:SetSoundLevel( 85 )

	self.FireBurnSND:PlayEx(0,100)

	self.FireBurnSND:ChangeVolume( 1, 1 )

	self:EmitSound("lvs/ammo_fire.wav")
end

function ENT:OnRemove()
	self:RemoveFireSound()
end

function ENT:Draw()
end

function ENT:Think()
	self:DamageFX()
end

function ENT:DamageFX()
	if not self:GetDestroyed() then
		self:StopFireSound()

		return
	end

	self:StartFireSound()

	local T = CurTime()

	if (self.nextDFX or 0) > T then return end

	self.nextDFX = T + 0.05

	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		effectdata:SetEntity( self:GetBase() )
	util.Effect( "lvs_ammorack_fire", effectdata )
end

