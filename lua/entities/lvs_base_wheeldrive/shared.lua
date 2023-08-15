
ENT.Base = "lvs_base"

ENT.PrintName = "[LVS] Wheeldrive Base"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.MaxVelocity = 1200
ENT.MaxVelocityReverse = 500

ENT.EnginePower = 25
ENT.EngineTorque = 350
ENT.EngineIdleRPM = 1000
ENT.EngineMaxRPM = 6000

ENT.ForceLinearMultiplier = 1
ENT.ForceAngleMultiplier = 1

ENT.TransGears = 4
ENT.TransGearsReverse = 1
ENT.TransMinGearHoldTime = 1
ENT.TransShiftSpeed = 0.3
ENT.TransWobble = 40
ENT.TransWobbleTime = 2
ENT.TransWobbleFrequencyMultiplier = 1

ENT.SteerSpeed = 3
ENT.SteerReturnSpeed = 10

ENT.FastSteerActiveVelocity = 500
ENT.FastSteerAngleClamp = 10
ENT.FastSteerDeactivationDriftAngle = 7

ENT.SteerAssistDeadZoneAngle = 1
ENT.SteerAssistMaxAngle = 15
ENT.SteerAssistExponent = 1.5
ENT.SteerAssistMultiplier = 3

ENT.PhysicsWeightScale = 1

ENT.PhysicsDrag = false
ENT.PhysicsMass = 1000
ENT.PhysicsInertia = Vector(1500,1500,750)
ENT.PhysicsDampingSpeed = 4000

ENT.WheelPhysicsDrag = false
ENT.WheelPhysicsMass = 100
ENT.WheelPhysicsInertia = Vector(10,8,10)
ENT.WheelPhysicsDampingSpeed = 500

ENT.WheelBrakeLockupRPM = 50
ENT.WheelBrakeForce = 400

ENT.WheelSideForce = 800
ENT.WheelDownForce = 500

function ENT:SetupDataTables()
	self:CreateBaseDT()

	self:AddDT( "Float", "Steer" )
	self:AddDT( "Float", "Throttle" )
	self:AddDT( "Float", "Brake" )

	self:AddDT( "Float", "NWMaxSteer" )

	self:AddDT( "Float", "WheelVelocity" )

	self:AddDT( "Int", "TurnMode" )

	self:AddDT( "Bool", "Reverse" )
	self:AddDT( "Bool", "NWHandBrake" )

	self:AddDT( "Entity", "Engine" )
	self:AddDT( "Entity", "LightsHandler" )

	self:AddDT( "Vector", "AIAimVector" )
end

function ENT:GetMaxSteerAngle()
	if CLIENT then return self:GetNWMaxSteer() end

	if self._WheelMaxSteerAngle then return self._WheelMaxSteerAngle end

	local Cur = 0

	for _, Axle in pairs( self._WheelAxleData ) do
		if not Axle.SteerAngle then continue end

		if Axle.SteerAngle > Cur then
			Cur = Axle.SteerAngle
		end
	end

	self._WheelMaxSteerAngle = Cur

	self:SetNWMaxSteer( Cur )

	return Cur
end

function ENT:GetTargetVelocity()
	if self:GetReverse() then
		return -self.MaxVelocityReverse
	end

	return self.MaxVelocity
end

function ENT:HasHighBeams()
	if isbool( self._HasHighBeams ) then return self._HasHighBeams end

	if not istable( self.Lights ) then return false end

	local HasHigh = false

	for _, data in pairs( self.Lights ) do
		if not istable( data ) then continue end

		for id, typedata in pairs( data ) do
			if id == "Trigger" and typedata == "high" then
				HasHigh = true

				break
			end
		end
	end

	self._HasHighBeams = HasHigh

	return HasHigh
end

function ENT:HasFogLights()
	if isbool( self._HasFogLights ) then return self._HasFogLights end

	if not istable( self.Lights ) then return false end

	local HasFog = false

	for _, data in pairs( self.Lights ) do
		if not istable( data ) then continue end

		for id, typedata in pairs( data ) do
			if id == "Trigger" and typedata == "fog" then
				HasFog = true

				break
			end
		end
	end

	self._HasFogLights = HasFog

	return HasFog
end

function ENT:HasTurnSignals()
	if isbool( self._HasTurnSignals ) then return self._HasTurnSignals end

	if not istable( self.Lights ) then return false end

	local HasTurnSignals = false

	for _, data in pairs( self.Lights ) do
		if not istable( data ) then continue end

		for id, typedata in pairs( data ) do
			if id == "Trigger" and (typedata == "turnleft" or  typedata == "turnright" or typedata == "main+brake+turnleft" or typedata == "main+brake+turnright") then
				HasTurnSignals = true

				break
			end
		end
	end

	self._HasTurnSignals = HasTurnSignals

	return HasTurnSignals
end

function ENT:BodyGroupIsValid( bodygroups )
	for index, groups in pairs( bodygroups ) do
		local mygroup = self:GetBodygroup( index )
		for g_index = 1, table.Count( groups ) do
			if mygroup == groups[g_index] then return true end
		end
	end

	return false
end