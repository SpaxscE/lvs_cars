
function ENT:StopWheelEffects()
	if not self._DoingWheelFx then return end

	self._DoingWheelFx = nil

	self:FinishSkidmark()
end

function ENT:StartWheelEffects( Base, SkidValue, trace, traceWater )
	self:DoWheelEffects( Base, SkidValue, trace, traceWater )

	if self._DoingWheelFx then return end

	self._DoingWheelFx = true
end

function ENT:DoWheelEffects( Base, SkidValue, trace, traceWater )
	if not trace.Hit then self:FinishSkidmark() return end

	local SurfacePropName = util.GetSurfacePropName( trace.SurfaceProps )

	if traceWater.Hit then
		local Scale = math.min( 0.3 + (SkidValue - 100) / 4000, 1 ) ^ 2

		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetEntity( Base )
		effectdata:SetNormal( trace.HitNormal )
		effectdata:SetMagnitude( Scale )
		effectdata:SetFlags( 1 )
		util.Effect( "lvs_physics_wheeldust", effectdata, true, true )

		self:FinishSkidmark()

		return
	end

	if self.SkidmarkSurfaces[ SurfacePropName ] then
		local Scale = math.min( 0.3 + SkidValue / 4000, 1 ) ^ 2

		if Scale > 0.4 then
			self:StartSkidmark( trace.HitPos )
			self:CalcSkidmark( trace, Base:GetCrosshairFilterEnts() )
		end

		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetEntity( Base )
		effectdata:SetNormal( trace.HitNormal )
		util.Effect( "lvs_physics_wheelsmoke", effectdata, true, true )
	else
		self:FinishSkidmark()
	end

	if not LVS.ShowEffects then return end

	if self.DustEffectSurfaces[ SurfacePropName ] then
		local Scale = math.min( 0.3 + (SkidValue - 100) / 4000, 1 ) ^ 2

		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
		effectdata:SetEntity( Base )
		effectdata:SetNormal( trace.HitNormal )
		effectdata:SetMagnitude( Scale )
		effectdata:SetFlags( 0 )
		util.Effect( "lvs_physics_wheeldust", effectdata, true, true )
	end
end

function ENT:CalcWheelEffects()
	local T = CurTime()

	if (self._NextFx or 0) > T then return end

	self._NextFx = T + 0.05

	local Base = self:GetBase()

	if not IsValid( Base ) then return end

	local Vel = self:GetVelocity()
	local VelLength = Vel:Length()

	local rpmTheoretical = self:VelToRPM( VelLength )
	local rpm = math.abs( self:GetRPM() )

	local Radius = Base:GetUp() * (self:GetRadius() + 1)

	local Pos =  self:GetPos()
	local StartPos = Pos + Radius
	local EndPos = Pos - Radius

	local trace = util.TraceLine( {
		start = StartPos,
		endpos = EndPos,
		filter = Base:GetCrosshairFilterEnts(),
	} )

	local traceWater = util.TraceLine( {
		start = StartPos,
		endpos = EndPos,
		filter = Base:GetCrosshairFilterEnts(),
		mask = MASK_WATER,
	} )

	if traceWater.Hit and trace.HitPos.z < traceWater.HitPos.z then 
		if rpm > 25 then
			if traceWater.Fraction > 0 then
				local effectdata = EffectData()
					effectdata:SetOrigin( traceWater.HitPos )
					effectdata:SetEntity( Base )
					effectdata:SetMagnitude( self:BoundingRadius() )
				util.Effect( "lvs_physics_wheelwatersplash", effectdata )

				self:StopWheelEffects()

				return
			end
		end
	end

	local WheelSlip = math.max( rpm - rpmTheoretical - 80, 0 ) ^ 2 + math.max( math.abs( Base:VectorSplitNormal( self:GetForward(), Vel * 4 ) ) - VelLength, 0 )

	if WheelSlip < 500 then self:StopWheelEffects() return end

	local SkidValue = VelLength + WheelSlip

	self:StartWheelEffects( Base, SkidValue, trace, traceWater )
end
