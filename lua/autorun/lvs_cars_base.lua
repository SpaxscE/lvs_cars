hook.Add( "PreRegisterSENT", "!!!!!!lvs_register_simfphys_vehicles", function( ent, class )
	if class ~= "lvs_base_wheeldrive" then return end

	for name, data in pairs( list.Get( "simfphys_vehicles" ) ) do

		if not istable( data.Members ) then continue end

		local ENT = {}

		ENT.Base = "lvs_base_wheeldrive"

		ENT.MDL = data.Model

		ENT.PrintName = data.Name
		ENT.Author = data.Author

		if data.Category == "Base" then
			ENT.Category = "[LVS] - Cars"
		else
			ENT.Category = isstring( data.Category ) and "[LVS] - Cars - "..data.Category or "[LVS] - Cars"
		end

		ENT.Spawnable		= data.Spawnable ~= false
		ENT.AdminSpawnable = data.AdminSpawnable == true

		ENT.GibModels = {data.Model}

		scripted_ents.Register( ENT, name )
	end
end )
