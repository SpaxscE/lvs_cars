DEFINE_BASECLASS( "lvs_base" )

function ENT:IsUseAllowed( ply )
	if not IsValid( ply ) then return false end

	if self:GetlvsLockedStatus() or (LVS.TeamPassenger:GetBool() and ((self:GetAITEAM() ~= ply:lvsGetAITeam()) and ply:lvsGetAITeam() ~= 0 and self:GetAITEAM() ~= 0)) then 
		self:EmitSound( "doors/default_locked.wav" )

		return false
	end

	return true
end

function ENT:Use( ply )
	if istable( self._DoorHandlers ) then
		if ply:KeyDown( IN_SPEED ) then
			return
		else
			if not self:IsUseAllowed( ply ) then return end

			local Handler = self:GetDoorHandler( ply )

			if IsValid( Handler ) then
				local Pod = Handler:GetLinkedSeat()

				if IsValid( Pod ) then
					if not Handler:IsOpen() then Handler:Open( ply ) return end

					if Handler:IsOpen() then
						Handler:Close( ply )
					else
						Handler:OpenAndClose( ply )
					end

					if ply:KeyDown( IN_WALK ) then
						
						BaseClass.Use( self, ply )

						return
					else
						if not IsValid( Pod:GetDriver() ) then
							ply:EnterVehicle( Pod )
							self:AlignView( ply )
						end
					end
				else
					Handler:Use( ply )
				end

				return
			else
				if ply:GetMoveType() == MOVETYPE_WALK then return end
			end
		end
	end

	BaseClass.Use( self, ply )
end

function ENT:AddDoorHandler( poseparameter, pos, ang, mins, maxs, openmins, openmaxs )
	if not isvector( pos ) or not isangle( ang ) or not isvector( mins ) or not isvector( maxs ) or not isstring( poseparameter ) then return end

	if not isvector( openmins ) then
		openmins = mins
	end

	if not isvector( openmaxs ) then
		openmaxs = maxs
	end

	local Handler = ents.Create( "lvs_wheeldrive_doorhandler" )

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
	Handler:SetMinsOpen( openmins )
	Handler:SetMinsClosed( mins )

	Handler:SetMaxs( maxs )
	Handler:SetMaxsOpen( openmaxs )
	Handler:SetMaxsClosed( maxs )

	Handler:SetPoseName( poseparameter )

	self:DeleteOnRemove( Handler )

	self:TransferCPPI( Handler )

	if not istable( self._DoorHandlers ) then
		self._DoorHandlers = {}
	end

	table.insert( self._DoorHandlers, Handler )

	return Handler
end

function ENT:GetDoorHandler( ply )
	if not IsValid( ply ) or not istable( self._DoorHandlers ) then return NULL end

	local ShootPos = ply:GetShootPos()
	local AimVector = ply:GetAimVector()

	local radius = 99999999999
	local target = NULL

	for _, doorHandler in pairs( self._DoorHandlers ) do
		if not IsValid( doorHandler ) then continue end

		local boxOrigin = doorHandler:GetPos()
		local boxAngles = doorHandler:GetAngles()
		local boxMins = doorHandler:GetMins()
		local boxMaxs = doorHandler:GetMaxs()

		local HitPos, _, _ = util.IntersectRayWithOBB( ShootPos, AimVector * doorHandler.UseRange, boxOrigin, boxAngles, boxMins, boxMaxs )

		local InRange = isvector( HitPos )

		if not InRange then continue end

		local dist = (ShootPos - HitPos):Length()

		if dist < radius then
			target = doorHandler
			radius = dist
		end
	end

	return target
end