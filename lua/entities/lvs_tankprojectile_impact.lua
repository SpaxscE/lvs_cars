AddCSLuaFile()

ENT.Type            = "anim"

ENT.DoNotDuplicate = true

if SERVER then
	function ENT:Initialize()	
	end

	function ENT:Think()
		return false
	end

	function ENT:OnRemove()
	end

	return
end

function ENT:Initialize()
end

function ENT:Think()
end

function ENT:OnRemove()
end

function ENT:Draw()
end
