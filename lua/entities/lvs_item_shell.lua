AddCSLuaFile()

ENT.Type            = "anim"

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )
		if not tr.Hit then return end

		local ent = ents.Create( ClassName )
		ent:SetPos( tr.HitPos + tr.HitNormal * 5 )
		ent:Spawn()
		ent:Activate()

		return ent
	end

	ENT.LifeTime = 30

	function ENT:Initialize()	
		self:SetModel( "models/props_debris/shellcasing_single1.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:PhysWake()
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self:SetRenderMode( RENDERMODE_TRANSALPHA )

		self.DieTime = CurTime() + self.LifeTime

		timer.Simple( self.LifeTime - 0.5, function()
			if not IsValid( self ) then return end

			self:SetRenderFX( kRenderFxFadeFast  ) 
		end)
	end

	function ENT:Think()
		if self.DieTime < CurTime() then
			self:Remove()
		end

		self:NextThink( CurTime() + 1 )

		return true
	end

	function ENT:PhysicsCollide( data, physobj )
		if data.Speed > 30 and data.DeltaTime > 0.2 then
			self:EmitSound( "lvs/vehicles/pak40/shell_impact"..math.random(1,2)..".wav" )
		end
	end

	return
end

function ENT:Draw()
	self:DrawModel()
end

local SmokeMat = {
	"particle/smokesprites_0001",
	"particle/smokesprites_0002",
	"particle/smokesprites_0003",
	"particle/smokesprites_0004",
	"particle/smokesprites_0005",
	"particle/smokesprites_0006",
	"particle/smokesprites_0007",
	"particle/smokesprites_0008",
	"particle/smokesprites_0009",
	"particle/smokesprites_0010",
	"particle/smokesprites_0011",
	"particle/smokesprites_0012",
	"particle/smokesprites_0013",
	"particle/smokesprites_0014",
	"particle/smokesprites_0015",
	"particle/smokesprites_0016"
}

function ENT:Initialize()
	self.emitter = ParticleEmitter( self:GetPos(), false )
end

function ENT:OnRemove()
	if not IsValid( self.emitter ) then return end

	self.emitter:Finish()
end

function ENT:Think()
	self:SetNextClientThink( CurTime() + 0.05 )

	local pos  = self:LocalToWorld( Vector(0,15,0) )

	if not self.emitter then return true end

	local VecCol = (render.GetLightColor( pos ) * 0.8 + Vector(0.2,0.2,0.2)) * 255

	for i = 0,2 do
		local particle = self.emitter:Add( SmokeMat[math.random(1,#SmokeMat)], pos )

		if not particle then continue end

		particle:SetVelocity( -self:GetRight() * 50 )
		particle:SetDieTime( 0.5 )
		particle:SetAirResistance( 250 ) 
		particle:SetStartAlpha( 10 )
		particle:SetStartSize( 0 )
		particle:SetEndSize( 40 )
		particle:SetRollDelta( math.Rand(-1,1) * 5 )
		particle:SetColor( math.min( VecCol.r, 255 ), math.min( VecCol.g, 255 ), math.min( VecCol.b, 255 ) )
		particle:SetCollide( true )
		particle:SetGravity( Vector(0,0,60) )
		particle:SetBounce( 1 )
	end

	return true
end
