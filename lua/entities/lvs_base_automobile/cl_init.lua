include("shared.lua")
include("sh_animations.lua")
include("sh_collisionfilter.lua")

 function ENT:LVSCalcView( ply, pos, angles, fov, pod )
	pos = pos + pod:GetUp() * 7 - pod:GetRight() * 11
	return LVS:CalcView( self, ply, pos, angles, fov, pod )
end

function ENT:DoVehicleFX()
	local Vel = self:GetVelocity():Length()

	if self._WindSFX then self._WindSFX:ChangeVolume( math.Clamp( (Vel - 1200) / 2800,0,1 ), 0.25 ) end

	if Vel < 1500 then
		if self._WaterSFX then self._WaterSFX:ChangeVolume( 0, 0.25 ) end

		return
	end

	if (self.nextFX or 0) < CurTime() then
		self.nextFX = CurTime() + 0.05

		local LCenter = self:OBBCenter()
		LCenter.z = self:OBBMins().z

		local CenterPos = self:LocalToWorld( LCenter )

		local trace = util.TraceLine( {
			start = CenterPos + Vector(0,0,25),
			endpos = CenterPos - Vector(0,0,450),
			filter = self:GetCrosshairFilterEnts(),
		} )

		local traceWater = util.TraceLine( {
			start = CenterPos + Vector(0,0,25),
			endpos = CenterPos - Vector(0,0,450),
			filter = self:GetCrosshairFilterEnts(),
			mask = MASK_WATER,
		} )

		if self._WaterSFX then self._WaterSFX:ChangePitch( math.Clamp((Vel / 1000) * 50,80,150), 0.5 ) end

		if traceWater.Hit and trace.HitPos.z < traceWater.HitPos.z then 
			local effectdata = EffectData()
				effectdata:SetOrigin( traceWater.HitPos )
				effectdata:SetEntity( self )
			util.Effect( "lvs_physics_water", effectdata )

			if self._WaterSFX then self._WaterSFX:ChangeVolume( 1 - math.Clamp(traceWater.Fraction,0,1), 0.5 ) end
		else
			if self._WaterSFX then self._WaterSFX:ChangeVolume( 0, 0.25 ) end
		end
	end
end