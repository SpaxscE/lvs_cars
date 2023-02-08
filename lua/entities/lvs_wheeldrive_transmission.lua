AddCSLuaFile()

ENT.Type            = "anim"

ENT._LVS = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 0, "Base" )
	self:NetworkVar( "Int", 0, "Gear" )
end

if SERVER then
	function ENT:Initialize()
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		self:DrawShadow( false )

		debugoverlay.Cross( self:GetPos(), 15, 5, Color( 0, 0, 255 ) )
	end

	function ENT:Think()	
		return false
	end

	function ENT:PhysicsCollide( data )
	end

	function ENT:OnTakeDamage( dmginfo )	
	end
else
	function ENT:Initialize()
	end

	function ENT:Think()
	end

	function ENT:OnRemove()
	end

	function ENT:Draw()
	end

	function ENT:DrawTranslucent()
	end
end