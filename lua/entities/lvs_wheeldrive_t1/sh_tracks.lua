
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
		local WheelModel = "models/props_c17/pulleywheels_small01.mdl"

		local L1 = self:AddWheel( { hide = true, pos = Vector(22,40,25), mdl = WheelModel } )
		local L2 = self:AddWheel( { hide = true, pos = Vector(22,20,25), mdl = WheelModel } )
		local L3 = self:AddWheel( { hide = true, pos = Vector(22,0,25), mdl = WheelModel } )
		local L4 = self:AddWheel( { hide = true, pos = Vector(22,-20,24), mdl = WheelModel } )
		local L5 = self:AddWheel( { hide = true, pos = Vector(22,-40,23), mdl = WheelModel } )
		self:CreateWheelChain( {L1, L2, L3, L4, L5} )
		self:SetDriveWheelFL( L4 )

		local R1 = self:AddWheel( { hide = true, pos = Vector(-22,40,25), mdl = WheelModel } )
		local R2 = self:AddWheel( { hide = true, pos = Vector(-22,20,25), mdl = WheelModel } )
		local R3 = self:AddWheel( { hide = true, pos = Vector(-22,0,25), mdl = WheelModel } )
		local R4 = self:AddWheel( { hide = true, pos = Vector(-22,-20,24), mdl = WheelModel } )
		local R5 = self:AddWheel( { hide = true, pos = Vector(-22,-40,23), mdl = WheelModel } )
		self:CreateWheelChain( {R1, R2, R3, R4, R5} )
		self:SetDriveWheelFR( R4 )

		self:DefineAxle( {
			Axle = {
				ForwardAngle = Angle(0,90,0),
				SteerType = LVS.WHEEL_STEER_FRONT,
				SteerAngle = 30,
				TorqueFactor = 1,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R1, L1 },
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
				ForwardAngle = Angle(0,90,0),
				SteerType = LVS.WHEEL_STEER_NONE,
				TorqueFactor = 1,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R2, L2 },
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
				ForwardAngle = Angle(0,90,0),
				SteerType = LVS.WHEEL_STEER_REAR,
				SteerAngle = 10,
				TorqueFactor = 0,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R3, L3 },
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
				ForwardAngle = Angle(0,90,0),
				SteerType = LVS.WHEEL_STEER_REAR,
				SteerAngle = 20,
				TorqueFactor = 0,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R4, L4 },
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
				ForwardAngle = Angle(0,90,0),
				SteerType = LVS.WHEEL_STEER_REAR,
				SteerAngle = 30,
				TorqueFactor = 0,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R5, L5 },
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
	ENT.TrackHull = Vector(5,5,5)
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
			attachment = "vehicle_suspension_r_1",
			poseparameter = "suspension_right_1",
		},
		{ 
			attachment = "vehicle_suspension_r_2",
			poseparameter = "suspension_right_2",
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
			local Dist = (pos - trace.HitPos):Length()
			local Target = (7 - Dist) * 2.2

			if i == 3 or i == 4 then
				Target = Target - 9
			end

			self:SetPoseParameter(self.TrackData[i].poseparameter, self:QuickLerp( self.TrackData[i].poseparameter, Target, 25 ) )
		end

		local DriveWheelFL = self:GetDriveWheelFL()
		if IsValid( DriveWheelFL ) then
			local rotation = self:WorldToLocalAngles( DriveWheelFL:GetAngles() ).r
			local scroll = self:CalcScroll( "scroll_left", rotation )

			self:SetPoseParameter("spin_wheels_left", -scroll * 1.252 )
			self:SetSubMaterial( 2, self:ScrollTexture( "left", "models/diggercars/T1/T1TR", Vector(0,scroll * 0.004,0) ) )
		end

		local DriveWheelFR = self:GetDriveWheelFR()
		if IsValid( DriveWheelFR ) then
			local rotation = self:WorldToLocalAngles( DriveWheelFR:GetAngles() ).r
			local scroll = self:CalcScroll( "scroll_right", rotation )

			self:SetPoseParameter("spin_wheels_right", -scroll * 1.252 )
			self:SetSubMaterial( 3, self:ScrollTexture( "right", "models/diggercars/T1/T1TR", Vector(0,scroll * 0.004,0) ) )
		end
	end
end