
function ENT:AddTracksDT()
	self:AddDT( "Entity", "DriveWheelFL" )
	self:AddDT( "Entity", "DriveWheelFR" )
end

if SERVER then
	function ENT:CreateTracks()
		local WheelModel = "models/diggercars/m5m16/m5_wheel.mdl"

		local L1 = self:AddWheel( { hide = true, pos = Vector(-37,32,23), mdl = WheelModel } )
		local L2 = self:AddWheel( { hide = true, pos = Vector(-75,32,23), mdl = WheelModel } )
		self:CreateWheelChain( {L1, L2} )
		self:SetDriveWheelFL( L1 )

		local R1 = self:AddWheel( { hide = true, pos = Vector(-37,-32,23), mdl = WheelModel, mdl_ang = Angle(0,180,0) } )
		local R2 = self:AddWheel( { hide = true, pos = Vector(-75,-32,23), mdl = WheelModel, mdl_ang = Angle(0,180,0) } )
		self:CreateWheelChain( {R1, R2} )
		self:SetDriveWheelFR( R1 )

		self:DefineAxle( {
			Axle = {
				ForwardAngle = Angle(0,0,0),
				SteerType = LVS.WHEEL_STEER_NONE,
				TorqueFactor = 0.5,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R1, L1, L2, R2 },
				Suspension = {
				Height = 10,
				MaxTravel = 7,
				ControlArmLength = 25,
				SpringConstant = 20000,
				SpringDamping = 2000,
				SpringRelativeDamping = 2000,
			},
		} )
	end
else

	ENT.ScrollTextureData = {
		["$bumpmap"] = "models/diggercars/shared/skin_nm",
		["$phong"] = "1",
		["$phongboost"] = "0.04",
		["$phongexponent"] = "3",
		["$phongfresnelranges"] = "[1 1 1]",
		["$translate"] = "[0.0 0.0 0.0]",
		["$colorfix"] = "{255 255 255}",
		["Proxies"] = {
			["TextureTransform"] = {
				["translateVar"] = "$translate",
				["centerVar"]    = "$center",
				["resultVar"]    = "$basetexturetransform",
			},
			["Equals"] = {
				["srcVar1"] =  "$colorfix",
				["resultVar"] = "$color",
			}
		}
	}

	ENT.TrackSounds = "lvs/vehicles/halftrack/tracks_loop.wav"
	ENT.TrackHull = Vector(5,5,5)
	ENT.TrackData = {}

	for i = 1, 5 do
		for n = 0, 1 do
			local LR = n == 0 and "l" or "r"
			local LeftRight = n == 0 and "left" or "right"
			local data = {
				Attachment = {
					name = "vehicle_suspension_"..LR.."_"..i,
					toGroundDistance = 19,
					traceLength = 150,
				},
				PoseParameter = {
					name = "suspension_"..LeftRight.."_"..i,
					rangeMultiplier = 1.25,
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

			self:SetPoseParameter("spin_wheels_left", -scroll * 2 )
			self:SetSubMaterial( 5, self:ScrollTexture( "left", "models/diggercars/m5m16/m5_tracks_right", Vector(-scroll * 0.0725,0,0) ) )
		end

		local DriveWheelFR = self:GetDriveWheelFR()
		if IsValid( DriveWheelFR ) then
			local rotation = self:WorldToLocalAngles( DriveWheelFR:GetAngles() ).r
			local scroll = self:CalcScroll( "scroll_right", rotation )

			self:SetPoseParameter("spin_wheels_right", -scroll * 2 )
			self:SetSubMaterial( 6, self:ScrollTexture( "right", "models/diggercars/m5m16/m5_tracks_right", Vector(-scroll * 0.0725,0,0) ) )
		end
	end
end