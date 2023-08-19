include("shared.lua")

ENT.ScrollTextureData = {
	["$bumpmap"] = "models/diggercars/shared/skin_nm",
	["$phong"] = "1",
	["$phongboost"] = "0.08",
	["$phongexponent"] = "3",
	["$phongfresnelranges"] = "[1 1 1]",
	["$colorfix"] = "{255 255 255}",
	["$translate"] = "[0.0 0.0 0.0]",
	["Proxies"] = {
		["Equals"] = {
			["srcVar1"] = "$colorfix",
			["resultVar"] = "$color",
		},
		["TextureTransform"] = {
			["translateVar"] = "$translate",
			["centerVar"]    = "$center",
			["resultVar"]    = "$basetexturetransform",
		}
	}
}

function ENT:UpdatePoseParameters( steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter )
	self:SetPoseParameter( "vehicle_steer", steer )
	self:SetPoseParameter( "tacho_gauge", engine_rpm / 8000 )
	self:SetPoseParameter( "temp_gauge", temperature )
	self:SetPoseParameter( "fuel_gauge", fuel )
	self:SetPoseParameter( "oil_gauge", oil )
	self:SetPoseParameter( "alt_gauge", ammeter )
	self:SetPoseParameter( "vehicle_gauge", speed_kmh / 240 )
	self:SetPoseParameter( "throttle_pedal", throttle )
	self:SetPoseParameter( "brake_pedal", brake )
	self:SetPoseParameter( "handbrake_pedal", handbrake )
	self:SetPoseParameter( "clutch_pedal", clutch )

	local GearIDtoPose = {
		[-1] = 0,
		[1] = 3,
		[2] = 5,
		[3] = 8,
		[4] = 10,
	}

	self:SetPoseParameter( "gear",  self:QuickLerp( "gear", (GearIDtoPose[ gear ] or 1) ) )

	local hours = os.date( "%H" )
	local min = os.date( "%M" ) 
	local sec = os.date( "%S" )

	self:SetPoseParameter( "hour", hours + min / 60 )
	self:SetPoseParameter( "minute", min + sec / 60 )
	self:SetPoseParameter( "second", sec )

	if self:GetBodygroup( 10 ) ~= 1 then return end

	self._rpm = self._rpm and self._rpm + engine_rpm * FrameTime() or 0

	self:SetSubMaterial( 20, self:ScrollTexture( "belt", "models/diggercars/dodge_charger/belt", Vector(0,self._rpm * 0.0025,0) ) )
	self:SetPoseParameter( "engine_spin", -self._rpm )
end