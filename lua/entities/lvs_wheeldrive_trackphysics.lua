AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )
end

if SERVER then
	function ENT:AddToGibList( ent )
		if not istable( self._GibList ) then self._GibList = {} end

		table.insert( self._GibList, ent )
	end

	function ENT:GetGibList()
		return self._GibList or {}
	end

	function ENT:SpawnGib( LeftOrRight )
		local base = self:GetBase()

		local options = {
			[LVS.WHEELTYPE_LEFT] = "left",
			[LVS.WHEELTYPE_RIGHT] = "right"
		}

		local side = options[ LeftOrRight ]

		if not side or not IsValid( base ) or not istable( base.TrackGibs ) or not base.TrackGibs[ side ] then return end

		for _, data in pairs( base.TrackGibs[ side ] ) do
			local class = util.IsValidRagdoll( data.mdl ) and "prop_ragdoll" or "prop_physics"

			local ent = ents.Create( class )

			if not IsValid( ent ) then continue end

			ent:SetModel( data.mdl )
			ent:SetPos( self:LocalToWorld( data.pos ) )
			ent:SetAngles( self:LocalToWorldAngles( data.ang ) )
			ent:Spawn()
			ent:Activate()
			ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

			self:DeleteOnRemove( ent )

			self:AddToGibList( ent )

			timer.Simple( 59.5, function()
				if not IsValid( ent ) then return end

				ent:SetRenderMode( RENDERMODE_TRANSCOLOR )
				ent:SetRenderFX( kRenderFxFadeFast )
			end )

			timer.Simple( 60, function()
				if not IsValid( ent ) then return end

				ent:Remove()
			end )
		end
	end

	function ENT:ClearGib()
		local Gibs = self:GetGibList()

		for _, ent in pairs( Gibs ) do
			if not IsValid( ent ) then continue end

			ent:Remove()
		end

		table.Empty( Gibs )
	end

	function ENT:Initialize()	
		self:SetUseType( SIMPLE_USE )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:AddEFlags( EFL_NO_PHYSCANNON_INTERACTION )
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		self:DrawShadow( false )

		self:SetMaterial( "models/wireframe" )

		local PhysObj = self:GetPhysicsObject()

		if not IsValid( PhysObj ) then return end

		PhysObj:SetMass( 1 )
		PhysObj:EnableDrag( false )
		PhysObj:EnableGravity( false ) 
		PhysObj:EnableMotion( true )
		PhysObj:SetMaterial( "friction_00" )
	end

	function ENT:Think()
		return false
	end

	function ENT:OnTakeDamage( dmginfo )
		local base = self:GetBase()

		if not IsValid( base ) then return end

		local startpos = dmginfo:GetDamagePosition()
		local endpos = startpos + dmginfo:GetDamageForce():GetNormalized() * 50000

		local trace = util.TraceLine( {
			start = startpos,
			endpos = endpos,
			whitelist = true,
			ignoreworld = true,
			filter = base,
		} )

		if trace.Hit then
			dmginfo:SetDamagePosition( trace.HitPos )
		else
			dmginfo:SetDamageType( dmginfo:GetDamageType() + DMG_PREVENT_PHYSICS_FORCE )
		end

		base:OnTakeDamage( dmginfo )
	end

	function ENT:PhysicsCollide( data, phys )
	end

	function ENT:Use( ply )
		if (ply._lvsNextUse or 0) > CurTime() then return end

		local base = self:GetBase()

		if not IsValid( base ) then return end

		base:Use( ply )
	end

	function ENT:OnRemove()
		self:ClearGib()
	end

	return
end

function ENT:Draw()
	if not LVS.DeveloperEnabled then return end

	self:DrawModel()
end

function ENT:Think()
end

function ENT:OnRemove()
end