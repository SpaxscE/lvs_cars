
include("entities/lvs_tank_wheeldrive/modules/sh_turret.lua")

ENT.TurretAimRate = 15

ENT.TurretRotationSound = "common/null.wav"

ENT.TurretPitchPoseParameterName = "cannon_pitch"
ENT.TurretPitchMin = -10
ENT.TurretPitchMax = 6
ENT.TurretPitchMul = -0.75
ENT.TurretPitchOffset = -2

ENT.TurretYawPoseParameterName = "cannon_yaw"
ENT.TurretYawMin = -10
ENT.TurretYawMax = 10
ENT.TurretYawMul = -1
ENT.TurretYawOffset = 0