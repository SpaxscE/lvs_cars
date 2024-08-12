
DEFINE_BASECLASS( "lvs_base" )

function ENT:OnEntityCopyTableFinish( data )
	BaseClass.OnEntityCopyTableFinish( self, data )

	data._WheelEnts = nil
	data._WheelAxleID = nil
	data._WheelAxleData = nil
end
