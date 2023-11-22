AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_flyby.lua" )
AddCSLuaFile( "cl_camera.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_optics.lua" )
AddCSLuaFile( "cl_tiresounds.lua" )
AddCSLuaFile( "cl_scrolltexture.lua" )
AddCSLuaFile( "sh_animations.lua" )
AddCSLuaFile( "sh_camera_eyetrace.lua" )
include("shared.lua")
include("sh_animations.lua")
include("sv_controls.lua")
include("sv_controls_handbrake.lua")
include("sv_components.lua")
include("sv_ai.lua")
include("sv_riggedwheels.lua")
include("sv_wheelsystem.lua")
include("sv_damage.lua")
include("sv_pivotsteer.lua")
include("sv_duping.lua")
include("sh_camera_eyetrace.lua")

ENT.DriverActiveSound = "common/null.wav"
ENT.DriverInActiveSound = "common/null.wav"

DEFINE_BASECLASS( "lvs_base" )

local function SetMinimumAngularVelocityTo( new )
	local tbl = physenv.GetPerformanceSettings()

	if tbl.MaxAngularVelocity < new then
		local OldAngVel = tbl.MaxAngularVelocity

		tbl.MaxAngularVelocity = new
		physenv.SetPerformanceSettings( tbl )

		print("[LVS-Cars] Wheels require higher MaxAngularVelocity to perform correctly! Increasing! "..OldAngVel.." =>"..new)
	end
end

local function IsServerOK( class )

	if istable( LVS.VehicleBlackList ) then
		if LVS.VehicleBlackList[ class ] then return false end
	end

	if GetConVar( "gmod_physiterations" ):GetInt() ~= 4 then
		RunConsoleCommand("gmod_physiterations", "4")

		return false
	end

	return true
end

function ENT:TracksCreate( PObj )
end

local function DontDuplicatePaintSheme( ply, ent, data )
	ent.RandomColor = nil

	if not duplicator or not duplicator.StoreEntityModifier then return end

	duplicator.StoreEntityModifier( ent, "lvsVehiclePaintSheme", data )
end

if duplicator and duplicator.RegisterEntityModifier then
	duplicator.RegisterEntityModifier( "lvsVehiclePaintSheme", DontDuplicatePaintSheme )
end

function ENT:PostInitialize( PObj )

	self:TracksCreate( PObj )

	if not IsServerOK( self:GetClass() ) then
		self:Remove()
		print("[LVS] ERROR COULDN'T INITIALIZE VEHICLE!")
	end

	if istable( self.Lights ) then
		self:AddLights()
	end

	if istable( self.RandomColor ) then
		local data = self.RandomColor[ math.random( #self.RandomColor ) ]

		if IsColor( data ) then
			self:SetColor( data )
		else
			self:SetSkin( data.Skin or 0 )
			self:SetColor( data.Color or color_white )

			if istable( data.Wheels ) then
				self._WheelSkin = data.Wheels.Skin or 0
				self._WheelColor = data.Wheels.Color or color_white
			end

			if istable( data.BodyGroups ) then
				for id, subgroup in pairs( data.BodyGroups ) do
					self:SetBodygroup( id, subgroup )
				end
			end
		end

		DontDuplicatePaintSheme( NULL, self, {} )
	end

	BaseClass.PostInitialize( self, PObj )

	if isstring( self.HornSound ) and isvector( self.HornPos ) then
		if IsValid( self.HornSND ) then self.HornSND:Remove() end

		self.HornSND = self:AddSoundEmitter( self.HornPos, self.HornSound, self.HornSoundInterior )
		self.HornSND:SetSoundLevel( 75 )
		self.HornSND:SetDoppler( true )
	end

	PObj:SetMass( self.PhysicsMass * self.PhysicsWeightScale )
	PObj:EnableDrag( false )
	PObj:SetInertia( self.PhysicsInertia * self.PhysicsWeightScale )

	SetMinimumAngularVelocityTo( 24000 )

	self:EnableHandbrake()
end

function ENT:StartEngine()
	for _, wheel in pairs( self:GetWheels() ) do
		if not IsValid( wheel ) then continue end

		wheel:PhysWake()
	end

	BaseClass.StartEngine( self )
end

function ENT:AlignView( ply )
	if not IsValid( ply ) then return end

	timer.Simple( 0, function()
		if not IsValid( ply ) or not IsValid( self ) then return end

		local Ang = Angle(0,90,0)

		local pod = ply:GetVehicle()
		local MouseAim = ply:lvsMouseAim() and self:GetDriver() == ply

		if MouseAim and IsValid( pod ) then
			Ang = pod:LocalToWorldAngles( Angle(0,90,0) )
			Ang.r = 0
		end

		ply:SetEyeAngles( Ang )
	end)
end

function ENT:PhysicsSimulate( phys, deltatime )

	if self:GetEngineActive() then phys:Wake() end

	local ent = phys:GetEntity()

	if ent == self then
		local Vel = 0

		for _, wheel in pairs( self:GetWheels() ) do
			if wheel:GetTorqueFactor() <= 0 then continue end

			local wheelVel = wheel:RPMToVel( math.abs( wheel:GetRPM() or 0 ) )

			if wheelVel > Vel then
				Vel = wheelVel
			end
		end

		self:SetWheelVelocity( Vel )

		if not self:StabilityAssist() or not self:WheelsOnGround() then return vector_origin, vector_origin, SIM_NOTHING end

		local ForceAngle = Vector(0,0, math.deg( -phys:GetAngleVelocity().z ) * math.min( phys:GetVelocity():Length() / self.PhysicsDampingSpeed, 1 ) * self.ForceAngleMultiplier )

		return ForceAngle, vector_origin, SIM_GLOBAL_ACCELERATION
	end

	return self:SimulateRotatingWheel( ent, phys, deltatime )
end

function ENT:SimulateRotatingWheel( ent, phys, deltatime )
	local T = CurTime()
	local tickdelta = engine.TickInterval()

	if not self:GetEngineActive() then
		if (ent._lvsNextThink or 0) > T then
			return vector_origin, vector_origin, SIM_NOTHING
		else
			ent._lvsNextThink = T + 0.05
		end
	end

	if not self:AlignWheel( ent ) or ent:IsHandbrakeActive() then if ent.SetRPM then ent:SetRPM( 0 ) end return vector_origin, vector_origin, SIM_NOTHING end

	if self:IsDestroyed() then self:EnableHandbrake() return vector_origin, vector_origin, SIM_NOTHING end

	if (ent._lvsNextSimulate or 0) > T then return vector_origin, vector_origin, SIM_NOTHING end

	local RotationAxis = ent:GetRotationAxis()

	local curRPM = self:VectorSplitNormal( RotationAxis,  phys:GetAngleVelocity() ) / 6

	local forceMul = 1

	local Throttle = self:GetThrottle()

	if tickdelta < 1 / 30 and not (Throttle > 0 and math.abs( curRPM ) < 50) then
		local deltatimeNew = 1 / 15

		ent._lvsNextSimulate = T + deltatimeNew - tickdelta * 0.5

		local Tick1 = 1 / deltatime
		local Tick2 = 1 / deltatimeNew

		forceMul = Tick1 / Tick2
	end

	ent:SetRPM( curRPM )

	local ForceAngle = vector_origin

	local TorqueFactor = ent:GetTorqueFactor()

	local IsBraking = self:GetBrake() > 0
	local IsBrakingWheel = (TorqueFactor * Throttle) <= 0.99

	if IsBraking and IsBrakingWheel then
		if ent:IsRotationLocked() then
			ForceAngle = vector_origin
		else
			local ForwardVel = self:VectorSplitNormal( ent:GetDirectionAngle():Forward(),  phys:GetVelocity() )

			local targetRPM = ent:VelToRPM( ForwardVel ) * 0.5

			if math.abs( curRPM ) < self.WheelBrakeLockupRPM then
				ent:LockRotation()
			else
				if (ForwardVel > 0 and targetRPM > 0) or (ForwardVel < 0 and targetRPM < 0) then
					ForceAngle = RotationAxis * math.Clamp( (targetRPM - curRPM) / 100,-1,1) * math.deg( self.WheelBrakeForce ) * ent:GetBrakeFactor() * self:GetBrake()
				end
			end
		end
	else
		if self.WheelBrakeAutoLockup then
			if math.abs( curRPM ) < self.WheelBrakeLockupRPM and Throttle == 0 then
				ent:LockRotation()
			else
				if ent:IsRotationLocked() then
					ent:ReleaseRotation()
				end
			end
		else
			if ent:IsRotationLocked() then
				ent:ReleaseRotation()
			end
		end

		if TorqueFactor > 0 and Throttle > 0 then
			local targetVelocity = self:GetTargetVelocity()

			local targetRPM = ent:VelToRPM( targetVelocity )

			local targetRPMabs = math.abs( targetRPM )

			local powerRPM = targetRPMabs * self.EngineCurve

			local powerCurve = (powerRPM + math.max( targetRPMabs - powerRPM,0) - math.max(math.abs(curRPM) - powerRPM,0)) / targetRPMabs * self:Sign( targetRPM - curRPM )

			local Torque = powerCurve * math.deg( self.EngineTorque ) * TorqueFactor * Throttle

			local BoostRPM = 0

			if self:GetReverse() then
				BoostRPM = ent:VelToRPM( self.MaxVelocityReverse / self.TransGearsReverse ) * 0.5
			else
				BoostRPM = ent:VelToRPM( self.MaxVelocity / self.TransGears ) * 0.5
			end

			local TorqueBoost = 2 - (math.min( math.max( math.abs( curRPM ) - BoostRPM, 0 ), BoostRPM) / BoostRPM)

			local curVelocity = self:VectorSplitNormal( ent:GetDirectionAngle():Forward(),  phys:GetVelocity() )

			if targetVelocity >= 0 then
				if curVelocity < targetVelocity then
					ForceAngle = RotationAxis * Torque * TorqueBoost
				end
			else
				if curVelocity > targetVelocity then
					ForceAngle = RotationAxis * Torque * TorqueBoost
				end
			end

			if self:PivotSteer() then
				local RotationDirection = ent:GetWheelType() * self:GetPivotSteer()
	
				if self.PivotSteerByBrake and RotationDirection < 0 then
					ent:LockRotation( true )

					return vector_origin, vector_origin, SIM_NOTHING
				end

				powerCurve = math.Clamp((self.PivotSteerWheelRPM * RotationDirection - curRPM) / self.PivotSteerWheelRPM,-1,1)

				Torque = powerCurve * math.deg( self.EngineTorque ) * TorqueFactor * Throttle * 2

				ForceAngle = RotationAxis * Torque
			end
		end
	end

	if not self:StabilityAssist() or not self:WheelsOnGround() then return ForceAngle * forceMul, vector_origin, SIM_GLOBAL_ACCELERATION end

	local Vel = phys:GetVelocity()

	local ForwardAngle = ent:GetDirectionAngle()

	local Forward = ForwardAngle:Forward()
	local Right = ForwardAngle:Right()

	local Fy = self:VectorSplitNormal( Right, Vel )
	local Fx = self:VectorSplitNormal( Forward, Vel )

	if TorqueFactor >= 1 then
		local VelX = math.abs( Fx )
		local VelY = math.abs( Fy )

		if VelY > VelX * 0.1 then
			if VelX > self.FastSteerActiveVelocity then
				if VelY < VelX * 0.6 then
					return ForceAngle * forceMul, vector_origin, SIM_GLOBAL_ACCELERATION
				end
			else
				return ForceAngle * forceMul, vector_origin, SIM_GLOBAL_ACCELERATION
			end
		end
	end

	if IsBraking and not IsBrakingWheel then
		return ForceAngle * forceMul, vector_origin, SIM_GLOBAL_ACCELERATION
	end

	local ForceLinear = -self:GetUp() * self.WheelDownForce * TorqueFactor - Right * math.Clamp(Fy * 5 * math.min( math.abs( Fx ) / 500, 1 ),-self.WheelSideForce,self.WheelSideForce) * self.ForceLinearMultiplier

	return ForceAngle * forceMul, ForceLinear * forceMul, SIM_GLOBAL_ACCELERATION
end

function ENT:SteerTo( TargetValue, MaxSteer )
	local Cur = self:GetSteer() / MaxSteer
	
	local Diff = TargetValue - Cur

	local Returning = (Diff > 0 and Cur < 0) or (Diff < 0 and Cur > 0)

	local Rate = FrameTime() * (Returning and self.SteerReturnSpeed or self.SteerSpeed)

	local New = (Cur + math.Clamp(Diff,-Rate,Rate))

	self:SetSteer( New * MaxSteer )

	if New == 0 or self:GetEngineActive() then return end

	for _, wheel in pairs( self:GetWheels() ) do
		if not IsValid( wheel ) then continue end

		wheel:PhysWake()
	end
end

function ENT:OnDriverChanged( Old, New, VehicleIsActive )
	if VehicleIsActive then return end

	self:SetThrottle( 0 )

	if self:GetBrake() > 0 then
		self:SetBrake( 0 )
		self:EnableHandbrake()
		self:StopEngine()
		self:SetTurnMode( 0 )

		local LightsHandler = self:GetLightsHandler()

		if IsValid( LightsHandler ) then
			LightsHandler:SetActive( false )
			LightsHandler:SetHighActive( false )
			LightsHandler:SetFogActive( false )
		end
	end

	self:SetReverse( false )

	if not self.HornSound or not IsValid( self.HornSND ) then return end

	self.HornSND:Stop()
end

function ENT:OnRefueled()
	local FuelTank = self:GetFuelTank()

	if not IsValid( FuelTank ) then return end

	FuelTank:EmitSound( "vehicles/jetski/jetski_no_gas_start.wav" )
end

function ENT:OnMaintenance()
	local FuelTank = self:GetFuelTank()

	if not IsValid( FuelTank ) then return end

	FuelTank:ExtinguishAndRepair()
end

function ENT:OnSuperCharged( enable )
end

function ENT:OnTurboCharged( enable )
end

function ENT:ApproachTargetAngle( TargetAngle )
	local pod = self:GetDriverSeat()

	if not IsValid( pod ) then return end

	local ang = self:GetAngles()
	ang.y = pod:GetAngles().y + 90

	local Forward = ang:Right()
	local View = pod:WorldToLocalAngles( TargetAngle ):Forward()

	local Reversed = false
	if self:AngleBetweenNormal( View, ang:Forward() ) < 90 then
		Reversed = self:GetReverse()
	end

	local LocalAngSteer = (self:AngleBetweenNormal( View, ang:Right() ) - 90) / self.MouseSteerAngle

	local Steer = (math.min( math.abs( LocalAngSteer ), 1 ) ^ self.MouseSteerExponent * self:Sign( LocalAngSteer ))

	self:SteerTo( Reversed and Steer or -Steer, self:GetMaxSteerAngle() )
end

function ENT:OnCoupleChanged( targetVehicle, targetHitch, active )
end

function ENT:OnStartDrag( caller, activator )
end

function ENT:OnStopDrag( caller, activator )
end