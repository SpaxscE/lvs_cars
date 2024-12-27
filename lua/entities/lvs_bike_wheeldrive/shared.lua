
ENT.Base = "lvs_base_wheeldrive"

ENT.PrintName = "[LVS] Wheeldrive Bike"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.MaxHealth = 750

ENT.MaxVelocity = 1250
ENT.MaxVelocityReverse = 100

ENT.EngineCurve = 0.4
ENT.EngineTorque = 250

ENT.TransGears = 4
ENT.TransGearsReverse = 1

ENT.PhysicsMass = 250
ENT.PhysicsWeightScale = 0.5
ENT.PhysicsInertia = Vector(400,400,200)

ENT.ForceAngleMultiplier = 0.5

ENT.PhysicsDampingSpeed = 250
ENT.PhysicsDampingForward = true
ENT.PhysicsDampingReverse = false

ENT.PhysicsRollMul = 1
ENT.PhysicsDampingRollMul = 1
ENT.PhysicsWheelGyroMul = 1

ENT.WheelPhysicsMass = 250
ENT.WheelPhysicsInertia = Vector(5,4,5)

ENT.WheelSideForce = 800
ENT.WheelDownForce = 1000

function ENT:ShouldPutFootDown()
	return self:GetNWHandBrake() or self:GetVelocity():Length() < 20
end

function ENT:CalcMainActivity( ply )
	if ply ~= self:GetDriver() then return self:CalcMainActivityPassenger( ply ) end

	if ply.m_bWasNoclipping then 
		ply.m_bWasNoclipping = nil 
		ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM ) 
		
		if CLIENT then 
			ply:SetIK( true )
		end 
	end 

	ply.CalcIdeal = ACT_STAND
	ply.CalcSeqOverride = ply:LookupSequence( "drive_airboat" )

	return ply.CalcIdeal, ply.CalcSeqOverride
end

function ENT:GetWheelUp()
	return self:GetUp() * math.Clamp( math.abs( self:GetSteer() / 20 ), 1, 1.5 )
end

function ENT:GetVehicleType()
	return "bike"
end
