
function ENT:SetupDriverSeat( data )
	local data = self:GetVehicleParams()

	local AttachmentID = self:LookupAttachment( "vehicle_driver_eyes" )
	local AttachmentID2 = self:LookupAttachment( "vehicle_passenger0_eyes" )

	local a_data1 = self:GetAttachment( AttachmentID )
	local a_data2 = self:GetAttachment( AttachmentID2 )

	local ID
	local ViewPos

	if a_data1 then
		ID = AttachmentID
		ViewPos = a_data1
		
	elseif a_data2 then
		ID = AttachmentID2
		ViewPos = a_data2

	else
		ID = false
		ViewPos = {Ang = self:LocalToWorldAngles( Angle(0, 90,0) ),Pos = self:GetPos()}
	end

	local ViewAng = ViewPos.Ang - Angle(0,0,data.SeatPitch)
	ViewAng:RotateAroundAxis(self:GetUp(), -90 - (data.SeatYaw or 0))

	local ViewPos = ViewPos.Pos

	local Pod = self:AddDriverSeat( self:WorldToLocal( ViewPos ), self:WorldToLocalAngles( ViewAng ) )
	Pod:SetKeyValue( "limitview", data.LimitView and 1 or 0 )
	Pod:SetPos( ViewPos + Pod:GetUp() * (-34 + data.SeatOffset.z) + Pod:GetRight() * (data.SeatOffset.y) + Pod:GetForward() * (-6 + data.SeatOffset.x) )

	if ID ~= false then
		Pod:SetParent( self , ID )
	else
		Pod:SetParent( self )
	end
end

function ENT:SetupPassengerSeat( data )
	local data = self:GetVehicleParams()

	if not istable( data.PassengerSeats ) then return end

	for _, v in pairs( data.PassengerSeats ) do
		if not isvector( v.pos ) or not isangle( v.ang ) then continue end

		self:AddPassengerSeat( v.pos, v.ang )
	end
end

function ENT:SetupPhysics()
	local data = self:GetVehicleParams()

	local PhysObj = self:GetPhysicsObject()

	if not IsValid( PhysObj ) then return end

	PhysObj:SetDragCoefficient( data.AirFriction or -250 )
	PhysObj:SetMass( data.Mass * 0.75 )
	
	if data.Inertia then
		PhysObj:SetInertia( data.Inertia ) 
	end
end
