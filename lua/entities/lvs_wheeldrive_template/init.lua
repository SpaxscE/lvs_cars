AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

--[[
ENT.WaterLevelPreventStart = 1 -- at this water level engine can not start
ENT.WaterLevelAutoStop = 2 -- at this water level (on collision) the engine will stop
ENT.WaterLevelDestroyAI = 2 -- at this water level (on collision) the AI will self destruct
]]

-- use this instead of ENT:Initialize()
function ENT:OnSpawn( PObj )
	--[[ basics ]]
	self:AddDriverSeat( Vector(-10,0,-15), Angle(0,-90,0) ) -- self:AddDriverSeat( Position,  Angle ) -- add a driver seat (max 1)
	-- Pod.ExitPos = Vector(0,0,100) -- change exit position
	-- Pod.HidePlayer = true -- should the player in this pod be invisible?

	-- local Pod = self:AddPassengerSeat( Position, Angle ) -- add a passenger seat (no limit)
	-- Pod.ExitPos = Vector(0,0,100) -- change exit position
	-- Pod.HidePlayer = true -- should the player in this pod be invisible?


	--[[ engine sound / effects ]]
	self:AddEngine( Vector(0,0,0) ) -- add a engine. This is used for sounds and effects and is required to get accurate RPM for the gauges.

	
	--[[ fuel system ]]
	-- self:AddFuelTank( pos, ang, tanksize, fueltype, mins, maxs ) -- adds a fuel tank.
	--[[
	 fueltypes:
		LVS.FUELTYPE_PETROL
		LVS.FUELTYPE_DIESEL
		LVS.FUELTYPE_ELECTRIC
	
	tanksize is how many seconds@fullthrottle you can drive. Not in liter.
	]]
	--Example:
	self:AddFuelTank( Vector(0,0,0), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL )


	--[[ damage system ]]
	--[[
	-- The fuel tank internally registers a critical hitpoint that catches the vehicle on fire when damaged. You can use this same system to create your own damage behaviors like this:
	self:AddDS( {
		pos = Vector(0,0,0),
		ang = Angle(0,0,0),
		mins = Vector(-40,-20,-30),
		maxs =  Vector(40,20,30),
		Callback = function( tbl, ent, dmginfo )
			--dmginfo:ScaleDamage( 15 ) -- this would scale damage *15 when this critical hitpoint has been hit
		end
	} )

	-- you can also add armor spots using this method. If the bullet trace hits this box first, it will not hit the critical hit point:
	self:AddDSArmor( {
		pos = Vector(-70,0,35),
		ang = Angle(0,0,0),
		mins = Vector(-10,-40,-30),
		maxs =  Vector(10,40,30),
		Callback = function( tbl, ent, dmginfo )
			-- armor also has a callback. You can set damage to 0 here for example:
			dmginfo:ScaleDamage( 0 )
		end
	} )

	NOTE: !!DS parts are inactive while the vehicle has shield!!



	-- in addition to DS-parts LVS-Cars has a inbuild Armor system:

	self:AddArmor( pos, ang, mins, maxs, health, num_force_ignore )

	-- num_force_ignore is the bullet force. Value here gets added to general immunity variable ENT.DSArmorIgnoreForce (see shared.lua)
	]]



	--[[ sound emitters ]]
	-- self.SoundEmitter = self:AddSoundEmitter( Position, string_path_exterior_sound, string_path_interior_sound ) -- add a sound emitter
	-- self.SoundEmitter:SetSoundLevel( 95 ) -- set sound level (95 is good for weapons)

	-- self.SoundEmitter:Play() -- start looping sound (use this in weapon start attack for example)
	-- self.SoundEmitter:Stop() -- stop looping sound (use this in weapon stop attack for example)

	-- self.SoundEmitter:PlayOnce( pitch, volume ) -- or play a non-looped sound in weapon attack (do not use looped sound files with this, they will never stop)


	--[[ items ]]
	--self:AddTurboCharger() -- equip a turbo charger?
	--self:AddSuperCharger() -- equip a super charger?


	--[[ wheels ]]
	--[[
	-- add a wheel:
	local WheelEntity1 = self:AddWheel( {
		-- radius = 12,  -- (leave this commented-out to let the system figure this out by itself)
		-- width = 3, -- tire witdh used for skidmarks
		pos = Vector(0,0,0),
		mdl = "path/to/model.mdl",
		mdl_ang = Angle(0,0,0), -- use this to match model orientation with wheel rotation

		--camber = 0, -- camber alignment
		--caster = 0, -- caster alignment
		--toe = 0, -- toe alignment

		--hide = false, -- hide this wheel?
	} ),

	!!NOTE!!
	adding a wheel will not make the vehicle functional. It requires to be linked to an axle using self:DefineAxle()
	]]


	--[[ axles ]]
	--[[
	local Axle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0), -- angle which is considered "forward" with this axle. Use this to fix misaligned body props.

			SteerType = STEER_TYPE,
			-- STEER_TYPE:
			--	LVS.WHEEL_STEER_NONE -- non steering wheel
			--	LVS.WHEEL_STEER_FRONT -- a wheel that turns left when left key is pressed
			--	LVS.WHEEL_STEER_REAR -- ..turns right when left key is pressed

			SteerAngle = 30, -- max steer angle, unused in steer type LVS.WHEEL_STEER_NONE

			TorqueFactor = 0.3, -- TorqueFactor is how much torque is applied to this axle. 1 = all power, 0 = no power. Ideally all Axis combined equal 1.
			--So if you make front wheels have  TorqueFactor 0.3 you set rear axle to 0.7
			--If Front Axle 0 set Rear Axle 1 ect.. you get the idea

			BrakeFactor = 1, -- how strong the brakes on this axle are. Just leave it at 1

			--UseHandbrake = true, -- is this axle using the handbrake?
		},

		Wheels = {WheelEntity1, WheelEntity2, ... ect }, -- link wheels to this axle. Can be any amount in any order

		Suspension = {
			Height = 6, -- suspension height. Ideally less than MaxTravel so the suspension doesnt always bump into its limiter. If it sags into the limiter you need more SpringConstant
			MaxTravel = 7, -- limits the suspension travel.
			ControlArmLength = 25, -- changes the size of the control arm. (changes the arc in which the axle is rotating)
			SpringConstant = 20000, -- the strength of the spring. Max value is 50000 everything above has no effect. This is the reason you should NOT use realistic mass but instead change INERTIA ONLY to simulate heavier vehicles.
			SpringDamping = 2000, -- damping of the spring, same as what you set in your elastic tool.
			SpringRelativeDamping = 2000, -- relative damping of the spring, same as what you set in your elastic tool. If you dont know what it does just set it to the same as SpringDamping
		},
	} )
	]]

	-- example:
	local WheelModel = "models/props_vehicles/tire001c_car.mdl"

	local WheelFrontLeft = self:AddWheel( { pos = Vector(60,30,-15), mdl = WheelModel } )
	local WheelFrontRight = self:AddWheel( { pos = Vector(60,-30,-15), mdl = WheelModel } )

	local WheelRearLeft = self:AddWheel( {pos = Vector(-60,30,-15), mdl = WheelModel} )
	local WheelRearRight = self:AddWheel( {pos = Vector(-60,-30,-15), mdl = WheelModel} )

	local SuspensionSettings = {
		Height = 6,
		MaxTravel = 7,
		ControlArmLength = 25,
		SpringConstant = 20000,
		SpringDamping = 2000,
		SpringRelativeDamping = 2000,
	}

	local FrontAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_FRONT,
			SteerAngle = 30,
			TorqueFactor = 0.3,
			BrakeFactor = 1,
		},
		Wheels = { WheelFrontLeft, WheelFrontRight },
		Suspension = SuspensionSettings,
	} )

	local RearAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 0.7,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = { WheelRearLeft, WheelRearRight },
		Suspension = SuspensionSettings,
	} )

	-- example 2 (rear axle only). If this looks cleaner to you:
	--[[
	local RearAxle = self:DefineAxle( {
		Axle = {
			ForwardAngle = Angle(0,0,0),
			SteerType = LVS.WHEEL_STEER_NONE,
			TorqueFactor = 0.7,
			BrakeFactor = 1,
			UseHandbrake = true,
		},
		Wheels = {
			self:AddWheel( {
				pos = Vector(-60,30,-15),
				mdl = "models/props_vehicles/tire001c_car.mdl",
				mdl_ang = Angle(0,0,0),
			} ),

			self:AddWheel( {
				pos = Vector(-60,-30,-15),
				mdl = "models/props_vehicles/tire001c_car.mdl",
				mdl_ang = Angle(0,0,0),
			} ),
		},
		Suspension = {
			Height = 6,
			MaxTravel = 7,
			ControlArmLength = 25,
			SpringConstant = 20000,
			SpringDamping = 2000,
			SpringRelativeDamping = 2000,
		},
	)
	]]
end

--[[
function ENT:OnEngineActiveChanged( Active )
	-- called when engine is activated/deactived

	if Active then -- if engine is active
		self:EmitSound( "lvs/vehicles/kuebelwagen/engine_start.wav" ) -- play engine start sound

	else -- otherwise...
		self:EmitSound( "lvs/vehicles/kuebelwagen/engine_stop.wav" ) -- play engine stop sound
	end
end

function ENT:OnSuperCharged( enabled )
	-- called when supercharger is equipped/unequipped
end

function ENT:OnTurboCharged( enabled )
	-- called when turbocharger is equipped/unequipped
end
]]