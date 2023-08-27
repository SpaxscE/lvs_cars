AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "Turbo"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars - Items"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.DoNotDuplicate = true

ENT._LVS = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )
end

function ENT:GetBoost()
	if not self._smBoost then return 0 end

	return self._smBoost
end

if SERVER then
	function ENT:Initialize()	
		self:SetModel("models/diggercars/dodge_charger/turbo.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:PhysWake()
	end

	function ENT:Think()
		return false
	end

	function ENT:LinkTo( ent )
		if not IsValid( ent ) or not ent.LVS or not ent.AllowTurbo or IsValid( ent:GetTurbo() ) then return end

		local engine = ent:GetEngine()

		if not IsValid( engine ) then return end

		self:PhysicsDestroy()
		self:SetSolid( SOLID_NONE )
		self:SetMoveType( MOVETYPE_NONE )

		self:SetPos( engine:GetPos() )
		self:SetAngles( engine:LocalToWorldAngles( Angle(0,-90,0) ) )

		self:SetParent( engine )

		self:SetBase( ent )

		ent.EngineCurve = ent.EngineCurve + ent.TurboCurveAdd
		ent.EngineTorque = ent.EngineTorque + ent.TurboTorqueAdd

		ent:OnTurboCharged( true )

		ent:SetTurbo( self )
	end

	function ENT:PhysicsCollide( data )
		self:LinkTo( data.HitEntity )
	end

	function ENT:OnRemove()
		local base = self:GetBase()

		if not IsValid( base ) or base.ExplodedAlready then return end

		base.EngineCurve = base.EngineCurve - base.TurboCurveAdd
		base.EngineTorque = base.EngineTorque - base.TurboTorqueAdd

		base:OnTurboCharged( false )
	end

	return
end

function ENT:Initialize()
end

function ENT:OnEngineActiveChanged( Active, soundname )
	if Active then
		self:StartSounds( soundname )
	else
		self:StopSounds()
	end
end

function ENT:StartSounds( soundname )
	if self.snd then return end

	self.snd = CreateSound( self, soundname )
	self.snd:PlayEx(0,100)
end

function ENT:StopSounds()
	if not self.snd then return end

	self.snd:Stop()
	self.snd = nil
end

function ENT:HandleSounds( vehicle, engine )
	if not self.snd then return end

	if not self.TurboRPM then
		self.TurboRPM = 0
	end

	local FT = FrameTime()

	local throttle = engine:GetClutch() and 0 or vehicle:GetThrottle()

	local volume = math.Clamp(((self.TurboRPM - 300) / 300),0,1) * vehicle.TurboVolume
	local pitch = math.min(self.TurboRPM / 3,150)

	if throttle == 0 and (self.TurboRPM > 350) then
		if istable( vehicle.TurboBlowOff ) then
			self:EmitSound( vehicle.TurboBlowOff[ math.random( 1, #vehicle.TurboBlowOff ) ], 75, 100, volume * LVS.EngineVolume )
		else
			self:EmitSound( vehicle.TurboBlowOff, 75, 100, volume * LVS.EngineVolume )
		end
		self.TurboRPM = 0
	end

	local rpm = engine:GetRPM()
	local maxRPM = vehicle.EngineMaxRPM

	local ply = LocalPlayer()
	local doppler = vehicle:CalcDoppler( ply )

	self.TurboRPM = self.TurboRPM + math.Clamp(math.min(rpm / maxRPM,1) * 600 * (0.75 + 0.25 * throttle) - self.TurboRPM,-100 * FT,500 * FT)

	self._smBoost = self._smBoost and self._smBoost + (math.min( (self.TurboRPM or 0) / 400, 1 ) - self._smBoost) * FT * 10 or 0

	self.snd:ChangeVolume( volume * LVS.EngineVolume )
	self.snd:ChangePitch( pitch * doppler )
end

function ENT:Think()
	local vehicle = self:GetBase()

	if not IsValid( vehicle ) then return end

	local EngineActive = vehicle:GetEngineActive()

	if self._oldEnActive ~= EngineActive then
		self._oldEnActive = EngineActive

		self:OnEngineActiveChanged( EngineActive, vehicle.TurboSound )
	end

	if EngineActive then
		local engine = vehicle:GetEngine()

		if not IsValid( engine ) then return end

		self:HandleSounds( vehicle, engine )
	end
end

function ENT:OnRemove()
	self:StopSounds()
end

function ENT:Draw()
	if IsValid( self:GetBase() ) then return end

	self:DrawModel()
end
