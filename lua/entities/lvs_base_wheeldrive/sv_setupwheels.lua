
function ENT:SetupWheels()
	local WheelModel = "models/sprops/trans/wheel_a/t_wheel25.mdl"

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT, --LVS.WHEEL_STEER_REAR   LVS.WHEEL_STEER_NONE
			SteerAngle = 35,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(50.814,-29,-2),

				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),

				camber = -1,
				caster = 1,
				toe = 1,
			} ),

			self:AddWheel( {
				pos = Vector(50.814,29,-2),

				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),

				camber = 1,
				caster = 1,
				toe = -1,
			} ),
		},
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )

	local RearAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-50.814,-29,-2),

				mdl = WheelModel,
				mdl_ang = Angle(0,-90,0),

				camber = -1,
				caster = 0,
				toe = 0,
			} ),

			self:AddWheel( {
				pos = Vector(-50.814,29,-2),

				mdl = WheelModel,
				mdl_ang = Angle(0,90,0),

				camber = 1,
				caster = 0,
				toe = 0,
			} ),
		},
		Suspension = {
			Height = 10,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	} )
end