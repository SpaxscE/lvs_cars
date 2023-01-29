
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
