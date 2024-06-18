include("shared.lua")

function ENT:CalcViewPassenger( ply, pos, angles, fov, pod )

	if pod ~= self:GetGunnerSeat() then
		return LVS:CalcView( self, ply, pos, angles, fov, pod )
	end

	if pod:GetThirdPersonMode() then
		local view = {}
		view.fov = fov
		view.drawviewer = true

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

		if tr.Hit and  not tr.StartSolid then
			view.origin = view.origin + tr.HitNormal * WallOffset
		end

		return view
	end

	local ZoomAttach = self:GetAttachment( self:LookupAttachment( "zoom" ) )
	local EyeAttach = self:GetAttachment( self:LookupAttachment( "eye" ) )

	if ZoomAttach and EyeAttach then
		local ZOOM = ply:lvsKeyDown( "ZOOM" )

		local TargetZoom = ZOOM and 1 or 0

		pod.smZoom = pod.smZoom and (pod.smZoom + (TargetZoom - pod.smZoom) * RealFrameTime() * 12) or 0

		local Zoom = pod.smZoom
		local invZoom = 1 - Zoom

		pos = ZoomAttach.Pos * Zoom + EyeAttach.Pos * invZoom
	end

	return LVS:CalcView( self, ply, pos, angles, fov, pod )
end
