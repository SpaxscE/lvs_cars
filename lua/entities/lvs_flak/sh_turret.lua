
include("entities/lvs_tank_wheeldrive/modules/sh_turret.lua")

ENT.TurretFakeBarrel = true
ENT.TurretFakeBarrelRotationCenter =  Vector(0,0,40)

ENT.TurretAimRate = 40

ENT.TurretRotationSound = "common/null.wav"

ENT.TurretPitchPoseParameterName = "cannon_pitch"
ENT.TurretPitchMin = -10
ENT.TurretPitchMax = 90
ENT.TurretPitchMul = 1
ENT.TurretPitchOffset = 0

ENT.TurretYawPoseParameterName = "cannon_yaw"
ENT.TurretYawMul = -1
ENT.TurretYawOffset = 180