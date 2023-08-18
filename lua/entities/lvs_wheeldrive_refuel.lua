AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "Gas Pump"
ENT.Author = "Luna"
ENT.Information = "Refills Fuel Tanks"
ENT.Category = "[LVS]"

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
		self:SetModel( "models/props_wasteland/gaspump001a.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetTrigger( true )
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	end

	function ENT:Refuel( entity )
		if not IsValid( entity ) then return end

		if not entity.LVS or not entity.GetFuelTank then return end

		local FuelTank = entity:GetFuelTank()

		if not IsValid( FuelTank ) then return end

		if FuelTank:GetFuel() ~= 1 then
			FuelTank:SetFuel( 1 )
			entity:OnRefueled()
		end

		return FuelTank
	end


	function ENT:StartTouch( entity )
		local FuelTank = self:Refuel( entity )

		if not IsValid( FuelTank ) then return end

		local DoorHandler = FuelTank:GetDoorHandler()

		if not IsValid( DoorHandler ) then return end

		DoorHandler:Open()
	end

	function ENT:EndTouch( entity )
		local FuelTank = self:Refuel( entity )

		if not IsValid( FuelTank ) then return end

		local DoorHandler = FuelTank:GetDoorHandler()

		if not IsValid( DoorHandler ) then return end

		DoorHandler:Close()
	end

	function ENT:Touch( entity )
	end

	function ENT:Think()
		return false
	end
end

if CLIENT then
	local WhiteList = {
		["weapon_physgun"] = true,
		["weapon_physcannon"] = true,
		["gmod_tool"] = true,
	}

	local mat = Material( "models/wireframe" )
	local FrameMat = Material( "lvs/3d2dmats/frame.png" )
	local RefuelMat = Material( "lvs/3d2dmats/refuel.png" )
	function ENT:Draw()
		self:DrawModel()

		local ply = LocalPlayer()

		if IsValid( ply ) and not IsValid( ply:lvsGetVehicle() ) then
			if GetConVarNumber( "cl_draweffectrings" ) == 0 then return end

			local ply = LocalPlayer()
			local wep = ply:GetActiveWeapon()

			if not IsValid( wep ) then return end

			local weapon_name = wep:GetClass()

			if not WhiteList[ weapon_name ] then
				return
			end
		end

		local Pos = self:GetPos()

		for i = 0, 180, 180 do
			cam.Start3D2D( self:LocalToWorld( Vector(0,0, self:OBBMins().z + 2 ) ), self:LocalToWorldAngles( Angle(i,90,0) ), 0.25 )
				surface.SetDrawColor( 255, 150, 0, 255 )

				surface.SetMaterial( FrameMat )
				surface.DrawTexturedRect( -350, -350, 700, 700 )

				surface.SetMaterial( RefuelMat )
				surface.DrawTexturedRect( -150, 50, 300, 300 )
			cam.End3D2D()
		end
	end

	function ENT:OnRemove()
	end
end