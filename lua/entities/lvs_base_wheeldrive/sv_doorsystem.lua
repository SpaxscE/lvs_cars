DEFINE_BASECLASS( "lvs_base" )

function ENT:Use( ply )
	if istable( self._DoorHandlers ) then 
		local HasDoor, Door = self:GetDoorHandler( ply:GetPos() )

		if HasDoor then
			if Door:IsOpen() then
				Door:Close()
			else
				Door:Open()

				return
			end
		end
	end

	BaseClass.Use( self, ply )
end

function ENT:AddDoorHandler( pos, boneID, AngleOpen, AngleClosed )
	if not isvector( pos ) or not isnumber( boneID ) or not isangle( AngleOpen ) or not isangle( AngleClosed ) then return end

	local Handler = ents.Create( "lvs_wheeldrive_interaction_handler" )

	if not IsValid( Handler ) then
		return
	end

	Handler:SetPos( self:LocalToWorld( pos ) )
	Handler:SetAngles( self:GetAngles() )
	Handler:Spawn()
	Handler:Activate()
	Handler:SetParent( self )
	Handler:SetBase( self )
	Handler:SetBoneID( boneID )
	Handler:SetAngleOpen( AngleOpen )
	Handler:SetAngleClosed( AngleClosed )

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