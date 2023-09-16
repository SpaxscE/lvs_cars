
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

	self:NetworkVar( "Float", 6, "HP" )
	self:NetworkVar( "Float", 7, "MaxHP" )

	self:NetworkVar( "Angle", 0, "AlignmentAngle" )

	self:NetworkVar( "Entity", 0, "Base" )

	self:NetworkVar( "Bool", 0, "HideModel" )

	self:NetworkVar( "Bool", 1, "Destroyed" )

	if SERVER then
		self:SetMaxHP( 100 )
		self:SetHP( 100 )

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

function ENT:CheckAlignment()
	self.CamberCasterToe = (math.abs( self:GetToe() ) + math.abs( self:GetCaster() ) + math.abs( self:GetCamber() )) ~= 0
end