include("shared.lua")
include("sh_animations.lua")
include("cl_flyby.lua")
include("cl_tiresounds.lua")
include("cl_camera.lua")
include("cl_hud.lua")

DEFINE_BASECLASS( "lvs_base" )

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
