AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "Jerry Can (Petrol)"
ENT.Author = "Luna"
ENT.Category = "[LVS] - Cars - Items"

ENT.Spawnable		= true
ENT.AdminOnly		= false

ENT.AutomaticFrameAdvance = true

ENT.FuelAmount = 120 -- seconds
ENT.FuelType = LVS.FUELTYPE_PETROL

ENT.lvsGasStationFillSpeed = 0.05
ENT.lvsGasStationRefillMe = true

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Active" )
	self:NetworkVar( "Float", 0, "Fuel" )

	if SERVER then
		self:SetFuel( 1 )
	end
end

function ENT:IsOpen()
	return self:GetActive()
end

function ENT:IsUpright()
	local Up = self:GetUp()

	return Up.z > 0.5
end

function ENT:GetFuelType()
	return self.FuelType
end

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )
		if not tr.Hit then return end

		local ent = ents.Create( ClassName )
		ent:SetPos( tr.HitPos + tr.HitNormal )
		ent:Spawn()
		ent:Activate()

		return ent
	end

	function ENT:OnTakeDamage( dmginfo )
	end

	function ENT:Initialize()	
		self:SetModel( "models/misc/fuel_can.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end

	function ENT:Refuel( entity )
		if self:GetFuel() <= 0 then return end

		if not IsValid( entity ) then return end

		if not entity.LVS or not entity.GetFuelTank then return end

		local FuelTank = entity:GetFuelTank()

		if not IsValid( FuelTank ) then return end

		if FuelTank:GetFuelType() ~= self.FuelType then return end

		local FuelCap = FuelTank:GetDoorHandler()

		if IsValid( FuelCap ) and not FuelCap:IsOpen() then return end

		if FuelTank:GetFuel() ~= 1 then
			local Cur = FuelTank:GetFuel()
			local Need = 1 - Cur

			local Available = (1 / FuelTank:GetSize()) * self.FuelAmount * self:GetFuel()

			local Add = math.min( Available, Need )

			self:SetFuel( Available - Add )
			FuelTank:SetFuel( Cur + Add )

			entity:OnRefueled()
		end
	end

	function ENT:Use( ply )
		self:SetActive( not self:GetActive() )

		if self:GetActive() then
			self:PlayAnimation( "open" )

			self:EmitSound("buttons/lever7.wav")
		else
			self:PlayAnimation( "close" )
		end
	end

	function ENT:Think()
		if self:IsOpen() and not self:IsUpright() then
			self:SetFuel( math.max( self:GetFuel() - FrameTime() * 0.25, 0 ) )
		end

		self:NextThink( CurTime() )

		return true
	end

	function ENT:PhysicsCollide( data, physobj )
		if not self:IsOpen() then return end

		self:Refuel( data.HitEntity )
	end

	function ENT:PlayAnimation( animation, playbackrate )
		playbackrate = playbackrate or 1

		local sequence = self:LookupSequence( animation )

		self:ResetSequence( sequence )
		self:SetPlaybackRate( playbackrate )
		self:SetSequence( sequence )
	end

	function ENT:OnRefueled()
		self:EmitSound( "vehicles/jetski/jetski_no_gas_start.wav" )
	end

end

if CLIENT then
	ENT.FrameMat = Material( "lvs/3d2dmats/frame.png" )
	ENT.RefuelMat = Material( "lvs/3d2dmats/refuel.png" )

	function ENT:Draw()
		self:DrawModel()

		local ply = LocalPlayer()
		local Pos = self:GetPos()

		if (ply:GetPos() - Pos):LengthSqr() > 5000000 then return end

		local data = LVS.FUELTYPES[ self.FuelType ]
		local Text = data.name
		local IconColor = Color( data.color.x, data.color.y, data.color.z, 255 )

		for i = -1, 1, 2 do
			cam.Start3D2D( self:LocalToWorld( Vector(0,4 * i,0) ), self:LocalToWorldAngles( Angle(0,90 + 90 * i,90) ), 0.1 )
				surface.SetDrawColor( IconColor )

				surface.SetMaterial( self.FrameMat )
				surface.DrawTexturedRect( -50, -50, 100, 100 )

				surface.SetMaterial( self.RefuelMat )
				surface.DrawTexturedRect( -50, -50, 100, 100 )

				draw.SimpleText( Text, "LVS_FONT", 0, 75, IconColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

				draw.SimpleText( math.Round( self:GetFuel() * 100, 0 ).."%", "LVS_FONT", 0, 95, IconColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			cam.End3D2D()
		end
	end

	function ENT:OnRemove()
		self:StopPour()
	end

	function ENT:StartPour()
		if self.snd then return end

		self.snd =  CreateSound( self, "lvs/jerrycan_use.wav" )
		self.snd:PlayEx(0.5,80)
		self.snd:ChangePitch(120,3)
	end

	function ENT:StopPour()
		if not self.snd then return end

		self.snd:Stop()
		self.snd = nil
	end

	function ENT:DoEffect()
		local Up = self:GetUp()
		local Pos = self:LocalToWorld( Vector(7.19,-0.01,10.46) )

		local emitter = ParticleEmitter( Pos, false )
		local particle = emitter:Add( "effects/slime1", Pos )

		if particle then
			particle:SetVelocity( Up * math.abs( Up.z ) * 100 )
			particle:SetGravity( Vector( 0, 0, -600 ) )
			particle:SetDieTime( 2 )
			particle:SetAirResistance( 0 ) 
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( 1.5 )
			particle:SetEndSize( 1.5 )
			particle:SetRoll( math.Rand( -1, 1 ) )
			particle:SetColor( 240,200,0,255 )
			particle:SetCollide( true )

			particle:SetCollideCallback( function( part, hitpos, hitnormal )
				local effectdata = EffectData() 
					effectdata:SetOrigin( hitpos ) 
					effectdata:SetNormal( hitnormal * 2 ) 
					effectdata:SetMagnitude( 0.2 ) 
					effectdata:SetScale( 0.2 ) 
					effectdata:SetRadius( 0.2 ) 
				util.Effect( "StriderBlood", effectdata )

				sound.Play( "ambient/water/water_spray"..math.random(1,3)..".wav", hitpos, 55, math.Rand(95,105), 0.5 )

				particle:SetDieTime( 0 )

				if not IsValid( self ) then return false end

				if not self.LastPos then self.LastPos = hitpos end

				if (self.LastPos - hitpos):Length() < 10 then
					return
				end

				self.LastPos = hitpos

				util.Decal( "BeerSplash", hitpos + hitnormal * 2, hitpos - hitnormal * 2 )
			end )
		end

		emitter:Finish()
	end

	function ENT:Think()
		self:SetNextClientThink( CurTime() + 0.02 )

		if self:GetFuel() <= 0 then self:StopPour() return end

		local T = CurTime()

		if not self:IsOpen() or self:IsUpright() then

			self:StopPour()

			return true
		end

		self:StartPour()

		self:DoEffect()

		return true
	end
end