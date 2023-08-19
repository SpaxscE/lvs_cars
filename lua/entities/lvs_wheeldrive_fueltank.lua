AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

ENT.MaxHealth = 100

function ENT:GetMaxHP()
	return self.MaxHealth
end

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )
	self:NetworkVar( "Entity",1, "DoorHandler" )

	self:NetworkVar( "Float",0, "Fuel" )
	self:NetworkVar( "Float",1, "Size" )
	self:NetworkVar( "Float",2, "HP" )

	self:NetworkVar( "Int",0, "FuelType" )

	self:NetworkVar( "Bool",0, "Destroyed" )

	if SERVER then
		self:SetHP( self:GetMaxHP() )
		self:SetFuel( 1 )
		self:NetworkVarNotify( "Fuel", self.OnFuelChanged )
	end
end

if SERVER then
	function ENT:Initialize()	
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		self:DrawShadow( false )
		debugoverlay.Cross( self:GetPos(), 20, 5, Color( 255, 93, 0 ) )
	end

	function ENT:Think()
		self:NextThink( CurTime() + 1 )

		if self:GetDestroyed() then
			local Base = self:GetBase()

			if not IsValid( Base ) then return end

			if self:GetFuel() > 0 then
				self:NextThink( CurTime() + 0.1 )

				Base:TakeDamage( 0.99 )

				self:SetFuel( math.max( self:GetFuel() - 0.001, 0 ) )
			else
				self:SetHP( self:GetMaxHP() )
				self:SetDestroyed( false )
			end
		else
			local base = self:GetBase()

			if IsValid( base ) and base:GetEngineActive() then
				self:SetFuel( math.max( self:GetFuel() - (1 / self:GetSize()) * base:GetThrottle() ^ 2, 0 ) )
			end
		end

		return true
	end

	function ENT:OnTakeDamage( dmginfo )
		if self:GetDestroyed() then return end

		local Damage = dmginfo:GetDamage()

		if Damage <= 0 then return end

		local CurHealth = self:GetHP()

		local NewHealth = math.Clamp( CurHealth - Damage, 0, self:GetMaxHP() )

		self:SetHP( NewHealth )

		if NewHealth <= 0 then
			self:SetDestroyed( true )
			self:EmitSound("ambient/fire/ignite.wav")
		end
	end

	function ENT:OnFuelChanged( name, old, new)
		if new == old then return end

		if new <= 0 then
			local base = self:GetBase()

			if not IsValid( base ) then return end

			base:ShutDownEngine()

			local engine = base:GetEngine()

			if not IsValid( engine ) then return end

			engine:EmitSound("vehicles/jetski/jetski_off.wav")
		end
	end

	return
end

function ENT:Initialize()
end

function ENT:RemoveFireSound()
	if self.snd then
		self.snd:Stop()
		self.snd = nil
	end

	self.stopped = nil
end

function ENT:StopFireSound()
	if self.stopped or not self.snd then return end

	self.stopped = true

	self.snd:ChangeVolume( 0, 0.5 )

	timer.Simple( 1, function()
		if not IsValid( self ) then return end

		self:RemoveFireSound()
	end )
end

function ENT:StartFireSound()
	if self.stopped or self.snd then return end

	self.snd = CreateSound( self, "ambient/fire/fire_med_loop1.wav" )
	self.snd:PlayEx(0,100)
	self.snd:ChangeVolume( LVS.EngineVolume, 1 )
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
	util.Effect( "lvs_carfueltank_fire", effectdata )
end

