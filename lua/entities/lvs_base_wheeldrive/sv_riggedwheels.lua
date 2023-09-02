
local function SetAll( ent, n )
	if not IsValid( ent ) then return end

	ent:SetPoseParameter("vehicle_wheel_fl_height",n) 
	ent:SetPoseParameter("vehicle_wheel_fr_height",n) 
	ent:SetPoseParameter("vehicle_wheel_rl_height",n) 
	ent:SetPoseParameter("vehicle_wheel_rr_height",n)
end

function ENT:CreateRigControler( name, wheelEntity, min, max )
	if IsValid( self:GetEngine() ) then return end

	local RigHandler = ents.Create( "lvs_wheeldrive_righandler" )

	if not IsValid( RigHandler ) then
		self:Remove()

		print("LVS: Failed to create righandler entity. Vehicle terminated.")

		return
	end

	RigHandler:SetPos( self:GetPos() )
	RigHandler:SetAngles( self:GetAngles() )
	RigHandler:Spawn()
	RigHandler:Activate()
	RigHandler:SetParent( self )
	RigHandler:SetBase( self )
	RigHandler:SetPose0( min )
	RigHandler:SetPose1( max )
	RigHandler:SetWheel( wheelEntity )
	RigHandler:SetNameID( name )

	self:DeleteOnRemove( RigHandler )

	self:TransferCPPI( RigHandler )

	return RigHandler
end

function ENT:AddWheelsUsingRig( FrontRadius, RearRadius )
	local Body = ents.Create( "prop_dynamic" )
	Body:SetModel( self:GetModel() )
	Body:SetPos( self:GetPos() )
	Body:SetAngles( self:GetAngles() )
	Body:SetMoveType( MOVETYPE_NONE )
	Body:Spawn()
	Body:Activate()

	SetAll( Body, 0 )

	SafeRemoveEntityDelayed( Body, 0.3 )

	local id_fl = Body:LookupAttachment( "wheel_fl" )
	local id_fr = Body:LookupAttachment( "wheel_fr" )
	local id_rl = Body:LookupAttachment( "wheel_rl" )
	local id_rr = Body:LookupAttachment( "wheel_rr" )

	local ForwardAngle = angle_zero

	if not isnumber( FrontRadius ) or not isnumber( RearRadius ) or id_fl == 0 or id_fr == 0 or id_rl == 0 or id_rr == 0 then return NULL, NULL, NULL, NULL, ForwardAngle end

	local pFL0 = Body:WorldToLocal( Body:GetAttachment( id_fl ).Pos )
	local pFR0 = Body:WorldToLocal( Body:GetAttachment( id_fr ).Pos )
	local pRL0 = Body:WorldToLocal( Body:GetAttachment( id_rl ).Pos )
	local pRR0 = Body:WorldToLocal( Body:GetAttachment( id_rr ).Pos )

	local ForwardAngle = ((pFL0 + pFR0) / 2 - (pRL0 + pRR0) / 2):Angle()
	ForwardAngle.p = 0
	ForwardAngle.r = 0
	ForwardAngle:Normalize() 

	local FL = self:AddWheel( { hide = true, pos = pFL0, radius = FrontRadius } )
	local FR = self:AddWheel( { hide = true, pos = pFR0, radius = FrontRadius } )
	local RL = self:AddWheel( { hide = true, pos = pRL0, radius = RearRadius } )
	local RR = self:AddWheel( { hide = true, pos = pRR0, radius = RearRadius } )

	SetAll( Body, 1 )

	timer.Simple( 0.15, function()
		if not IsValid( self ) or not IsValid( Body ) then return end

		local pFL1 = Body:WorldToLocal( Body:GetAttachment( id_fl ).Pos )
		local pFR1 = Body:WorldToLocal( Body:GetAttachment( id_fr ).Pos )
		local pRL1 = Body:WorldToLocal( Body:GetAttachment( id_rl ).Pos )
		local pRR1 = Body:WorldToLocal( Body:GetAttachment( id_rr ).Pos )

		self:CreateRigControler( "fl", FL, pFL0.z, pFL1.z )
		self:CreateRigControler( "fr", FR, pFR0.z, pFR1.z )
		self:CreateRigControler( "rl", RL, pRL0.z, pRL1.z )
		self:CreateRigControler( "rr", RR, pRR0.z, pRR1.z )
	end )

	return FL, FR, RL, RR, ForwardAngle
end