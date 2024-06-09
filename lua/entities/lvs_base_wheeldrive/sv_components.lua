
function ENT:AddEngine( pos, ang )
	if IsValid( self:GetEngine() ) then return end

	local Engine = ents.Create( "lvs_wheeldrive_engine" )

	if not IsValid( Engine ) then
		self:Remove()

		print("LVS: Failed to create engine entity. Vehicle terminated.")

		return
	end

	Engine:SetPos( self:LocalToWorld( pos ) )
	Engine:SetAngles( self:LocalToWorldAngles( ang or angle_zero ) )
	Engine:Spawn()
	Engine:Activate()
	Engine:SetParent( self )
	Engine:SetBase( self )

	self:SetEngine( Engine )

	self:DeleteOnRemove( Engine )

	self:TransferCPPI( Engine )

	return Engine
end

function ENT:AddFuelTank( pos, ang, tanksize, fueltype, mins, maxs )
	if IsValid( self:GetFuelTank() ) then return end

	local FuelTank = ents.Create( "lvs_wheeldrive_fueltank" )

	if not IsValid( FuelTank ) then
		self:Remove()

		print("LVS: Failed to create fueltank entity. Vehicle terminated.")

		return
	end

	FuelTank:SetPos( self:LocalToWorld( pos ) )
	FuelTank:SetAngles( self:GetAngles() )
	FuelTank:Spawn()
	FuelTank:Activate()
	FuelTank:SetParent( self )
	FuelTank:SetBase( self )
	FuelTank:SetSize( tanksize or 600 )
	FuelTank:SetFuelType( fueltype or 0 )

	self:SetFuelTank( FuelTank )

	self:DeleteOnRemove( FuelTank )

	self:TransferCPPI( FuelTank )

	mins = mins or Vector(-15,-15,-5)
	maxs = maxs or Vector(15,15,5)

	debugoverlay.BoxAngles( self:LocalToWorld( pos ), mins, maxs, self:LocalToWorldAngles( ang ), 15, Color( 255, 255, 0, 255 ) )

	self:AddDS( {
		pos = pos,
		ang = ang,
		mins = mins,
		maxs =  maxs,
		Callback = function( tbl, ent, dmginfo )
			if not IsValid( FuelTank ) then return end

			FuelTank:TakeTransmittedDamage( dmginfo )

			if not FuelTank:GetDestroyed() then
				dmginfo:ScaleDamage( 0.5 )
			end
		end
	} )

	return FuelTank
end

function ENT:AddLights()
	if IsValid( self:GetLightsHandler() ) then return end

	local LightHandler = ents.Create( "lvs_wheeldrive_lighthandler" )

	if not IsValid( LightHandler ) then return end

	LightHandler:SetPos( self:LocalToWorld( self:OBBCenter() ) )
	LightHandler:SetAngles( self:GetAngles() )
	LightHandler:Spawn()
	LightHandler:Activate()
	LightHandler:SetParent( self )
	LightHandler:SetBase( self )

	self:DeleteOnRemove( LightHandler )

	self:TransferCPPI( LightHandler )

	self:SetLightsHandler( LightHandler )
end

function ENT:AddTurboCharger()
	local Ent = self:GetTurbo()

	if IsValid( Ent ) then return Ent end

	local Turbo = ents.Create( "lvs_item_turbo" )

	if not IsValid( Turbo ) then
		self:Remove()

		print("LVS: Failed to create turbocharger entity. Vehicle terminated.")

		return
	end

	Turbo:SetPos( self:GetPos() )
	Turbo:SetAngles( self:GetAngles() )
	Turbo:Spawn()
	Turbo:Activate()
	Turbo:LinkTo( self )

	self:TransferCPPI( Turbo )

	return Turbo
end

function ENT:AddSuperCharger()
	local Ent = self:GetCompressor()

	if IsValid( Ent ) then return Ent end

	local SuperCharger = ents.Create( "lvs_item_compressor" )

	if not IsValid( SuperCharger ) then
		self:Remove()

		print("LVS: Failed to create supercharger entity. Vehicle terminated.")

		return
	end

	SuperCharger:SetPos( self:GetPos() )
	SuperCharger:SetAngles( self:GetAngles() )
	SuperCharger:Spawn()
	SuperCharger:Activate()
	SuperCharger:LinkTo( self )

	self:TransferCPPI( SuperCharger )

	return SuperCharger
end

function ENT:AddDriverViewPort( pos, ang, mins, maxs )
	self:AddDS( {
		pos = pos,
		ang = ang,
		mins = mins,
		maxs =  maxs,
		Callback = function( tbl, ent, dmginfo )
			if dmginfo:GetDamage() <= 0 then return end

			local ply = self:GetDriver()

			if IsValid( ply ) then
				ply:EmitSound("lvs/hitdriver"..math.random(1,2)..".wav",120)
				self:HurtPlayer( ply, dmginfo:GetDamage(), dmginfo:GetAttacker(), dmginfo:GetInflictor() )
			end

			dmginfo:ScaleDamage( 0 )
		end
	} )
end

function ENT:AddTrailerHitch( pos, hitchtype )
	if not hitchtype then

		hitchtype = LVS.HITCHTYPE_MALE

	end

	local TrailerHitch = ents.Create( "lvs_wheeldrive_trailerhitch" )

	if not IsValid( TrailerHitch ) then
		self:Remove()

		print("LVS: Failed to create trailerhitch entity. Vehicle terminated.")

		return
	end

	TrailerHitch:SetPos( self:LocalToWorld( pos ) )
	TrailerHitch:SetAngles( self:GetAngles() )
	TrailerHitch:Spawn()
	TrailerHitch:Activate()
	TrailerHitch:SetParent( self )
	TrailerHitch:SetBase( self )
	TrailerHitch:SetHitchType( hitchtype )

	self:TransferCPPI( TrailerHitch )

	return TrailerHitch
end