
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

		local PodAngles = self:WorldToLocalAngles( view.ViewAng )
		local PodPos = self:WorldToLocal( view.ViewPos )

		local Pod = self:AddDriverSeat( PodPos + PodAngles:Up() * (-34 + data.SeatOffset.z) + PodAngles:Forward() * (data.SeatOffset.y) - PodAngles:Right() * (-6 + data.SeatOffset.x), PodAngles )

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
			if not isstring( data.CustomWheelModel ) or not isvector( data.CustomWheelPosFL ) or not isvector( data.CustomWheelPosFR ) or not isvector( data.CustomWheelPosRL ) or not isvector( data.CustomWheelPosRR ) then return end

			local FrontWheelModel = data.CustomWheelModel
			local RearWheelModel = data.CustomWheelModel_R or FrontWheelModel

			local prop = ents.Create( "prop_physics" )
			prop:SetModel( FrontWheelModel )
			prop:SetPos( self:GetPos() )
			prop:SetAngles( self:GetAngles() )
			prop:Spawn()
			prop:Activate()

			local OBBRadius = prop:OBBMaxs() - prop:OBBMins()

			prop:Remove()

			local FrontWheelRadius = data.FrontWheelRadius or math.max( OBBRadius.x, OBBRadius.y, OBBRadius.z ) * 0.5
			local RearWheelRadius = data.RearWheelRadius or FrontWheelRadius
	
			local pFL = self:LocalToWorld( data.CustomWheelPosFL )
			local pFR = self:LocalToWorld( data.CustomWheelPosFR )
			local pRL = self:LocalToWorld( data.CustomWheelPosRL )
			local pRR = self:LocalToWorld( data.CustomWheelPosRR )

			local pAngL = self:WorldToLocalAngles( ((pFL + pFR) / 2 - (pRL + pRR) / 2):Angle() )
			pAngL.r = 0
			pAngL.p = 0

			local Forward = pAngL
			local Right = Forward - Angle(0,90,0)
			Right:Normalize() 

			local WheelAngRight = Angle( data.CustomWheelAngleOffset.p, data.CustomWheelAngleOffset.y, data.CustomWheelAngleOffset.r )
			WheelAngRight:RotateAroundAxis(Vector(0,0,1), -90)

			local WheelAngLeft = Angle( data.CustomWheelAngleOffset.p, data.CustomWheelAngleOffset.y, data.CustomWheelAngleOffset.r )
			WheelAngLeft:RotateAroundAxis(Vector(0,0,1), 90)

			local FrontAxle = self:DefineAxle( {
				Axle = {
					ForwardAngle = Forward,
					SteerType = LVS.WHEEL_STEER_FRONT,
					SteerAngle = 35,
				},
				Wheels = {
					self:AddWheel( data.CustomWheelPosFL + Vector(0,0,data.CustomSuspensionTravel * 0.5), WheelAngLeft, FrontWheelModel, FrontWheelRadius ),
					self:AddWheel( data.CustomWheelPosFR + Vector(0,0,data.CustomSuspensionTravel * 0.5), WheelAngRight, FrontWheelModel, FrontWheelRadius ),
				},
				Suspension = {
					Height = data.FrontHeight + data.CustomSuspensionTravel * 0.5,
					MaxTravel = data.CustomSuspensionTravel,
					ControlArmLength = 25,
					SpringConstant = data.FrontConstant,
					SpringDamping = data.FrontDamping,
					SpringRelativeDamping = data.FrontRelativeDamping,
				},
			} )

			local RearAxle = self:DefineAxle( {
				Axle = {
					ForwardAngle = Forward,
					SteerType = LVS.WHEEL_STEER_NONE,
				},
				Wheels = {
					self:AddWheel( data.CustomWheelPosRL + Vector(0,0,data.CustomSuspensionTravel * 0.5), WheelAngLeft, RearWheelModel, RearWheelRadius ),
					self:AddWheel( data.CustomWheelPosRR + Vector(0,0,data.CustomSuspensionTravel * 0.5), WheelAngRight, RearWheelModel, RearWheelRadius ),
				},
				Suspension = {
					Height = data.RearHeight + data.CustomSuspensionTravel * 0.5,
					MaxTravel = data.CustomSuspensionTravel,
					ControlArmLength = 25,
					SpringConstant = data.RearConstant,
					SpringDamping = data.RearDamping,
					SpringRelativeDamping = data.RearRelativeDamping,
				},
			} )

			--data.CustomWheelPosML
			--data.CustomWheelPosMR

			--self:CreateWheel(1, WheelFL, self:LocalToWorld( self.CustomWheelPosFL ), self.FrontHeight, self.FrontWheelRadius, false , self:LocalToWorld( self.CustomWheelPosFL + Vector(0,0,self.CustomSuspensionTravel * 0.5) ),self.CustomSuspensionTravel, self.FrontConstant, self.FrontDamping, self.FrontRelativeDamping)
			--self:CreateWheel(2, WheelFR, self:LocalToWorld( self.CustomWheelPosFR ), self.FrontHeight, self.FrontWheelRadius, true , self:LocalToWorld( self.CustomWheelPosFR + Vector(0,0,self.CustomSuspensionTravel * 0.5) ),self.CustomSuspensionTravel, self.FrontConstant, self.FrontDamping, self.FrontRelativeDamping)
			--self:CreateWheel(3, WheelRL, self:LocalToWorld( self.CustomWheelPosRL ), self.RearHeight, self.RearWheelRadius, false , self:LocalToWorld( self.CustomWheelPosRL + Vector(0,0,self.CustomSuspensionTravel * 0.5) ),self.CustomSuspensionTravel, self.RearConstant, self.RearDamping, self.RearRelativeDamping)
			--self:CreateWheel(4, WheelRR, self:LocalToWorld( self.CustomWheelPosRR ), self.RearHeight, self.RearWheelRadius, true , self:LocalToWorld( self.CustomWheelPosRR + Vector(0,0,self.CustomSuspensionTravel * 0.5) ), self.CustomSuspensionTravel, self.RearConstant, self.RearDamping, self.RearRelativeDamping)

			self:SetMassCenter( (data.CustomMassCenter or Vector(0,0,0)) )
		end
	end

	--[[
	self:AddEngine( Vector(50,0,20) )
	]]
end