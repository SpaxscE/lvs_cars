
EFFECT.DustMat = {
	"particle/particle_debris_01",
	"particle/particle_debris_02",
}

EFFECT.SparkSurface = {
	["chainlink"] = true,
	["canister"] = true,
	["metal_barrel"] = true,
	["metalvehicle"] = true,
	["metal"] = true,
	["metalgrate"] = true,
}

EFFECT.DustSurface = {
	["sand"] = true,
	["dirt"] = true,
	["grass"] = true,
	["antlionsand"] = true,
}

EFFECT.SmokeSurface = {
	["concrete"] = true,
	["tile"] = true,
	["plaster"] = true,
	["boulder"] = true,
	["plastic"] = true,
	["default"] = true,
	["glass"] = true,
}

function EFFECT:Init( data )
	local pos = data:GetOrigin()

	local bullet_dir = data:GetStart()
	local dir = data:GetNormal()

	local ent = data:GetEntity()
	local surface = data:GetSurfaceProp()
	local surfaceName = util.GetSurfacePropName( surface )

	local emitter = ParticleEmitter( pos, false )

	local VecCol = (render.GetLightColor( pos ) * 0.8 + Vector(0.17,0.15,0.1)) * 255

	local DieTime = math.Rand(0.8,1.4)

	if self.SparkSurface[ surfaceName ] then
		if IsValid( ent ) and ent.LVS then
			if (90 - math.deg( math.acos( math.Clamp( -dir:Dot( bullet_dir ) ,-1,1) ) )) > 10 then
				local effectdata = EffectData()
				effectdata:SetOrigin( pos )
				util.Effect( "cball_explode", effectdata, true, true )

				local Ax = math.acos( math.Clamp( dir:Dot( bullet_dir ) ,-1,1) )
				local Fx = math.cos( Ax )

				local effectdata = EffectData()
					effectdata:SetOrigin( pos )
					effectdata:SetNormal( (bullet_dir - dir * Fx * 2):GetNormalized() * 0.75 )
				util.Effect( "manhacksparks", effectdata, true, true )

				local effectdata = EffectData()
					effectdata:SetOrigin( pos )
					effectdata:SetNormal( -bullet_dir * 0.75 )
				util.Effect( "manhacksparks", effectdata, true, true )
			end
		else
			local effectdata = EffectData()
			effectdata:SetOrigin( pos )
			util.Effect( "cball_explode", effectdata, true, true )

			local effectdata = EffectData()
				effectdata:SetOrigin( pos )
				effectdata:SetNormal( dir )
			util.Effect( "manhacksparks", effectdata, true, true )

			local effectdata = EffectData()
				effectdata:SetOrigin( pos )
				effectdata:SetNormal( -bullet_dir )
			util.Effect( "manhacksparks", effectdata, true, true )
		end
	end

	if self.SmokeSurface[ surfaceName ] then
		local effectdata = EffectData()
		effectdata:SetOrigin( pos )
		util.Effect( "GlassImpact", effectdata, true, true )
	end

	if not self.DustSurface[ surfaceName ] then return end

	for i = 1, 10 do
		for n = 0,6 do
			local particle = emitter:Add( self.DustMat[ math.random(1,#self.DustMat) ] , pos )

			if not particle then continue end

			particle:SetVelocity( (dir * 50 * i + VectorRand() * 25) )
			particle:SetDieTime( (i / 8) * DieTime )
			particle:SetAirResistance( 10 ) 
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( 10 )
			particle:SetEndSize( 20 * i )
			particle:SetRollDelta( math.Rand(-1,1) )
			particle:SetColor( math.min( VecCol.r, 255 ), math.min( VecCol.g, 255 ), math.min( VecCol.b, 255 ) )
			particle:SetGravity( Vector(0,0,-600) )
			particle:SetCollide( false )
		end
	end

	--[[
	for i = 1,12 do
		local particle = emitter:Add( self.DustMat[ math.random(1,#self.DustMat) ] , pos )
		
		if particle then
			local ang = i * 30
			local X = math.cos( math.rad(ang) )
			local Y = math.sin( math.rad(ang) )

			local Vel = Vector(X,Y,0) * math.Rand(200,1600) + Vector(0,0,50)
			Vel:Rotate( dir:Angle() + Angle(90,0,0) )

			particle:SetVelocity( Vel * 0.5 )
			particle:SetDieTime( DieTime )
			particle:SetAirResistance( 500 ) 
			particle:SetStartAlpha( 100 )
			particle:SetStartSize( 20 )
			particle:SetEndSize( 100 )
			particle:SetRollDelta( math.Rand(-1,1) )
			particle:SetColor( math.min( VecCol.r, 255 ), math.min( VecCol.g, 255 ), math.min( VecCol.b, 255 ) )
			particle:SetGravity( Vector(0,0,30) )
			particle:SetCollide( true )
		end
	end
	]]

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
