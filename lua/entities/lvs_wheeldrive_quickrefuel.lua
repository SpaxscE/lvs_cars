AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "Quick Refuel"
ENT.Author = "Luna"
ENT.Information = "Refills fuel tanks"
ENT.Category = "[LVS] - Cars - Items"

ENT.Spawnable		= true
ENT.AdminOnly		= true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "User" )
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
		self:SetModel( "models/props_wasteland/gaspump001a.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )

		local PhysObj = self:GetPhysicsObject()

		if not IsValid( PhysObj ) then return end

		PhysObj:EnableMotion( false )
	end

	function ENT:giveSWEP( ply )
		if self:WorldToLocal( ply:GetPos() ).y > 0 then return end

		ply:Give( "weapon_lvsfuelfiller" )
		ply:SelectWeapon( "weapon_lvsfuelfiller" )
		self:SetUser( ply )
	end

	function ENT:removeSWEP( ply )
		if ply:HasWeapon( "weapon_lvsfuelfiller" ) then
			ply:StripWeapon( "weapon_lvsfuelfiller" )
			ply:SwitchToDefaultWeapon()
		end
		self:SetUser( NULL )
	end

	function ENT:checkSWEP( ply )
		if not ply:Alive() or ply:InVehicle() then

			self:removeSWEP( ply )

			return
		end

		if self:WorldToLocal( ply:GetPos() ).y > 0 then
			self:removeSWEP( ply )

			return
		end

		if (ply:GetPos() - self:GetPos()):LengthSqr() < 150000 then return end

		self:removeSWEP( ply )
	end

	function ENT:Think()
		local ply = self:GetUser()
		local T = CurTime()

		if IsValid( ply ) then
			self:checkSWEP( ply )

			self:NextThink( T )
		else
			self:NextThink( T + 0.5 )
		end

		return true
	end

	function ENT:Use( ply )
		if not IsValid( ply ) or not ply:IsPlayer() then return end

		local User = self:GetUser()

		if IsValid( User ) then
			if User == ply then
				self:removeSWEP( ply )
			end
		else
			self:giveSWEP( ply )
		end
	end
end

if CLIENT then
	function ENT:CreatePumpEnt()
		if IsValid( self.PumpEnt ) then return self.PumpEnt end

		self.PumpEnt = ents.CreateClientProp()
		self.PumpEnt:SetModel( "models/props_equipment/gas_pump_p13.mdl" )
		self.PumpEnt:SetPos( self:LocalToWorld( Vector(-0.2,-14.6,45.7) ) )
		self.PumpEnt:SetAngles( self:LocalToWorldAngles( Angle(-0.3,92.3,-0.1) ) )
		self.PumpEnt:Spawn()
		self.PumpEnt:Activate()
		self.PumpEnt:SetParent( self )

		return self.PumpEnt
	end

	function ENT:RemovePumpEnt()
		if not IsValid( self.PumpEnt ) then return end

		self.PumpEnt:Remove()
	end

	function ENT:Think()
		local PumpEnt = self:CreatePumpEnt()

		local ShouldDraw = IsValid( self:GetUser() )
		local Draw = PumpEnt:GetNoDraw()

		if Draw ~= ShouldDraw then
			PumpEnt:SetNoDraw( ShouldDraw )
		end
	end

	local cable = Material( "cable/cable2" )
	local function bezier(p0, p1, p2, p3, t)
		local e = p0 + t * (p1 - p0)
		local f = p1 + t * (p2 - p1)
		local g = p2 + t * (p3 - p2)

		local h = e + t * (f - e)
		local i = f + t * (g - f)

		local p = h + t * (i - h)

		return p
	end

	function ENT:Draw()
		self:DrawModel()

		if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > 350000 then return end

		local pos = self:LocalToWorld( Vector(10,0,45) )
		local ang = self:LocalToWorldAngles( Angle(0,90,90) )
		local ply = self:GetUser()

		local startPos = self:LocalToWorld( Vector(0.06,-17.77,55.48) )
		local p2 = self:LocalToWorld( Vector(8,-17.77,30) )
		local p3
		local endPos

		if IsValid( ply ) then
			local id = ply:LookupAttachment("anim_attachment_rh")
			local attachment = ply:GetAttachment( id )

			if not attachment then return end

			endPos = (attachment.Pos + attachment.Ang:Forward() * -3 + attachment.Ang:Right() * 2 + attachment.Ang:Up() * -3.5)
			p3 = endPos + attachment.Ang:Right() * 5 - attachment.Ang:Up() * 20
		else
			p3 = self:LocalToWorld( Vector(0,-20,30) )
			endPos = self:LocalToWorld( Vector(0.06,-20.3,37) )
		end

		render.StartBeam( 15 )
		render.SetMaterial( cable )

		for i = 0,15 do
			local pos = bezier(startPos, p2, p3, endPos, i / 14)

			local Col = (render.GetLightColor( pos ) * 0.8 + Vector(0.2,0.2,0.2)) * 255

			render.AddBeam( pos, 1, 0, Color(Col.r,Col.g,Col.b,255) )
		end

		render.EndBeam()
	end

	function ENT:OnRemove()
		self:RemovePumpEnt()
	end
end