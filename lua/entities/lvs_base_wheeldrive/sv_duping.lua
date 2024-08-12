
DEFINE_BASECLASS( "lvs_base" )

local WheelEnts
local WheelAxleID
local WheelAxleData

function ENT:PreEntityCopy()
	BaseClass.PreEntityCopy( self )

	WheelEnts = self._WheelEnts
	WheelAxleID = self._WheelAxleID
	WheelAxleData = self._WheelAxleData

	self._WheelEnts = nil
	self._WheelAxleID = nil
	self._WheelAxleData = nil

	return true
end

function ENT:PostEntityCopy()
	BaseClass.PostEntityCopy( self )

	self._WheelEnts = WheelEnts
	self._WheelAxleID = WheelAxleID
	self._WheelAxleData = WheelAxleData

	WheelEnts = nil
	WheelAxleID = nil
	WheelAxleData = nil
end
