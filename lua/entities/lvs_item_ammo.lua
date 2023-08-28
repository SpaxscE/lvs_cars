AddCSLuaFile()

ENT.Type            = "anim"

ENT.PrintName = "Ammo"
ENT.Author = "Luna"
ENT.Category = "[LVS] - Cars - Items"

ENT.Spawnable		= true
ENT.AdminOnly		= false

if SERVER then
	function ENT:SpawnFunction( ply, tr, ClassName )
		if not tr.Hit then return end

		local ent = ents.Create( ClassName )
		ent:SetPos( tr.HitPos + tr.HitNormal * 5 )
		ent:Spawn()
		ent:Activate()

		return ent
	end

	function ENT:Initialize()	
		self:SetModel( "models/misc/88mm_shell.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:PhysWake()
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	end

	function ENT:Think()
		if self.MarkForRemove then
			self:Remove()

			return false
		end

		self:NextThink( CurTime() + 0.1 )

		return true
	end

	function ENT:AddSingleRound( entity )
		local AmmoIsSet = false

		for PodID, data in pairs( entity.WEAPONS ) do
			for id, weapon in pairs( data ) do
				local MaxAmmo = weapon.Ammo or -1
				local CurAmmo = weapon._CurAmmo or MaxAmmo

				if CurAmmo == MaxAmmo then continue end

				entity.WEAPONS[PodID][ id ]._CurAmmo = math.min( CurAmmo + 1, MaxAmmo )

				AmmoIsSet = true
			end
		end

		if AmmoIsSet then
			entity:SetNWAmmo( entity:GetAmmo() )

			for _, pod in pairs( entity:GetPassengerSeats() ) do
				local weapon = pod:lvsGetWeapon()

				if not IsValid( weapon ) then continue end

				weapon:SetNWAmmo( weapon:GetAmmo() )
			end
		end

		return AmmoIsSet
	end

	function ENT:Refil( entity )
		if self.MarkForRemove then return end

		if not IsValid( entity ) then return end

		if not entity.LVS then return end

		if self:AddSingleRound( entity ) then
			entity:OnMaintenance()

			entity:EmitSound("items/ammo_pickup.wav")

			self.MarkForRemove = true
		end
	end

	function ENT:PhysicsCollide( data, physobj )
		self:Refil( data.HitEntity )
	end

	function ENT:OnTakeDamage( dmginfo )
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end

	function ENT:OnRemove()
	end

	function ENT:Think()
	end
end