
local lvsCars = {}

hook.Add( "PreRegisterSENT", "!!!!!!lvs_register_simfphys_vehicles", function( ent, class )
	if class ~= "lvs_base_wheeldrive" then return end

	for name, data in pairs( list.Get( "simfphys_vehicles" ) ) do
		if not istable( data.Members ) then continue end

		local ENT = {}

		ENT.Base = "lvs_base_wheeldrive"

		ENT.MDL = data.Model

		ENT.PrintName = data.Name
		ENT.Author = data.Author
		ENT.Category = "[LVS] - Cars"

		ENT.Spawnable		= data.Spawnable ~= false
		ENT.AdminSpawnable = data.AdminSpawnable == true

		lvsCars[ name ] = true

		scripted_ents.Register( ENT, name )
	end
end )

hook.Add( "OnEntityCreated", "!!!!lvs_just_in_time_table_merge", function( ent )
	if not IsValid( ent ) then return end

	local class = ent:GetClass()

	if not lvsCars[ class ] then return end

	if SERVER then
		ent:InitFromList( class )
	else
		timer.Simple( 0, function()
			if not IsValid( ent ) then return end

			ent:InitFromList( class )
		end )
	end
end )