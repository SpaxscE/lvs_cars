AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )

	self:NetworkVar( "Bool",0, "Active" )

	self:NetworkVar( "String",0, "PoseName" )
end

if SERVER then
	function ENT:Initialize()	
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		self:DrawShadow( false )
		debugoverlay.Cross( self:GetPos(), 50, 5, Color( 255, 223, 127 ) )
	end

	function ENT:Open()
		self:SetActive( true )
	end

	function ENT:Close()
		self:SetActive( false )
	end

	function ENT:IsOpen()
		return self:GetActive()
	end

	function ENT:Think()
		return false
	end

	function ENT:OnTakeDamage( dmginfo )
	end

	function ENT:UpdateTransmitState() 
		return TRANSMIT_ALWAYS
	end

	return
end

function ENT:Initialize()
end

function ENT:Think()
	local Base = self:GetBase()

	if not IsValid( Base ) then return end

	local Target = self:GetActive() and 1 or 0
	local poseName = self:GetPoseName()

	if poseName == "" then return end

	self.sm_pp = self.sm_pp and self.sm_pp + (Target - self.sm_pp) * RealFrameTime() * 10 or 0

	Base:SetPoseParameter( poseName, self.sm_pp ^ 2 )
end

function ENT:OnRemove()
end

function ENT:Draw()
end

function ENT:DrawTranslucent()
end
