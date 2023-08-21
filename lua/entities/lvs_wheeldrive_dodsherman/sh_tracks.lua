
function ENT:AddTracksDT()
	self:AddDT( "Entity", "DriveWheelFL" )
	self:AddDT( "Entity", "DriveWheelFR" )
end

ENT.TireSoundTypes = {
	["roll"] = "lvs/vehicles/sherman/tracks_loop.wav",
	["roll_dirt"] = "lvs/vehicles/sherman/tracks_loop.wav",
	["roll_wet"] = "lvs/vehicles/sherman/tracks_loop.wav",
	["skid"] = "common/null.wav",
	["skid_dirt"] = "lvs/vehicles/generic/wheel_skid_dirt.wav",
	["skid_wet"] = "common/null.wav",
}

if SERVER then
	function ENT:CreateTracks()
		local WheelModel = "models/props_vehicles/tire001b_truck.mdl"

		local L1 = self:AddWheel( { hide = true, pos = Vector(100,42,55), mdl = WheelModel } )
		local L2 = self:AddWheel( { hide = true, pos = Vector(70,42,35), mdl = WheelModel } )
		local L3 = self:AddWheel( { hide = true, pos = Vector(35,42,40), mdl = WheelModel } )
		local L4 = self:AddWheel( { hide = true, pos = Vector(0,42,45), mdl = WheelModel } )
		local L5 = self:AddWheel( { hide = true, pos = Vector(-35,42,45), mdl = WheelModel } )
		local L6 = self:AddWheel( { hide = true, pos = Vector(-70,42,45), mdl = WheelModel } )
		self:CreateWheelChain( {L1, L2, L3, L4, L5, L6} )
		self:SetDriveWheelFL( L4 )

		local R1 = self:AddWheel( { hide = true, pos = Vector(100,-42,55), mdl = WheelModel } )
		local R2 = self:AddWheel( { hide = true, pos = Vector(70,-42,35), mdl = WheelModel } )
		local R3 = self:AddWheel( { hide = true, pos = Vector(35,-42,40), mdl = WheelModel } )
		local R4 = self:AddWheel( { hide = true, pos = Vector(0,-42,45), mdl = WheelModel } )
		local R5 = self:AddWheel( { hide = true, pos = Vector(-35,-42,45), mdl = WheelModel } )
		local R6 = self:AddWheel( { hide = true, pos = Vector(-70,-42,45), mdl = WheelModel} )
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
	ENT.TrackHull = Vector(20,20,20)
	ENT.TrackData = {
		{ 
			attachment = "vehicle_suspension_l_1",
			poseparameter = "suspension_left_1",
		},
		{ 
			attachment = "vehicle_suspension_l_2",
			poseparameter = "suspension_left_2",
		},
		{ 
			attachment = "vehicle_suspension_l_3",
			poseparameter = "suspension_left_3",
		},
		{ 
			attachment = "vehicle_suspension_l_4",
			poseparameter = "suspension_left_4",
		},
		{ 
			attachment = "vehicle_suspension_l_5",
			poseparameter = "suspension_left_5",
		},
		{ 
			attachment = "vehicle_suspension_l_6",
			poseparameter = "suspension_left_6",
		},
		{ 
			attachment = "vehicle_suspension_r_1",
			poseparameter = "suspension_right_1",
		},
		{ 
			attachment = "vehicle_suspension_r_2",
			poseparameter = "suspension_right_2",
		},
		{ 
			attachment = "vehicle_suspension_r_3",
			poseparameter = "suspension_right_3",
		},
		{ 
			attachment = "vehicle_suspension_r_4",
			poseparameter = "suspension_right_4",
		},
		{ 
			attachment = "vehicle_suspension_r_5",
			poseparameter = "suspension_right_5",
		},
		{ 
			attachment = "vehicle_suspension_r_6",
			poseparameter = "suspension_right_6",
		},
	}

	function ENT:CalcTracks()
		for i, v in pairs( self.TrackData ) do
			local pos = self:GetAttachment( self:LookupAttachment( self.TrackData[i].attachment ) ).Pos

			local trace = util.TraceHull( {
				start = pos,
				endpos = pos + self:GetUp() * - 100,
				filter = self:GetCrosshairFilterEnts(),
				mins = -self.TrackHull,
				maxs = self.TrackHull,
			} )
			local Dist = (pos - trace.HitPos):Length() - (30 - self.TrackHull.z)

			self:SetPoseParameter(self.TrackData[i].poseparameter, self:QuickLerp( self.TrackData[i].poseparameter, 12 - Dist, 25 ) )
		end

		local DriveWheelFL = self:GetDriveWheelFL()
		if IsValid( DriveWheelFL ) then
			local rotation = self:WorldToLocalAngles( DriveWheelFL:GetAngles() ).r
			local scroll = self:CalcScroll( "scroll_left", rotation )

			self:SetPoseParameter("spin_wheels_left", -scroll * 1.252 )
			self:SetSubMaterial( 1, self:ScrollTexture( "left", "models/blu/track_sherman", Vector(0,scroll * 0.004,0) ) )
		end

		local DriveWheelFR = self:GetDriveWheelFR()
		if IsValid( DriveWheelFR ) then
			local rotation = self:WorldToLocalAngles( DriveWheelFR:GetAngles() ).r
			local scroll = self:CalcScroll( "scroll_right", rotation )

			self:SetPoseParameter("spin_wheels_right", -scroll * 1.252 )
			self:SetSubMaterial( 2, self:ScrollTexture( "right", "models/blu/track_sherman", Vector(0,scroll * 0.004,0) ) )
		end
	end
end