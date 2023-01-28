
ENT.Base = "lvs_base"

ENT.PrintName = "[LVS] Four Wheel Generic"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/nissan_bluebird910/chassis.mdl"
ENT.GibModels = { ENT.MDL }

function ENT:SetupDataTables()
	self:CreateBaseDT()

	--self:AddDT( "Bool", "Disabled" )

	--if SERVER then
		--self:NetworkVarNotify( "Disabled", self.OnDisabled )
	--end
end

function ENT:CalcMainActivity( ply )
	if ply ~= self:GetDriver() then return end

	if ply.m_bWasNoclipping then 
		ply.m_bWasNoclipping = nil 
		ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM ) 
		
		if CLIENT then 
			ply:SetIK( true )
		end 
	end 

	ply.CalcIdeal = ACT_STAND
	ply.CalcSeqOverride = ply:LookupSequence( "drive_jeep" )

	return ply.CalcIdeal, ply.CalcSeqOverride
end