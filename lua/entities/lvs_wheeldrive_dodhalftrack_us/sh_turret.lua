
include("entities/lvs_tank_wheeldrive/modules/sh_turret.lua")

ENT.TurretAimRate = 50

ENT.TurretFakeBarrel = true
ENT.TurretRotationCenter =  Vector(-63,0,85)

ENT.TurretRotationSound = "vehicles/tank_turret_loop1.wav"

ENT.TurretPitchPoseParameterName = "turret_pitch"
ENT.TurretPitchMin = -30
ENT.TurretPitchMax = 40
ENT.TurretPitchMul = 1
ENT.TurretPitchOffset = -10

ENT.TurretYawPoseParameterName = "turret_yaw"
ENT.TurretYawMul = 1
ENT.TurretYawOffset = 180

function ENT:TurretInRange()
	local ID = self:LookupAttachment( "muzzle_1" )

	local Muzzle = self:GetAttachment( ID )

	if not Muzzle then return true end

	local Dir1 = Muzzle.Ang:Forward()
	local Dir2 = self:GetAimVector() 

	return self:AngleBetweenNormal( Dir1, Dir2 ) < 10
end

if CLIENT then
	function ENT:UpdatePoseParameters( steer, speed_kmh, engine_rpm, throttle, brake, handbrake, clutch, gear, temperature, fuel, oil, ammeter )
		self:SetPoseParameter( "vehicle_steer", steer )
		self:CalcTurret()
	end
end
