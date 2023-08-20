include("shared.lua")

function ENT:UpdatePoseParameters( steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter )
	self:SetPoseParameter( "vehicle_steer", steer )
	self:SetPoseParameter( "tacho_gauge", engine_rpm / 8000 )
	self:SetPoseParameter( "vehicle_gauge", speed_kmh / 240 )
	self:SetPoseParameter( "temp_gauge", temperature )
	self:SetPoseParameter( "fuel_gauge", fuel )
	self:SetPoseParameter( "throttle_pedal", throttle )
	self:SetPoseParameter( "brake_pedal", brake )
	self:SetPoseParameter( "handbrake_pedal", handbrake )
	self:SetPoseParameter( "clutch_pedal", clutch )

	local GearIDtoPose = {
		[-1] = 0,
		[1] = 2,
		[2] = 5,
		[3] = 7,
		[4] = 10,
	}

	local hours = os.date( "%H" )
	local min = os.date( "%M" ) 
	local sec = os.date( "%S" )

	self:SetPoseParameter( "hour", hours + min / 60 )
	self:SetPoseParameter( "minute", min + sec / 60 )
	self:SetPoseParameter( "second", sec )
	self:SetPoseParameter( "gear",  self:QuickLerp( "gear", (GearIDtoPose[ gear ] or 1) ) )
end