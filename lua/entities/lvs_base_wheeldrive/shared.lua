
ENT.Base = "lvs_base"

ENT.PrintName = "[LVS] Wheeldrive Base"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.MaxVelocity = 1200

ENT.EnginePower = 25
ENT.EngineTorque = 350

ENT.TransGears = 4
ENT.TransMinGearHoldTime = 1
ENT.TransShiftSpeed = 0.3

ENT.SteerSpeed = 3
ENT.SteerReturnSpeed = 10

ENT.FastSteerActiveVelocity = 500
ENT.FastSteerAngleClamp = 10
ENT.FastSteerDeactivationDriftAngle = 5

ENT.SteerAssistDeadZoneAngle = 3
ENT.SteerAssistMaxAngle = 15
ENT.SteerAssistMultiplier = 1

ENT.PhysicsDrag = false
ENT.PhysicsMass = 1000
ENT.PhysicsInertia = Vector(1500,1500,750)

ENT.WheelPhysicsDrag = false
ENT.WheelPhysicsMass = 100
ENT.WheelPhysicsInertia = Vector(10,10,10)

ENT.WheelBrakeLockupRPM = 50
ENT.WheelBrakeForce = 400

ENT.WheelDownForce = 1000
ENT.WheelDownForcePowered = 1000

function ENT:SetupDataTables()
	self:CreateBaseDT()

	self:AddDT( "Float", "Steer" )
	self:AddDT( "Float", "Throttle" )
	self:AddDT( "Float", "Brake" )

	self:AddDT( "Float", "NWMaxSteer" )

	self:AddDT( "Float", "WheelVelocity" )
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

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/kuebelwagen/engine_low.wav",
		Volume = 0.5,
		Pitch = 85,
		PitchMul = 25,
		Type = 0,
		SoundLevel = 75,
		UseDoppler = true,
	},
	{
		sound = "lvs/vehicles/kuebelwagen/engine_mid.wav",
		--sound_int = "lvs/vehicles/kuebelwagen/engine_high.wav",
		Volume = 1,
		Pitch = 100,
		PitchMul = 100,
		Type = 1,
		SoundLevel = 75,
		UseDoppler = true,
	},
}
