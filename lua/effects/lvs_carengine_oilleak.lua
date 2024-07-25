
local DecalMat = Material( util.DecalMaterial( "BeerSplash" ) )

function EFFECT:Init( data )
	local Pos = data:GetOrigin()
	local Ent = data:GetEntity()

	if not IsValid( Ent ) then return end

	local emitter = Ent:GetParticleEmitter( Pos )

	if not IsValid( emitter ) then return end

	local oildrip = emitter:Add( "effects/slime1", Pos )

	if not oildrip then return end

	oildrip:SetVelocity( vector_origin )
	oildrip:SetGravity( Vector( 0, 0, -600 ) )
	oildrip:SetDieTime( 2 )
	oildrip:SetAirResistance( 0 ) 
	oildrip:SetStartAlpha( 255 )
	oildrip:SetStartSize( 0.5 )
	oildrip:SetEndSize( 0.5 )
	oildrip:SetRoll( math.Rand( -1, 1 ) )
	oildrip:SetColor( 240,200,0,255 )
	oildrip:SetCollide( true )

	oildrip:SetCollideCallback( function( part, hitpos, hitnormal )
		local effectdata = EffectData() 
			effectdata:SetOrigin( hitpos ) 
			effectdata:SetNormal( hitnormal * 2 ) 
			effectdata:SetMagnitude( 0.1 ) 
			effectdata:SetScale( 0.1 ) 
			effectdata:SetRadius( 0.1 ) 
		util.Effect( "StriderBlood", effectdata )

		sound.Play( "ambient/water/water_spray"..math.random(1,3)..".wav", hitpos, 55, math.Rand(95,105), 0.5 )

		oildrip:SetDieTime( 0 )

		if IsValid( Ent ) then
			local trace = util.TraceLine( {
				start = hitpos + hitnormal * 5,
				endpos = hitpos - hitnormal * 5,
			} )

			if Ent._LastLeakPos and (Ent._LastLeakPos - trace.HitPos):Length() < 5 then
				if (Ent._LastLeakCount or 0) > 7 then return end

				Ent._LastLeakCount = (Ent._LastLeakCount or 0) + 1
			else
				Ent._LastLeakCount = nil
			end

			local Scale = 1 + (Ent._LastLeakCount or 0) * 0.2

			local ScaleX = 0.5 * Scale
			local ScaleY = 0.4 * Scale

			util.DecalEx( DecalMat, trace.Entity, trace.HitPos + trace.HitNormal, trace.HitNormal, Color(255,255,255,10), ScaleX, ScaleY )

			Ent._LastLeakPos = trace.HitPos
		end
	end )
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
