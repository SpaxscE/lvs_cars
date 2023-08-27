AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "Jerry Can"
ENT.Author = "Luna"
ENT.Information = "Partly refills fuel tanks"
ENT.Category = "[LVS] - Cars - Items"

ENT.Spawnable		= true
ENT.AdminOnly		= false

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
		self:SetModel( "models/props_junk/metalgascan.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
	end

	function ENT:Refuel( entity )
		if self.MarkForRemove then return end

		if not IsValid( entity ) then return end

		if not entity.LVS or not entity.GetFuelTank then return end

		local FuelTank = entity:GetFuelTank()

		if not IsValid( FuelTank ) then return end

		local FuelCap = FuelTank:GetDoorHandler()

		if IsValid( FuelCap ) and not FuelCap:IsOpen() then return end

		if FuelTank:GetFuel() ~= 1 then
			self.MarkForRemove = true

			local Cur = FuelTank:GetFuel()
			local Add = (1 / FuelTank:GetSize()) * 120

			FuelTank:SetFuel( math.min( Cur + Add, 1 ) )

			if FuelTank:GetFuel() >= 1 then
				entity:OnRefueled()
			else
				if IsValid( FuelCap ) then
					FuelCap:EmitSound( "lvs/jerrycan_use.wav" )
				end
			end
		end
	end

	function ENT:Think()
		if self.MarkForRemove then self:Remove() return false end

		self:NextThink( CurTime() )

		return false
	end

	function ENT:PhysicsCollide( data, physobj )
		self:Refuel( data.HitEntity )
	end
end

if CLIENT then
	ENT.IconColor = Color( 255, 150, 0, 255 )
	ENT.FrameMat = Material( "lvs/3d2dmats/frame.png" )
	ENT.RefuelMat = Material( "lvs/3d2dmats/refuel.png" )

	function ENT:Draw()
		self:DrawModel()

		local Pos = self:GetPos()

		cam.Start3D2D( self:LocalToWorld( Vector(4,0,0) ), self:LocalToWorldAngles( Angle(0,90,90) ), 0.1 )
			surface.SetDrawColor( self.IconColor )

			surface.SetMaterial( self.FrameMat )
			surface.DrawTexturedRect( -50, -50, 100, 100 )

			surface.SetMaterial( self.RefuelMat )
			surface.DrawTexturedRect( -50, -50, 100, 100 )
		cam.End3D2D()

		cam.Start3D2D( self:LocalToWorld( Vector(-4,0,0) ), self:LocalToWorldAngles( Angle(0,-90,90) ), 0.1 )
			surface.SetDrawColor( self.IconColor )

			surface.SetMaterial( self.FrameMat )
			surface.DrawTexturedRect( -50, -50, 100, 100 )

			surface.SetMaterial( self.RefuelMat )
			surface.DrawTexturedRect( -50, -50, 100, 100 )
		cam.End3D2D()
	end

	function ENT:OnRemove()
	end
end