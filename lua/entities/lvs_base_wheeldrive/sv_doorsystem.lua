DEFINE_BASECLASS( "lvs_base" )

function ENT:Use( ply )
	if istable( self._DoorHandlers ) then 
		if not IsValid( ply ) then return end

		if self:GetlvsLockedStatus() or (LVS.TeamPassenger:GetBool() and ((self:GetAITEAM() ~= ply:lvsGetAITeam()) and ply:lvsGetAITeam() ~= 0 and self:GetAITEAM() ~= 0)) then 

			self:EmitSound( "doors/default_locked.wav" )

			return
		end

		local HasDoor, Door = self:GetDoorHandler( ply:GetPos() )

		if HasDoor then
			if Door:IsOpen() then
				Door:Close()

				self:SetPassenger( ply )
			else
				Door:Open()
			end
		end

		return
	end

	BaseClass.Use( self, ply )
end

function ENT:AddDoorHandler( pos, poseparameter )
	if not isvector( pos ) or not isstring( poseparameter ) then return end

	local Handler = ents.Create( "lvs_wheeldriver_doorhandler" )

	if not IsValid( Handler ) then
		return
	end

	Handler:SetPos( self:LocalToWorld( pos ) )
	Handler:SetAngles( self:GetAngles() )
	Handler:Spawn()
	Handler:Activate()
	Handler:SetParent( self )
	Handler:SetBase( self )
	Handler:SetPoseName( poseparameter )

	self:DeleteOnRemove( Handler )

	self:TransferCPPI( Handler )

	if not istable( self._DoorHandlers ) then
		self._DoorHandlers = {}
	end

	table.insert( self._DoorHandlers, Handler )

	return Handler
end

function ENT:GetDoorHandler( pos )
	if not istable( self._DoorHandlers ) then return false end

	local radius = 50
	local target = NULL

	for _, door in pairs( self._DoorHandlers ) do
		local dist = (pos - door:GetPos()):Length()

		if dist < radius then
			target = door
			radius = dist
		end
	end

	return IsValid( target ), target
end