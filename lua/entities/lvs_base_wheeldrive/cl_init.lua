include("shared.lua")
include("sh_animations.lua")
include("sh_camera_eyetrace.lua")
include("cl_flyby.lua")
include("cl_tiresounds.lua")
include("cl_camera.lua")
include("cl_hud.lua")
include("cl_scrolltexture.lua")

DEFINE_BASECLASS( "lvs_base" )

function ENT:CreateSubMaterial( SubMaterialID, name )
	if not SubMaterialID then return end

	local mat = self:GetMaterials()[ SubMaterialID + 1 ]

	if not mat then return end

	local string_data = file.Read( "materials/"..mat..".vmt", "GAME" )

	if not string_data then return end

	return CreateMaterial( name, "VertexLitGeneric", util.KeyValuesToTable( string_data ) )
end

function ENT:QuickLerp( name, target, rate )
	name =  "_smValue"..name

	if not self[ name ] then self[ name ] = 0 end

	self[ name ] = self[ name ] + (target - self[ name ]) * math.min( RealFrameTime() * (rate or 10), 1 )

	return self[ name ]
end

function ENT:CalcPoseParameters()
	local steer = self:GetSteer() /  self:GetMaxSteerAngle()

	local kmh = math.Round( self:GetVelocity():Length() * 0.09144, 0 )

	local lights = self:GetLightsHandler()
	local ammeter = 0.5

	local rpm = 0
	local oil = 0.25

	local gear = 1
	local clutch = 0

	local throttle = self:GetThrottle()

	local engine = self:GetEngine()
	local engineActive = self:GetEngineActive()

	local fuel = 1
	local fueltank = self:GetFuelTank()

	local handbrake = self:QuickLerp( "handbrake", self:GetNWHandBrake() and 1 or 0 )

	local temperature = 0

	if IsValid( engine ) then
		rpm = self:QuickLerp( "rpm", engine:GetRPM() )
		gear = engine:GetGear()
		oil = self:QuickLerp( "oil", engineActive and math.min( 0.2 + (rpm / self.EngineMaxRPM) * 1.25, 1 ) or 0, 0.1 ) ^ 2

		local ClutchActive = engine:GetClutch()

		clutch = self:QuickLerp( "clutch", ClutchActive and 1 or 0 )

		if ClutchActive then
			throttle = math.max( throttle - clutch, 0 )
		end

		temperature = self:QuickLerp( "temp", self:QuickLerp( "base_temp", engineActive and 0.5 or 0, 0.025 + throttle * 0.1 ) + (1 - engine:GetHP() / engine:GetMaxHP()) ^ 2 * 1.25, 0.5 )
	else
		temperature = self:QuickLerp( "temp", self:QuickLerp( "base_temp", engineActive and 0.5 or 0, 0.025 + throttle * 0.1 ) + (1 - self:GetHP() / self:GetMaxHP()) ^ 2 * 1.25, 0.5 )
	end

	if IsValid( lights ) then
		local Available = 0.5 + (rpm / self.EngineMaxRPM) * 0.25

		local Use1 = lights:GetActive() and 0.1 or 0
		local Use2 = lights:GetHighActive() and 0.15 or 0
		local Use3 = lights:GetFogActive() and 0.05 or 0
		local Use4 = (self:GetTurnMode() ~= 0 and  self:GetTurnFlasher()) and 0.03 or 0

		ammeter = self:QuickLerp( "ammeter", math.max( Available - Use1 - Use2 - Use3 - Use4, 0 ), math.Rand(1,10) )
	end

	if IsValid( fueltank ) then
		fuel = self:QuickLerp( "fuel", fueltank:GetFuel() )
	end

	self:UpdatePoseParameters( steer, self:QuickLerp( "kmh", kmh ), rpm, throttle, self:GetBrake(), handbrake, clutch, (self:GetReverse() and -gear or gear), temperature, fuel, oil, ammeter )
	self:InvalidateBoneCache()
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
		self:EmitSound( self.TransShiftSound, 75 )
	end

	self:SuppressViewPunch( self.TransShiftSpeed )
end

function ENT:GetTurnFlasher()
	return math.cos( CurTime() * 8 + self:EntIndex() * 1337 ) > 0
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/generic/engine_start1.wav", 75, 100,  LVS.EngineVolume )
	else
		self:EmitSound( "vehicles/jetski/jetski_off.wav", 75, 100,  LVS.EngineVolume )
	end
end

function ENT:DoExhaustFX( Magnitude )
	for _, data in ipairs( self.ExhaustPositions ) do
		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( data.pos ) )
			effectdata:SetNormal( self:LocalToWorldAngles( data.ang ):Forward() )
			effectdata:SetMagnitude( Magnitude )
			effectdata:SetEntity( self )
		util.Effect( "lvs_exhaust", effectdata )
	end
end

function ENT:GetWheels()
	local wheels = {}

	for _, ent in pairs( self:GetCrosshairFilterEnts() ) do
		if not IsValid( ent ) or ent:GetClass() ~= "lvs_wheeldrive_wheel" then continue end

		table.insert( wheels, ent )
	end

	return wheels
end