
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

	if not IsValid( Ent ) then return end

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
			particle:SetColor( 60, 60, 60 )
			particle:SetGravity( Vector( 0, 0, 600 ) )
			particle:SetCollide( true )
			particle:SetBounce( 0 )
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
