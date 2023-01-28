
function ENT:SetMassCenter( offset )
	if IsValid( self._MassCenterEntity ) then
		self._MassCenterEntity:Remove()
	end

	local PObj = self:GetPhysicsObject()

	local Mass = PObj:GetMass()
	local NewMass = Mass * 0.75

	PObj:SetMass( NewMass )

	local MassCenterOffset = offset or Vector(0,0,0)
	local BaseMassCenter = self:LocalToWorld( PObj:GetMassCenter() - MassCenterOffset )

	local OffsetMass = Mass * 0.25

	local CenterWheels = Vector(0,0,0)
	for _, Wheel in pairs( self:GetWheels() ) do
		CenterWheels = CenterWheels + Wheel:GetPos()
	end
	CenterWheels = CenterWheels / #self:GetWheels()

	if CenterWheels:Length() <= 1 then return end

	local Sub = CenterWheels - BaseMassCenter
	local Dir = Sub:GetNormalized()
	local Dist = Sub:Length()
	local DistAdd = NewMass * Dist / OffsetMass

	local OffsetMassCenter = BaseMassCenter + Dir * (Dist + DistAdd)

	local MassOffset = ents.Create( "prop_physics" )
	MassOffset:SetModel( "models/hunter/plates/plate.mdl" )
	MassOffset:SetPos( OffsetMassCenter )
	MassOffset:SetAngles( self:GetAngles() )
	MassOffset:Spawn()
	MassOffset:Activate()
	MassOffset.DoNotDuplicate = true
	MassOffset:SetOwner( self )
	MassOffset:DrawShadow( false )
	MassOffset:SetNotSolid( true )
	MassOffset:SetNoDraw( true )

	self:TransferCPPI( MassOffset )

	local PhysObj = MassOffset:GetPhysicsObject()

	if not IsValid( PhysObj ) then
		self:Remove()

		print("LVS: Failed to create masscenter counter weight. Vehicle terminated.")

		return
	end

	PhysObj:EnableMotion( false )
	PhysObj:SetMass( OffsetMass )
	PhysObj:EnableDrag( false )

	local weld = constraint.Weld( MassOffset, self, 0, 0, 0, true, true ) 
	weld.DoNotDuplicate = true

	local ballsocket = constraint.AdvBallsocket( MassOffset, self,0,0, Vector(0,0,0), Vector(0,0,0), 0,0, -0.01, -0.01, -0.01, 0.01, 0.01, 0.01, 0, 0, 0, 0, 1)
	ballsocket.DoNotDuplicate = true

	PhysObj:EnableMotion( true )

	self._MassCenterEntity = MassOffset
end
