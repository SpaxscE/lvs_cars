include("shared.lua")

function ENT:UpdatePoseParameters( steer )
	self:SetPoseParameter( "vehicle_steer", steer )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/bmw_r75/eng_start.wav", 75, 100,  LVS.EngineVolume )

		return
	end

	self:EmitSound( "lvs/vehicles/bmw_r75/eng_stop.wav", 75, 100,  LVS.EngineVolume )
end