
hook.Add( "PreRegisterSENT", "!!!!!!lvs_register_simfphys_vehicles", function( ent, class )
	if class ~= "lvs_base_wheeldrive" then return end

	for name, data in pairs( list.Get( "simfphys_vehicles" ) ) do
		--print( name )
		--print( data.Name )
		--print( data.Members )

		local ENT = {}

		ENT.Base = "lvs_4wheel_drive"

		ENT.MDL = data.Model

		ENT.PrintName = data.Name
		ENT.Author = data.Author
		ENT.Category = "[LVS] - Cars"

		ENT.Spawnable		= data.Spawnable ~= false
		ENT.AdminSpawnable = data.AdminSpawnable == true

		scripted_ents.Register( ENT, name )
	end
end )