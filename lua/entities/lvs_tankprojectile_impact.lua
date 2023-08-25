AddCSLuaFile()

ENT.Type            = "anim"

ENT.RenderGroup = RENDERGROUP_BOTH 

if SERVER then
	function ENT:Initialize()
		self:Remove()
	end

	return
end

ENT.LifeTime = 15
ENT.GlowMat1 = Material( "particle/particle_ring_wave_8" )
ENT.GlowMat2 = Material( "sprites/light_glow02_add" )
ENT.DecalMat = Material( "particle/particle_noisesphere" )
ENT.MatSmoke = {
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

function ENT:SetLifeTime( n )
	self.LifeTime = n
	self.DieTime = CurTime() + n
end

function ENT:Initialize()
	self.DieTime = CurTime() + self.LifeTime
	self.RandomAng = math.random(0,360)

	local Pos = self:GetPos()
	local Dir = self:GetUp()

	self.emitter = ParticleEmitter( Pos, false )
end

function ENT:Smoke()
	if not self.emitter then return end

	if (self.NextFX or 0) < CurTime() then
		self.NextFX = CurTime() + 0.2

		local particle = self.emitter:Add( self.MatSmoke[math.random(1,#self.MatSmoke)], self:GetPos() )

		if particle then
			particle:SetVelocity( self:GetUp() * 60 + VectorRand() * 30 )
			particle:SetDieTime( math.Rand(1.5,2) )
			particle:SetAirResistance( 100 ) 
			particle:SetStartAlpha( 30 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 0 )
			particle:SetEndSize( 60 )
			particle:SetRollDelta( math.Rand( -1, 1 ) )
			particle:SetColor( 50,50,50 )
			particle:SetGravity( Vector( 0, 0, 200 ) )
			particle:SetCollide( false )
		end
	end
end

function ENT:Think()
	if not IsValid( self:GetParent() ) then self:Remove() return end

	if (self.DieTime or 0) > CurTime() then
		self:Smoke()

		return
	end

	self:Remove()
end

function ENT:OnRemove()
	if not self.emitter then return end

	self.emitter:Finish()
end

function ENT:Draw()
	local Timed = 1 - (self.DieTime - CurTime()) / self.LifeTime
	local Scale = math.max(math.min(2 - Timed * 2,1),0)

	cam.Start3D2D( self:GetPos() + self:GetAngles():Up(), self:GetAngles(), 1 )
		surface.SetDrawColor( 255, 93 + 50 * Scale, 50 * Scale, 200 * Scale )

		surface.SetMaterial( self.GlowMat1 )
		surface.DrawTexturedRectRotated( 0, 0, 8 , 8 , self.RandomAng )

		surface.SetMaterial( self.GlowMat2 )
		surface.DrawTexturedRectRotated( 0, 0, 16 , 16 , self.RandomAng )

		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.SetMaterial( self.DecalMat )
		surface.DrawTexturedRectRotated( 0, 0, 16 , 16 , self.RandomAng )
	cam.End3D2D()
end

function ENT:DrawTranslucent()
	self:Draw()
end
