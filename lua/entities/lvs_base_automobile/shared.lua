
ENT.Base = "lvs_base"

ENT.PrintName = "[LVS] Automobile Base"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/nissan_bluebird910/chassis.mdl"
ENT.GibModels = { ENT.MDL }

function ENT:SetupDataTables()
	self:CreateBaseDT()

	--self:AddDT( "Bool", "Disabled" )

	--if SERVER then
		--self:NetworkVarNotify( "Disabled", self.OnDisabled )
	--end
end

function ENT:CalcMainActivity( ply )
	if ply ~= self:GetDriver() then return end

	if ply.m_bWasNoclipping then 
		ply.m_bWasNoclipping = nil 
		ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM ) 
		
		if CLIENT then 
			ply:SetIK( true )
		end 
	end 

	ply.CalcIdeal = ACT_STAND
	ply.CalcSeqOverride = ply:LookupSequence( "drive_jeep" )

	return ply.CalcIdeal, ply.CalcSeqOverride
end

ENT.CollisionFilter = {
	[COLLISION_GROUP_DEBRIS] = true,
	[COLLISION_GROUP_DEBRIS_TRIGGER] = true,
	[COLLISION_GROUP_PLAYER] = true,
	[COLLISION_GROUP_WEAPON] = true,
	[COLLISION_GROUP_VEHICLE_CLIP] = true,
	[COLLISION_GROUP_WORLD] = true,
}

function ENT:GetCrosshairFilterLookup()
	if not self:IsInitialized() then return {} end

	if self._EntityLookUp then return self._EntityLookUp end

	self._EntityLookUp = {}

	for _, ent in pairs( self:GetCrosshairFilterEnts() ) do
		self._EntityLookUp[ ent:EntIndex() ] = true
	end

	return self._EntityLookUp
end
