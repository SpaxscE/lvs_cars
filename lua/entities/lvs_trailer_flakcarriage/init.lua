AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	local WheelModel = "models/diggercars/m5m16/m5_wheel.mdl"

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			SteerAngle = 0,
			BrakeFactor = 1,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(3.41,35,2),
				mdl = WheelModel,
				mdl_ang = Angle(0,180,0),
			} ),

			self:AddWheel( {
				pos = Vector(3.41,-35,2),
				mdl = WheelModel,
				mdl_ang = Angle(0,0,0),

			} ),
		},
		Suspension = {
			Height = 0,
			MaxTravel = 0,
			ControlArmLength = 0,
		},
	} )

	self:AddTrailerHitch( Vector(-86.5,0,18), LVS.HITCHTYPE_FEMALE )

	local SupportEnt = ents.Create( "prop_physics" )

	if not IsValid( SupportEnt ) then return end

	SupportEnt:SetModel( "models/props_junk/PopCan01a.mdl" )
	SupportEnt:SetPos( self:LocalToWorld( Vector(-57,0,-13) ) )
	SupportEnt:SetAngles( self:GetAngles() )
	SupportEnt:Spawn()
	SupportEnt:Activate()
	SupportEnt:PhysicsInitSphere( 5, "default_silent" )
	SupportEnt:SetNoDraw( true ) 
	SupportEnt:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )
	SupportEnt.DoNotDuplicate = true
	self:DeleteOnRemove( SupportEnt )

	constraint.Weld( self, SupportEnt, 0, 0, 0, false, true )

	self.SupportEnt = SupportEnt:GetPhysicsObject()

	if not IsValid( self.SupportEnt ) then return end

	self.SupportEnt:SetMass( 250 )
end


function ENT:OnCoupled( targetVehicle, targetHitch )
	if not IsValid( self.SupportEnt ) then return end
	self.SupportEnt:SetMass( 1 )
end

function ENT:OnDecoupled( targetVehicle, targetHitch )
	if not IsValid( self.SupportEnt ) then return end
	self.SupportEnt:SetMass( 250 )
end

function ENT:OnStartDrag( caller, activator )
	if not IsValid( self.SupportEnt ) then return end
	self.SupportEnt:SetMass( 1 )
end

function ENT:OnStopDrag( caller, activator )
	if not IsValid( self.SupportEnt ) then return end
	self.SupportEnt:SetMass( 250 )
end
