
ENT.FireTrailScale = 0.35

DEFINE_BASECLASS( "lvs_base" )

function ENT:IsEngineStartAllowed()
	if hook.Run( "LVS.IsEngineStartAllowed", self ) == false then return false end

	if self:GetHP() <= self:GetMaxHP() * 0.25 then return false end

	if self:WaterLevel() > self.WaterLevelPreventStart then return false end

	local FuelTank = self:GetFuelTank()

	if IsValid( FuelTank ) and FuelTank:GetFuel() <= 0 then return false end

	return true
end

function ENT:OnTakeDamage( dmginfo )
	BaseClass.OnTakeDamage( self, dmginfo )

	if self:GetEngineActive() and self:GetHP() <= self:GetMaxHP() * 0.25 then
		self:ShutDownEngine()

		net.Start( "lvs_car_break" )
			net.WriteEntity( self )
		net.Broadcast()
	end
end

function ENT:ShutDownEngine()
	if not self:GetEngineActive() then return end

	self:SetThrottle( 0 )
	self:StopEngine()
end

function ENT:TakeCollisionDamage( damage, attacker )
end
