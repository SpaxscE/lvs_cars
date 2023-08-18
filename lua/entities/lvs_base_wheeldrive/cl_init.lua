include("shared.lua")
include("sh_animations.lua")
include("sh_camera_eyetrace.lua")
include("cl_flyby.lua")
include("cl_tiresounds.lua")
include("cl_camera.lua")
include("cl_hud.lua")

DEFINE_BASECLASS( "lvs_base" )

function ENT:QuickLerp( name, target, rate )
	name =  "_smValue"..name

	if not self[ name ] then self[ name ] = 0 end

	self[ name ] = self[ name ] + (target - self[ name ]) * FrameTime() * (rate or 10)

	return self[ name ]
end

function ENT:CalcPoseParameters()
	local steer = self:GetSteer() /  self:GetMaxSteerAngle()
	local kmh = math.Round( self:GetVelocity():Length() * 0.09144, 0 )
	local rpm = 0
	local gear = 1
	local clutch = 0
	local throttle = self:GetThrottle()
	local engine = self:GetEngine()
	local engineActive = self:GetEngineActive()
	local fuel = 1
	local fueltank = self:GetFuelTank()
	local handbrake = self:QuickLerp( "handbrake", self:GetNWHandBrake() and 1 or 0 )

	if IsValid( engine ) then
		rpm = self:QuickLerp( "rpm", engineActive and engine:GetRPM() or 0 )
		gear = engine:GetGear()

		local ClutchActive = engine:GetClutch()

		clutch = self:QuickLerp( "clutch", ClutchActive and 1 or 0 )

		if ClutchActive then
			throttle = math.max( throttle - clutch, 0 )
		end
	end

	if IsValid( fueltank ) then
		fuel = self:QuickLerp( "fuel", fueltank:GetFuel() )
	end

	local temperature = self:QuickLerp( "temp", self:QuickLerp( "base_temp", engineActive and 0.5 or 0, 0.025 + throttle * 0.1 ) + (1 - self:GetHP() / self:GetMaxHP()) ^ 2 * 1.25, 0.5 )

	self:UpdatePoseParameters( steer, self:QuickLerp( "kmh", kmh ), rpm, throttle, self:GetBrake(), handbrake, clutch, (self:GetReverse() and -gear or gear), temperature, fuel )
	self:InvalidateBoneCache()
end

function ENT:PreDraw()
	return true
end

function ENT:PreDrawTranslucent()
	return true
end

function ENT:PostDraw()
end

function ENT:Think()
	if not self:IsInitialized() then return end

	BaseClass.Think( self )

	self:TireSoundThink()

	if isfunction( self.UpdatePoseParameters ) then
		self:CalcPoseParameters()
	else
		self:SetPoseParameter( "vehicle_steer", self:GetSteer() /  self:GetMaxSteerAngle() )
		self:InvalidateBoneCache()
	end
 end
 
function ENT:OnRemove()
	self:TireSoundRemove()

	BaseClass.OnRemove( self )
end

function ENT:PostDrawTranslucent()
	local Handler = self:GetLightsHandler()

	if not IsValid( Handler ) or not istable( self.Lights ) then return end

	Handler:RenderLights( self, self.Lights )
end

function ENT:DoExhaustBackFire()
	if not istable( self.ExhaustPositions ) then return end

	for _, data in ipairs( self.ExhaustPositions ) do
		if math.random( 1, math.floor( #self.ExhaustPositions * 0.75 ) ) ~= 1 then continue end

		timer.Simple( math.Rand(0.5,1), function()
			local effectdata = EffectData()
				effectdata:SetOrigin( data.pos )
				effectdata:SetAngles( data.ang )
				effectdata:SetEntity( self )
			util.Effect( "lvs_carexhaust_backfire", effectdata )
		end )
	end
end

function ENT:OnEngineStallBroken()
	for i = 0,math.random(3,6) do
		timer.Simple( math.Rand(0,1.5) , function()
			if not IsValid( self ) then return end

			self:DoExhaustBackFire()
		end )
	end
end

function ENT:OnChangeGear( oldGear, newGear )
	if self:GetHP() < self:GetMaxHP() * 0.5 and oldGear > newGear then
		self:EmitSound( "lvs/vehicles/generic/gear_grind"..math.random(1,6)..".ogg", 75, math.Rand(70,100), 0.25 )

		self:DoExhaustBackFire()
	else
		self:EmitSound( "buttons/lever7.wav", 75, 80, 0.25 )
	end

	self:SuppressViewPunch( self.TransShiftSpeed )
end

function ENT:GetTurnFlasher()
	return math.cos( CurTime() * 8 + self:EntIndex() * 1337 ) > 0
end
