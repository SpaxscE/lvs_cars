AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )

	self:NetworkVar( "Bool",0, "Active" )

	self:NetworkVar( "Int",0, "BoneID" )

	self:NetworkVar( "Angle", 0, "AngleOpen" )
	self:NetworkVar( "Angle", 1, "AngleClosed" )

	if SERVER then
		self:SetBoneID( -1 )
	end
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

	--local TargetAngle = self:GetActive() and self:GetAngleOpen() or self:GetAngleClosed()

	local Target = self:GetActive() and 1 or 0

	self._smAngle = self._smAngle and self._smAngle + (Target - self._smAngle) * RealFrameTime() or 0

	local Mul1 = self._smAngle
	local Mul2 = 1 - self._smAngle

	local Ang = self:GetAngleOpen() * Mul1 + self:GetAngleClosed() * Mul2

	Base:ManipulateBoneAngles( self:GetBoneID(), Ang )
end

function ENT:OnRemove()
end

function ENT:Draw()
end

function ENT:DrawTranslucent()
end
