
function ENT:AddTracksDT()
	self:AddDT( "Entity", "DriveWheelFL" )
	self:AddDT( "Entity", "DriveWheelFR" )
end

if SERVER then
	function ENT:CreateTracks()
		local WheelModel = "models/props_vehicles/tire001b_truck.mdl"

		local L1 = self:AddWheel( { hide = true, pos = Vector(115,55,45), mdl = WheelModel } )
		local L2 = self:AddWheel( { hide = true, pos = Vector(75,55,25), mdl = WheelModel } )
		local L3 = self:AddWheel( { hide = true, pos = Vector(35,55,35), mdl = WheelModel } )
		local L4 = self:AddWheel( { hide = true, pos = Vector(-5,55,35), mdl = WheelModel } )
		local L5 = self:AddWheel( { hide = true, pos = Vector(-45,55,35), mdl = WheelModel } )
		local L6 = self:AddWheel( { hide = true, pos = Vector(-85,55,35), mdl = WheelModel } )
		self:CreateWheelChain( {L1, L2, L3, L4, L5, L6} )
		self:SetDriveWheelFL( L4 )

		local R1 = self:AddWheel( { hide = true, pos = Vector(115,-55,45), mdl = WheelModel } )
		local R2 = self:AddWheel( { hide = true, pos = Vector(75,-55,25), mdl = WheelModel } )
		local R3 = self:AddWheel( { hide = true, pos = Vector(35,-55,35), mdl = WheelModel } )
		local R4 = self:AddWheel( { hide = true, pos = Vector(-5,-55,35), mdl = WheelModel } )
		local R5 = self:AddWheel( { hide = true, pos = Vector(-45,-55,35), mdl = WheelModel } )
		local R6 = self:AddWheel( { hide = true, pos = Vector(-85,-55,35), mdl = WheelModel} )
		self:CreateWheelChain( {R1, R2, R3, R4, R5, R6} )
		self:SetDriveWheelFR( R4 )

		self:DefineAxle( {
			Axle = {
				ForwardAngle = Angle(0,0,0),
				SteerType = LVS.WHEEL_STEER_FRONT,
				SteerAngle = 30,
				TorqueFactor = 0,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R1, L1, R2, L2 },
			Suspension = {
				Height = 20,
				MaxTravel = 15,
				ControlArmLength = 150,
				SpringConstant = 20000,
				SpringDamping = 1000,
				SpringRelativeDamping = 2000,
			},
		} )

		self:DefineAxle( {
			Axle = {
				ForwardAngle = Angle(0,0,0),
				SteerType = LVS.WHEEL_STEER_NONE,
				TorqueFactor = 1,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R3, L3, L4, R4 },
			Suspension = {
				Height = 20,
				MaxTravel = 15,
				ControlArmLength = 150,
				SpringConstant = 20000,
				SpringDamping = 1000,
				SpringRelativeDamping = 2000,
			},
		} )

		self:DefineAxle( {
			Axle = {
				ForwardAngle = Angle(0,0,0),
				SteerType = LVS.WHEEL_STEER_REAR,
				SteerAngle = 30,
				TorqueFactor = 0,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R5, L5, R6, L6 },
			Suspension = {
				Height = 20,
				MaxTravel = 15,
				ControlArmLength = 150,
				SpringConstant = 20000,
				SpringDamping = 1000,
				SpringRelativeDamping = 2000,
			},
		} )
	end
else
	ENT.TrackSounds = "lvs/vehicles/tiger/tracks_loop.wav"
	ENT.TrackHull = Vector(20,20,20)
	ENT.TrackData = {}
	for i = 1, 8 do
		for n = 0, 1 do
			local LR = n == 0 and "l" or "r"
			local LeftRight = n == 0 and "left" or "right"
			local data = {
				Attachment = {
					name = "vehicle_suspension_"..LR.."_"..i,
					toGroundDistance = 20,
					traceLength = 100,
				},
				PoseParameter = {
					name = "suspension_"..LeftRight.."_"..i,
					rangeMultiplier = -1,
					lerpSpeed = 25,
				}
			}
			table.insert( ENT.TrackData, data )
		end
	end

	function ENT:CalcTrackScrollTexture()
		local DriveWheelFL = self:GetDriveWheelFL()
		if IsValid( DriveWheelFL ) then
			local rotation = self:WorldToLocalAngles( DriveWheelFL:GetAngles() ).r
			local scroll = self:CalcScroll( "scroll_left", rotation )

			self:SetPoseParameter("spin_wheels_left", -scroll * 1.252 )
			self:SetSubMaterial( 1, self:ScrollTexture( "left", "models/blu/track", Vector(0,scroll * 0.0135,0) ) )
		end

		local DriveWheelFR = self:GetDriveWheelFR()
		if IsValid( DriveWheelFR ) then
			local rotation = self:WorldToLocalAngles( DriveWheelFR:GetAngles() ).r
			local scroll = self:CalcScroll( "scroll_right", rotation )

			self:SetPoseParameter("spin_wheels_right", -scroll * 1.252 )
			self:SetSubMaterial( 2, self:ScrollTexture( "right", "models/blu/track", Vector(0,scroll * 0.0135,0) ) )
		end
	end
end