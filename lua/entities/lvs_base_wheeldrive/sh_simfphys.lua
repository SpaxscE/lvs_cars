
local function SetupView( ent, data )
	local AttachmentID = ent:LookupAttachment( "vehicle_driver_eyes" )
	local AttachmentID2 = ent:LookupAttachment( "vehicle_passenger0_eyes" )

	local a_data1 = ent:GetAttachment( AttachmentID )
	local a_data2 = ent:GetAttachment( AttachmentID2 )

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
		ViewPos = {Ang = ent:LocalToWorldAngles( Angle(0, 90,0) ),Pos = ent:GetPos()}
	end

	local ViewAng = ViewPos.Ang - Angle(0,0,data.SeatPitch)
	ViewAng:RotateAroundAxis(ent:GetUp(), -90 - (data.SeatYaw or 0))

	local viewdata = {
		ID = ID,
		ViewPos = ViewPos.Pos,
		ViewAng = ViewAng,
	}

	return viewdata
end


function ENT:InitFromList( vehiclename )

	if CLIENT then return end

	local data = list.Get( "simfphys_vehicles" )[ vehiclename ].Members

	if not data then return end

	self.OnSpawn = function( self, PObj )
		PObj:SetMass( isnumber( data.Mass ) and data.Mass or 1000 )

		local view = SetupView( self, data )

		local Pod = self:AddDriverSeat( self:WorldToLocal( view.ViewPos ), self:WorldToLocalAngles( view.ViewAng ) )
		Pod:SetPos( view.ViewPos + Pod:GetUp() * (-34 + data.SeatOffset.z) + Pod:GetRight() * (data.SeatOffset.y) + Pod:GetForward() * (-6 + data.SeatOffset.x) )

		if view.ID ~= false then
			--self:SetupEnteringAnims()
			Pod:SetParent( self , view.ID )
		else
			Pod:SetParent( self )
		end

		if istable( data.PassengerSeats ) then
			for _, pSeat in pairs( data.PassengerSeats ) do

				if not isvector( pSeat.pos ) or not isangle( pSeat.ang ) then continue end

				self:AddPassengerSeat( pSeat.pos, pSeat.ang )
			end
		end

		if data.CustomWheels then
			--self:CreateWheel(1, WheelFL, self:LocalToWorld( self.CustomWheelPosFL ), self.FrontHeight, self.FrontWheelRadius, false , self:LocalToWorld( self.CustomWheelPosFL + Vector(0,0,self.CustomSuspensionTravel * 0.5) ),self.CustomSuspensionTravel, self.FrontConstant, self.FrontDamping, self.FrontRelativeDamping)
			--self:CreateWheel(2, WheelFR, self:LocalToWorld( self.CustomWheelPosFR ), self.FrontHeight, self.FrontWheelRadius, true , self:LocalToWorld( self.CustomWheelPosFR + Vector(0,0,self.CustomSuspensionTravel * 0.5) ),self.CustomSuspensionTravel, self.FrontConstant, self.FrontDamping, self.FrontRelativeDamping)
			--self:CreateWheel(3, WheelRL, self:LocalToWorld( self.CustomWheelPosRL ), self.RearHeight, self.RearWheelRadius, false , self:LocalToWorld( self.CustomWheelPosRL + Vector(0,0,self.CustomSuspensionTravel * 0.5) ),self.CustomSuspensionTravel, self.RearConstant, self.RearDamping, self.RearRelativeDamping)
			--self:CreateWheel(4, WheelRR, self:LocalToWorld( self.CustomWheelPosRR ), self.RearHeight, self.RearWheelRadius, true , self:LocalToWorld( self.CustomWheelPosRR + Vector(0,0,self.CustomSuspensionTravel * 0.5) ), self.CustomSuspensionTravel, self.RearConstant, self.RearDamping, self.RearRelativeDamping)

			self:SetMassCenter( (data.CustomMassCenter or Vector(0,0,0)) )
		end
	end

	--[[
	self:AddDriverSeat( Vector(-14,14.94,4.2394), Angle(0,-90,7.8) )
	self:AddPassengerSeat( Vector(-3,-14.94,13), Angle(0,-90,20) )

	local WheelModel = "models/props_vehicles/tire001c_car.mdl"
	local WheelRadius = 13

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT, --LVS.WHEEL_STEER_REAR   LVS.WHEEL_STEER_NONE
			SteerAngle = 35,
		},
		Wheels = {
			self:AddWheel( Vector(50.814,-29,12.057), Angle(0,-90,0), WheelModel, WheelRadius ),
			self:AddWheel( Vector(50.814,29,12.057), Angle(0,90,0), WheelModel, WheelRadius ),
		},
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )

	local RearAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
		},
		Wheels = {
			self:AddWheel( Vector(-50.814,-29,12.057), Angle(0,-90,0), WheelModel, WheelRadius ),
			self:AddWheel( Vector(-50.814,29,12.057), Angle(0,90,0), WheelModel, WheelRadius ),
		},
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )

	self:AddEngine( Vector(50,0,20) )
	]]
end