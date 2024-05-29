include("shared.lua")

ENT.TrackSystemEnable = false
ENT.TrackHull = Vector(1,1,1)
ENT.TrackData = {}

function ENT:PreDrawTranslucent()
	return false
end

function ENT:CalcTrackScrollTexture()
	if not self.TrackSystemEnable then return end

	local DriveWheelFL = self:GetTrackDriveWheelLeft()
	if IsValid( DriveWheelFL ) then
		local rotation = self:WorldToLocalAngles( DriveWheelFL:GetAngles() ).r
		local scroll = self:CalcScroll( "scroll_left", rotation )

		self:SetPoseParameter(self.TrackPoseParameterLeft, scroll * self.TrackPoseParameterLeftMul )
		self:SetSubMaterial( self.TrackLeftSubMaterialID, self:ScrollTexture( "left", self.TrackScrollTexture, self.TrackLeftSubMaterialMul * scroll ) )
	end

	local DriveWheelFR = self:GetTrackDriveWheelRight()
	if IsValid( DriveWheelFR ) then
		local rotation = self:WorldToLocalAngles( DriveWheelFR:GetAngles() ).r
		local scroll = self:CalcScroll( "scroll_right", rotation )

		self:SetPoseParameter(self.TrackPoseParameterRight, scroll * self.TrackPoseParameterRightMul )
		self:SetSubMaterial( self.TrackRightSubMaterialID, self:ScrollTexture( "right", self.TrackScrollTexture, self.TrackRightSubMaterialMul * scroll ) )
	end
end

function ENT:CalcTracks()
	if self:GetHP() <= 0 then
		if self._ResetSubMaterials then
			self._ResetSubMaterials = nil
			for i = 0, 128 do
				self:SetSubMaterial( i )
			end
		end

		return
	end

	self._ResetSubMaterials = true

	for _, data in pairs( self.TrackData ) do
		if not istable( data.Attachment ) or not istable( data.PoseParameter ) then continue end
		if not isstring( data.PoseParameter.name ) then continue end

		local att = self:GetAttachment( self:LookupAttachment( data.Attachment.name ) )

		if not att then continue end

		local traceLength = data.Attachment.traceLength or 100
		local toGroundDistance = data.Attachment.toGroundDistance or 20

		local trace = util.TraceHull( {
			start = att.Pos,
			endpos = att.Pos - self:GetUp() * traceLength,
			filter = self:GetCrosshairFilterEnts(),
			mins = -self.TrackHull,
			maxs = self.TrackHull,
		} )

		local Rate = data.PoseParameter.lerpSpeed or 25
		local Dist = (att.Pos - trace.HitPos):Length() + self.TrackHull.z - toGroundDistance

		local RangeMul = data.PoseParameter.rangeMultiplier or 1

		if string.StartsWith( data.PoseParameter.name, "!" ) then

			self:SetBonePoseParameter( data.PoseParameter.name, math.Clamp( self:QuickLerp( data.PoseParameter.name, Dist * RangeMul, Rate ) / data.PoseParameter.range, 0 , 1 ) )

		else
			self:SetPoseParameter( data.PoseParameter.name, self:QuickLerp( data.PoseParameter.name, Dist * RangeMul, Rate ) )
		end
	end

	self:CalcTrackScrollTexture()
end

DEFINE_BASECLASS( "lvs_base_wheeldrive" )

function ENT:Think()
	if not self:IsInitialized() then return end

	self:CalcTracks()

	BaseClass.Think( self )
 end

ENT.TrackSounds = "lvs/vehicles/sherman/tracks_loop.wav"

ENT.TireSoundTypes = {
	["skid"] = "common/null.wav",
	["skid_dirt"] = "lvs/vehicles/generic/wheel_skid_dirt.wav",
	["skid_wet"] = "common/null.wav",
	["damage_layer"] = "lvs/tracks_damaged_loop.wav",
}

function ENT:TireSoundThink()
	for snd, _ in pairs( self.TireSoundTypes ) do
		local T = self:GetTireSoundTime( snd )

		if T > 0 then
			local speed = self:GetVelocity():Length()

			local sound = self:StartTireSound( snd )

			if string.StartsWith( snd, "skid" ) then
				local vel = speed
				speed = math.max( math.abs( self:GetWheelVelocity() ) - vel, 0 ) * 5 + vel
			end

			local volume = math.min(speed / math.max( self.MaxVelocity, self.MaxVelocityReverse ),1) ^ 2 * T
			local pitch = 100 + math.Clamp((speed - 400) / 200,0,155)

			if snd == "damage_layer" then
				volume = math.min( speed / 100, 1 ) * T
			end

			sound:ChangeVolume( volume, 0 )
			sound:ChangePitch( pitch, 0.5 ) 
		else
			self:StopTireSound( snd )
		end
	end
end

function ENT:DoTireSound( snd )
	if not istable( self._TireSounds ) then
		self._TireSounds = {}
	end

	if string.StartsWith( snd, "roll" ) then
		snd = "roll"
	end

	self._TireSounds[ snd ] = CurTime() + self.TireSoundFade
end

function ENT:StartTireSound( snd )
	if not self.TireSoundTypes[ snd ] or not istable( self._ActiveTireSounds ) then
		self._ActiveTireSounds = {}
	end

	if self._ActiveTireSounds[ snd ] then return self._ActiveTireSounds[ snd ] end

	local sound = CreateSound( self, (snd == "roll") and self.TrackSounds or self.TireSoundTypes[ snd ]  )
	sound:SetSoundLevel( string.StartsWith( snd, "skid" ) and self.TireSoundLevelSkid or self.TireSoundLevelRoll )
	sound:PlayEx(0,100)

	self._ActiveTireSounds[ snd ] = sound

	return sound
end
