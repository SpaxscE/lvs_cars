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

	self[ name ] = self[ name ] + (target - self[ name ]) * RealFrameTime() * (rate or 10)

	return self[ name ]
end

function ENT:GetRotationDelta( name, rot )
	name =  "_deltaAng"..name

	if not self[ name ] then self[ name ] = Angle(0,0,0) end

	local ang = Angle(0,0,rot)
	local cur = ang:Right()
	local old = self[ name ]:Up()

	local delta = self:AngleBetweenNormal( cur, old ) - 90

	self[ name ] = ang

	return delta
end

function ENT:ScrollTexture( name, material, pos )
	if not isstring( name ) or not isstring( material ) or not isvector( pos ) then return "" end

	local id = self:EntIndex()
	local class = self:GetClass()

	local texture_name = class.."_["..id.."]_"..name

	if istable( self._StoredScrollTextures ) then
		if self._StoredScrollTextures[ texture_name ] then
			self._StoredScrollTextures[ texture_name ].mat:SetVector("$translate", self._StoredScrollTextures[ texture_name ].pos )

			self._StoredScrollTextures[ texture_name ].pos = self._StoredScrollTextures[ texture_name ].pos + pos

			if self._StoredScrollTextures[ texture_name ].pos:LengthSqr() > 2500000000 then
				self._StoredScrollTextures[ texture_name ].pos = Vector(0,0,0)
			end

			return "!"..texture_name
		end
	else
		self._StoredScrollTextures = {}
	end

	local mat = CreateMaterial(texture_name, "VertexLitGeneric", { ["$basetexture"] = "models/blu/track_sherman", ["$alphatest"] = "1", ["$translate"] = "[0.0 0.0 0.0]", ["Proxies"] = { ["TextureTransform"] = { ["translateVar"] = "$translate", ["centerVar"]    = "$center",["resultVar"]    = "$basetexturetransform", } } } )

	self._StoredScrollTextures[ texture_name ] = {
		mat = mat,
		pos = pos,
	}

	return "!"..texture_name
end

function ENT:CalcPoseParameters()
	local steer = self:GetSteer() /  self:GetMaxSteerAngle()
	local kmh = math.Round( self:GetVelocity():Length() * 0.09144, 0 )
	local rpm = 0
	local gear = 1
	local clutch = 0
	local throttle = self:GetThrottle()
	local engine = self:GetEngine()
	local handbrake = self:QuickLerp( "handbrake", self:GetNWHandBrake() and 1 or 0 )

	if IsValid( engine ) then
		rpm = self:QuickLerp( "rpm", engine:GetRPM() )
		gear = engine:GetGear()

		local ClutchActive = engine:GetClutch()

		clutch = self:QuickLerp( "clutch", ClutchActive and 1 or 0 )

		if ClutchActive then
			throttle = math.max( throttle - clutch, 0 )
		end
	end

	self:UpdatePoseParameters( steer, self:QuickLerp( "kmh", kmh ), rpm, throttle, self:GetBrake(), handbrake, clutch, (self:GetReverse() and -gear or gear) )
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

function ENT:OnChangeGear( oldGear, newGear )
	self:EmitSound( "buttons/lever7.wav", 75, 80, 0.25 )

	self:SuppressViewPunch( self.TransShiftSpeed )
end

function ENT:GetTurnFlasher()
	return math.cos( CurTime() * 8 + self:EntIndex() * 1337 ) > 0
end
