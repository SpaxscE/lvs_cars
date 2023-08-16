include("shared.lua")

ENT.TireSoundTypes = {
	["roll"] = "lvs/vehicles/sherman/tracks_loop.wav",
	["roll_dirt"] = "lvs/vehicles/sherman/tracks_loop.wav",
	["roll_wet"] = "lvs/vehicles/sherman/tracks_loop.wav",
	["skid"] = "common/null.wav",
	["skid_dirt"] = "lvs/vehicles/generic/wheel_skid_dirt.wav",
	["skid_wet"] = "common/null.wav",
}

local sherman_susdata = {}
for i = 1,6 do
	sherman_susdata[i] = { 
		attachment = "vehicle_suspension_l_"..i,
		poseparameter = "suspension_left_"..i,
	}
	
	local ir = i + 6
	sherman_susdata[ir] = { 
		attachment = "vehicle_suspension_r_"..i,
		poseparameter = "suspension_right_"..i,
	}
end

function ENT:UpdatePoseParameters( steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear )
	for i, v in pairs( sherman_susdata ) do
		local pos = self:GetAttachment( self:LookupAttachment( sherman_susdata[i].attachment ) ).Pos

		local trace = util.TraceLine( {
			start = pos,
			endpos = pos + self:GetUp() * - 100,
			filter = self:GetCrosshairFilterEnts(),
		} )
		local Dist = (pos - trace.HitPos):Length() - 30

		self:SetPoseParameter(sherman_susdata[i].poseparameter, 12 - Dist )
	end

	local DriveWheelFL = self:GetDriveWheelFL()
	if IsValid( DriveWheelFL ) then
		local rotation = self:WorldToLocalAngles( DriveWheelFL:GetAngles() ).r

		self:SetPoseParameter("spin_wheels_left", -rotation )

		local Scroll = self:GetRotationDelta( "scroll_left", rotation ) * 0.004

		self:SetSubMaterial( 1, self:ScrollTexture( "left", "models/blu/track_sherman", Vector(0,Scroll,0) ) )
	end

	local DriveWheelFR = self:GetDriveWheelFR()
	if IsValid( DriveWheelFR ) then
		local rotation = self:WorldToLocalAngles( DriveWheelFR:GetAngles() ).r

		self:SetPoseParameter("spin_wheels_right", -rotation )

		local Scroll = self:GetRotationDelta( "scroll_right", rotation ) * 0.004

		self:SetSubMaterial( 2, self:ScrollTexture( "right", "models/blu/track_sherman", Vector(0,Scroll,0) ) )
	end
end