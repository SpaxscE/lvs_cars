DEFINE_BASECLASS( "lvs_base" )

function ENT:Use( ply )
	if istable( self._DoorHandlers ) then
		if ply:KeyDown( IN_SPEED ) then
			return
		end
	end

	BaseClass.Use( self, ply )
end

function ENT:AddDoorHandler( pos, ang, mins, maxs, poseparameter )
	if not isvector( pos ) or not isangle( ang ) or not isvector( mins ) or not isvector( maxs ) or not isstring( poseparameter ) then return end

	local Handler = ents.Create( "lvs_wheeldriver_doorhandler" )

	if not IsValid( Handler ) then
		return
	end

	Handler:SetPos( self:LocalToWorld( pos ) )
	Handler:SetAngles( self:LocalToWorldAngles( ang ) )
	Handler:Spawn()
	Handler:Activate()
	Handler:SetParent( self )
	Handler:SetBase( self )
	Handler:SetMins( mins )
	Handler:SetMaxs( maxs )
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