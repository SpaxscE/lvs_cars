
local Materials = {
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

function EFFECT:Init( data )
	local Pos = data:GetOrigin()
	local Ent = data:GetEntity()

	self.LifeTime = 0.6
	self.DieTime = CurTime() + self.LifeTime

	if not IsValid( Ent ) then return end

	self.Ent = Ent
	self.Pos = Ent:WorldToLocal( Pos + VectorRand() * 8 )
	self.RandomSize = math.Rand( 0.8, 1.6 )

	local emitter = Ent:GetParticleEmitter( Pos )

	if not IsValid( emitter ) then return end

	for i = 1, 8 do
		local particle = emitter:Add( Materials[ math.random(1, #Materials ) ], Pos )

		local Dir = Angle(0,math.Rand(-180,180),0):Forward()
		Dir.z = -0.5
		Dir:Normalize()

		if particle then
			particle:SetVelocity( Dir * 250 )
			particle:SetDieTime( 0.5 + i * 0.01 )
			particle:SetAirResistance( 125 ) 
			particle:SetStartAlpha( 100 )
			particle:SetStartSize( 20 )
			particle:SetEndSize( 40 )
			particle:SetRoll( math.Rand(-1,1) * math.pi )
			particle:SetRollDelta( math.Rand(-1,1) * 3 )
			particle:SetColor( 0, 0, 0 )
			particle:SetGravity( Vector( 0, 0, 600 ) )
			particle:SetCollide( true )
			particle:SetBounce( 0 )
		end
	end
end

function EFFECT:Think()
	if not IsValid( self.Ent ) then return false end

	if self.DieTime < CurTime() then return false end

	self:SetPos( self.Ent:LocalToWorld( self.Pos ) )

	return true
end

EFFECT.GlowMat = Material( "sprites/light_glow02_add" )
EFFECT.FireMat = {
	[1] = Material( "effects/lvs_base/flamelet1" ),
	[2] = Material( "effects/lvs_base/flamelet2" ),
	[3] = Material( "effects/lvs_base/flamelet3" ),
	[4] = Material( "effects/lvs_base/flamelet4" ),
	[5] = Material( "effects/lvs_base/flamelet5" ),
	[6] = Material( "effects/lvs_base/fire" ),
}

function EFFECT:Render()
	if not IsValid( self.Ent ) or not self.Pos then return end

	local Scale = (self.DieTime - CurTime()) / self.LifeTime

	local Pos = self.Ent:LocalToWorld( self.Pos )

	local InvScale = 1 - Scale

	render.SetMaterial( self.GlowMat )
	render.DrawSprite( Pos + Vector(0,0,InvScale ^ 2 * 10), 100 * InvScale, 100 * InvScale, Color( 255, 150, 75, 255) )

	local Num = #self.FireMat - math.Clamp(math.ceil( Scale * #self.FireMat ) - 1,0, #self.FireMat - 1)

	local Size = (10 + 25 * Scale) * self.RandomSize

	render.SetMaterial( self.FireMat[ Num ] )
	render.DrawSprite( Pos + Vector(0,0,InvScale ^ 2 * 25), Size, Size, Color( 255, 255, 255, 255) )
end
