
AddCSLuaFile()

ENT.PrintName = "Wheel"

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

ENT.RenderGroup = RENDERGROUP_BOTH 

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "Radius")
	self:NetworkVar( "Float", 1, "Width")

	self:NetworkVar( "Float", 2, "Camber" )
	self:NetworkVar( "Float", 3, "Caster" )
	self:NetworkVar( "Float", 4, "Toe" )

	self:NetworkVar( "Float", 5, "RPM" )

	self:NetworkVar( "Angle", 0, "AlignmentAngle" )

	self:NetworkVar( "Entity", 0, "Base" )

	if SERVER then
		self:SetWidth( 3 )
	end
end

function ENT:VelToRPM( speed )
	if not speed then return 0 end

	return speed * 60 / math.pi / (self:GetRadius() * 2)
end

function ENT:RPMToVel( rpm )
	if not rpm then return 0 end

	return (math.pi * rpm * self:GetRadius() * 2) / 60
end

if SERVER then
	AccessorFunc(ENT, "axle", "Axle", FORCE_NUMBER)

	function ENT:Initialize()
		self:SetUseType( SIMPLE_USE )
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		self:AddEFlags( EFL_NO_PHYSCANNON_INTERACTION )
	end

	function ENT:SetHandbrake( enable )
		if enable then

			self:EnableHandbrake()

			return
		end

		self:ReleaseHandbrake()
	end

	function ENT:IsHandbrakeActive()
		return self._handbrakeActive == true
	end

	function ENT:EnableHandbrake()
		if self._handbrakeActive then return end

		self._handbrakeActive = true

		self:LockRotation()
	end

	function ENT:ReleaseHandbrake()
		if not self._handbrakeActive then return end

		self._handbrakeActive = nil

		self:ReleaseRotation()
	end

	function ENT:LockRotation()
		if self:IsRotationLocked() then return end

		local Master = self:GetMaster()

		if not IsValid( Master ) then return end

		self.bsLock = constraint.AdvBallsocket(self,Master,0,0,vector_origin,vector_origin,0,0,-0.1,-0.1,-0.1,0.1,0.1,0.1,0,0,0,1,1)
		self.bsLock.DoNotDuplicate = true
	end

	function ENT:ReleaseRotation()
		if not self:IsRotationLocked() then return end

		self.bsLock:Remove()
	end

	function ENT:IsRotationLocked()
		return IsValid( self.bsLock )
	end

	function ENT:Use( ply )
		local base = self:GetBase()

		if not IsValid( base ) then return end

		base:Use( ply )
	end

	function ENT:Think()
		return false
	end

	function ENT:OnRemove()
	end

	function ENT:OnTakeDamage( dmginfo )
	end

	function ENT:PhysicsCollide( data )
	end

	function ENT:SetMaster( master )
		self._Master = master
	end

	function ENT:GetMaster()
		return self._Master
	end

	function ENT:MakeSpherical( radius )
		if not radius or radius <= 0 then
			radius = (self:OBBMaxs() - self:OBBMins()) * 0.5
			radius = math.max( radius.x, radius.y, radius.z )
		end

		self:PhysicsInitSphere( radius, "jeeptire" )

		self:SetRadius( radius )
	end

	function ENT:GetDirectionAngle()
		local master = self:GetMaster()

		if not IsValid( master ) then return self:GetAngles() end

		return master:GetAngles()
	end

	function ENT:GetRotationAxis()
		local base = self:GetBase()

		if not IsValid( base ) then return vector_origin end

		local Axle = base:GetAxleData( self:GetAxle() )

		local WorldAngleDirection = -self:WorldToLocalAngles( self:GetDirectionAngle() )

		return WorldAngleDirection:Right()
	end

	function ENT:GetTorqueFactor()
		if self._torqueFactor then return self._torqueFactor end

		local base = self:GetBase()

		if not IsValid( base ) then return 0 end

		self._torqueFactor = base:GetAxleData( self:GetAxle() ).TorqueFactor or 0

		return self._torqueFactor
	end

	function ENT:GetBrakeFactor()
		if self._brakeFactor then return self._brakeFactor end

		local base = self:GetBase()

		if not IsValid( base ) then return 0 end

		self._brakeFactor = base:GetAxleData( self:GetAxle() ).BrakeFactor or 0

		return self._brakeFactor
	end

	function ENT:PhysicsOnGround( PhysObj )
		if not PhysObj then
			PhysObj = self:GetPhysicsObject()
		end

		local EntLoad,_ = PhysObj:GetStress()

		return EntLoad > 0
	end
end

if CLIENT then
	ENT.SkidmarkTraceAdd = Vector(0,0,10)
	ENT.SkidmarkDelay = 0.05
	ENT.SkidmarkLifetime = 10

	ENT.SkidmarkTexture = Material( "vgui/white" )
	ENT.SkidmarkRed = 0
	ENT.SkidmarkGreen = 0
	ENT.SkidmarkBlue = 0
	ENT.SkidmarkAlpha = 150

	ENT.SkidmarkSurfaces = {
		["concrete"] = true,
		["tile"] = true,
		["metal"] = true,
		["boulder"] = true,
	}

	ENT.DustEffectSurfaces = {
		["sand"] = true,
		["dirt"] = true,
		["grass"] = true,
	}

	function ENT:Draw()
		self:SetRenderAngles( self:LocalToWorldAngles( self:GetAlignmentAngle() ) )
		self:DrawModel()
	end

	hook.Add("PreDrawOpaqueRenderables", "!!!!lvs_skidmarks", function( bDrawingDepth, bDrawingSkybox, isDraw3DSkybox )
		if isDraw3DSkybox then return end

		for _, wheel in ipairs( ents.FindByClass("lvs_wheeldrive_wheel") ) do
			wheel:RenderSkidMarks()
		end
	end)

	function ENT:RenderSkidMarks()
		local T = CurTime()

		render.SetMaterial( self.SkidmarkTexture )

		for id, skidmark in pairs( self:GetSkidMarks() ) do
			local prev
			local AmountDrawn = 0

			for markID, data in pairs( skidmark.positions ) do
				if not prev then

					prev = data

					continue
				end

				local Mul = math.max( data.lifetime - CurTime(), 0 ) / self.SkidmarkLifetime

				if Mul > 0 then
					AmountDrawn = AmountDrawn + 1
					render.DrawQuad( data.p2, data.p1, prev.p1, prev.p2, Color( self.SkidmarkRed, self.SkidmarkGreen, self.SkidmarkBlue, math.min(255 * Mul,self.SkidmarkAlpha) ) )
				end

				prev = data
			end

			if not skidmark.active and AmountDrawn == 0 then
				self:RemoveSkidmark( id )
			end
		end
	end

	function ENT:GetSkidMarks()
		if not istable( self._activeSkidMarks ) then
			self._activeSkidMarks = {}
		end

		return self._activeSkidMarks
	end

	function ENT:DrawTranslucent()
		local T = CurTime()

		if (self._NextFx or 0) > T then return end

		self._NextFx = T + 0.05

		self:CalcWheelEffects()
	end

	function ENT:StartSkidmark( pos )
		if self._SkidMarkID or not LVS.ShowTraileffects then return end

		local ID = 1
		for _,_ in ipairs( self:GetSkidMarks() ) do
			ID = ID + 1
		end

		self._activeSkidMarks[ ID ] = {
			active = true,
			startpos = pos + self.SkidmarkTraceAdd,
			delay = CurTime() + self.SkidmarkDelay,
			positions = {},
		}

		self._SkidMarkID = ID
	end

	function ENT:FinishSkidmark()
		if not self._SkidMarkID then return end

		self._activeSkidMarks[ self._SkidMarkID ].active = false

		self._SkidMarkID = nil
	end

	function ENT:RemoveSkidmark( id )
		if not id then return end

		self._activeSkidMarks[ id ] = nil
	end

	function ENT:CalcSkidmark( trace, Filter )
		local T = CurTime()
		local CurActive = self:GetSkidMarks()[ self._SkidMarkID ]

		if CurActive and CurActive.active then
			if CurActive.delay < T then
				CurActive.delay = T + self.SkidmarkDelay

				local W = self:GetWidth()

				local cur = trace.HitPos + self.SkidmarkTraceAdd

				local prev = CurActive.positions[ #CurActive.positions ]

				if not prev then
					local sub = cur - CurActive.startpos

					local L = sub:Length() * 0.5
					local C = (cur + CurActive.startpos) * 0.5

					local Ang = sub:Angle()
					local Forward = Ang:Right()
					local Right = Ang:Forward()

					local p1 = C + Forward * W + Right * L
					local p2 = C - Forward * W + Right * L

					local t1 = util.TraceLine( { start = p1, endpos = p1 - self.SkidmarkTraceAdd } )
					local t2 = util.TraceLine( { start = p2, endpos = p2 - self.SkidmarkTraceAdd } )

					prev = {
						px = CurActive.startpos,
						p1 = t1.HitPos + t1.HitNormal,
						p2 = t2.HitPos + t2.HitNormal,
						lifetime = T + self.SkidmarkLifetime - self.SkidmarkDelay,
					}
				end

				local sub = cur - prev.px

				local L = sub:Length() * 0.5
				local C = (cur + prev.px) * 0.5

				local Ang = sub:Angle()
				local Forward = Ang:Right()
				local Right = Ang:Forward()

				local p1 = C + Forward * W + Right * L
				local p2 = C - Forward * W + Right * L

				local t1 = util.TraceLine( { start = p1, endpos = p1 - self.SkidmarkTraceAdd, filter = Filter, } )
				local t2 = util.TraceLine( { start = p2, endpos = p2 - self.SkidmarkTraceAdd, filter = Filter, } )

				CurActive.positions[ #CurActive.positions + 1 ] = {
					px = cur,
					p1 = t1.HitPos + t1.HitNormal,
					p2 = t2.HitPos + t2.HitNormal,
					lifetime = T + self.SkidmarkLifetime,
				}
			end
		end
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

			if Scale > 0.5 then
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

	function ENT:CalcWheelEffects()
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

		local WheelSlip = math.max( rpm - rpmTheoretical, 0 ) ^ 2 + math.abs( Base:VectorSplitNormal( self:GetForward(), Vel * 2 ) )

		if WheelSlip < 500 then self:StopWheelEffects() return end

		local SkidValue = VelLength + WheelSlip

		self:StartWheelEffects( Base, SkidValue, trace, traceWater )
	end

	function ENT:Think()
		return false
	end

	function ENT:OnRemove()
		self:StopWheelEffects()
	end
end