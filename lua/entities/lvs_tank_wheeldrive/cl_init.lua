include("shared.lua")

function ENT:CalcViewOverride( ply, pos, angles, fov, pod )
	return pos, angles, fov
end

function ENT:CalcTankView( ply, pos, angles, fov, pod )
	local view = {}
	view.origin = pos
	view.angles = angles
	view.fov = fov
	view.drawviewer = false

	if not pod:GetThirdPersonMode() then return view end

	local mn = self:OBBMins()
	local mx = self:OBBMaxs()
	local radius = ( mn - mx ):Length()
	local radius = radius + radius * pod:GetCameraDistance()

	local clamped_angles = pod:WorldToLocalAngles( angles )
	clamped_angles.p = math.max( clamped_angles.p, -20 )
	clamped_angles = pod:LocalToWorldAngles( clamped_angles )

	local StartPos = pos
	local EndPos = StartPos - clamped_angles:Forward() * radius + clamped_angles:Up() * (radius * pod:GetCameraHeight())

	local WallOffset = 4

	local tr = util.TraceHull( {
		start = StartPos,
		endpos = EndPos,
		filter = function( e )
			local c = e:GetClass()
			local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "lvs_" ) and not c:StartWith( "player" ) and not e.LVS

			return collide
		end,
		mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
		maxs = Vector( WallOffset, WallOffset, WallOffset ),
	} )

	view.angles = angles + Angle(5,0,0)
	view.origin = tr.HitPos + pod:GetUp() * 65
	view.drawviewer = true

	if tr.Hit and  not tr.StartSolid then
		view.origin = view.origin + tr.HitNormal * WallOffset
	end

	return view
end

function ENT:CalcViewDirectInput( ply, pos, angles, fov, pod )
	return self:CalcTankView( ply, pos, angles, fov, pod )
end

function ENT:CalcViewMouseAim( ply, pos, angles, fov, pod )
	return self:CalcTankView( ply, pos, angles, fov, pod )
end

ENT.TrackHull = Vector(1,1,1)
ENT.TrackData = {}

function ENT:CalcTrackScrollTexture()
end

function ENT:CalcTracks()
	for _, data in pairs( self.TrackData ) do
		if not istable( data.Attachment ) or not istable( data.PoseParameter ) then continue end
		if not isstring( data.PoseParameter.name ) then continue end

		local att = self:GetAttachment( self:LookupAttachment( data.Attachment.name ) )

		if not att then continue end

		local traceLength = data.Attachment.traceLength or 100
		local toGroundDistance = data.Attachment.toGroundDistance or 20

		local trace = util.TraceHull( {
			start = att.Pos,
			endpos = att.Pos + self:GetUp() * - traceLength,
			filter = self:GetCrosshairFilterEnts(),
			mins = -self.TrackHull,
			maxs = self.TrackHull,
		} )

		local Rate = data.PoseParameter.lerpSpeed or 25
		local Dist = toGroundDistance - math.abs(toGroundDistance - (att.Pos - trace.HitPos):Length() - self.TrackHull.z)
		local RangeMul = data.PoseParameter.rangeMultiplier or 1

		self:SetPoseParameter( data.PoseParameter.name, self:QuickLerp( data.PoseParameter.name, Dist * RangeMul, Rate ) )
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
