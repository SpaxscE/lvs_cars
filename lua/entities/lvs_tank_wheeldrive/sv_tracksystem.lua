
function ENT:CreateTrackPhysics( mdl )
	if not isstring( mdl ) then return NULL end

	local TrackPhysics = ents.Create( "lvs_wheeldrive_component" )

	if not IsValid( TrackPhysics ) then return NULL end

	TrackPhysics:SetModel( mdl )
	TrackPhysics:SetPos( self:GetPos() )
	TrackPhysics:SetAngles( self:GetAngles() )
	TrackPhysics:Spawn()
	TrackPhysics:Activate()
	TrackPhysics:SetBase( self )
	self:TransferCPPI( TrackPhysics )
	self:DeleteOnRemove( TrackPhysics )

	constraint.Weld( TrackPhysics, self, 0, 0 )

	local weld_constraint = TrackPhysics:SetCollisionGroup( COLLISION_GROUP_WORLD )
	weld_constraint.DoNotDuplicate = true

	return TrackPhysics
end

function ENT:CreateWheelChain( wheels )
	if not istable( wheels ) then return end

	local Lock = 0.0001
	local VectorNull = Vector(0,0,0)

	for _, wheel in pairs( wheels ) do
		if not IsValid( wheel ) then continue end

		wheel:SetWheelChainMode( true )
		wheel:SetWidth( 0 )
		wheel:SetCollisionBounds( VectorNull, VectorNull )
	end

	for i = 2, #wheels do
		local prev = wheels[ i - 1 ]
		local cur = wheels[ i ]

		if not IsValid( cur ) or not IsValid( prev ) then continue end

		local B = constraint.AdvBallsocket(prev,cur,0,0,vector_origin,vector_origin,0,0,-Lock,-180,-180,Lock,180,180,0,0,0,1,1)
		B.DoNotDuplicate = true

		local Rope = constraint.Rope(prev,cur,0,0,vector_origin,vector_origin,(prev:GetPos() - cur:GetPos()):Length(), 0, 0, 0,"cable/cable2", false)
		Rope.DoNotDuplicate = true
	end

	local WheelChain = {}

	WheelChain.OnDestroyed = function()
		for _, wheel in pairs( wheels ) do
			if not IsValid( wheel ) then continue end

			wheel:Destroy()
		end
	end

	WheelChain.OnRepaired = function()
		for _, wheel in pairs( wheels ) do
			if not IsValid( wheel ) then continue end

			wheel:Repair()
		end
	end

	return WheelChain
end