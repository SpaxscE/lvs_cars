AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )
	self:NetworkVar( "Entity",1, "DoorHandler" )
	self:NetworkVar( "Float",0, "Fuel" )
	self:NetworkVar( "Float",1, "Size" )
	self:NetworkVar( "Int",0, "FuelType" )

	if SERVER then
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

		local base = self:GetBase()

		if IsValid( base ) and base:GetEngineActive() then
			self:SetFuel( self:GetFuel() - (1 / self:GetSize()) * base:GetThrottle() ^ 2 )
		end

		return true
	end

	function ENT:OnTakeDamage( dmginfo )
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

function ENT:Think()
end

function ENT:OnRemove()
end

function ENT:Draw()
end
