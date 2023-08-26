include("shared.lua")
include("sh_turret.lua")



include("entities/lvs_tank_wheeldrive/cl_tankview.lua")
function ENT:TankViewOverride( ply, pos, angles, fov, pod )
	if ply == self:GetDriver() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "seat1" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos - Muzzle.Ang:Right() * 25
		end
	end

	return pos, angles, fov
end


function ENT:CalcViewPassenger( ply, pos, angles, fov, pod )
	if pod == self:GetGunnerSeat() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "seat2" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos - Muzzle.Ang:Right() * 25
		end
	end

	return LVS:CalcView( self, ply, pos, angles, fov, pod )
end

include("entities/lvs_tank_wheeldrive/cl_attachable_playermodels.lua")
function ENT:DrawDriver()
	local pod = self:GetDriverSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "driver" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "driver" ) return end

	local ID = self:LookupAttachment( "seat1" )
	local Att = self:GetAttachment( ID )

	if not Att then self:RemovePlayerModel() return end

	local Pos,Ang = LocalToWorld( Vector(10,-5,0), Angle(0,20,-90), Att.Pos, Att.Ang )

	local model = self:CreatePlayerModel( ply, "driver" )

	model:SetSequence( "sit" )
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:DrawGunner()
	local pod = self:GetGunnerSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "passenger" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "passenger" ) return end

	local ID = self:LookupAttachment( "seat2" )
	local Att = self:GetAttachment( ID )

	if not Att then self:RemovePlayerModel() return end

	local Pos,Ang = LocalToWorld( Vector(10,-5,0), Angle(0,20,-90), Att.Pos, Att.Ang )

	local model = self:CreatePlayerModel( ply, "passenger" )

	model:SetSequence( "sit" )
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:PreDraw()
	self:DrawDriver()
	self:DrawGunner()

	return true
end


function ENT:OnFrame()
	local Heat1 = 0
	if self:GetSelectedWeapon() == 2 then
		Heat1 = self:QuickLerp( "cannon_heat", self:GetNWHeat(), 100 )
	else
		Heat1 = self:QuickLerp( "cannon_heat", 0, 0.25 )
	end
	local name = "spaehwagen_cannonglow_"..self:EntIndex()
	if not self.TurretGlow1 then
		self.TurretGlow1 = self:CreateSubMaterial( 3, name )

		return
	end
	if self._oldGunHeat1 ~= Heat1 then
		self._oldGunHeat1 = Heat1

		self.TurretGlow1:SetFloat("$detailblendfactor", Heat1 ^ 7 )

		self:SetSubMaterial(3, "!"..name)
	end


	local Heat2 = 0
	if self:GetSelectedWeapon() == 1 then
		Heat2 = self:QuickLerp( "mg_heat", self:GetNWHeat(), 100 )
	else
		Heat2 = self:QuickLerp( "mg_heat", 0, 0.25 )
	end
	local name = "spaehwagen_mgglow_"..self:EntIndex()
	if not self.TurretGlow2 then
		self.TurretGlow2 = self:CreateSubMaterial( 2, name )

		return
	end
	if self._oldGunHeat2 ~= Heat2 then
		self._oldGunHeat2 = Heat2

		self.TurretGlow2:SetFloat("$detailblendfactor", Heat2 ^ 7 )

		self:SetSubMaterial(2, "!"..name)
	end
end
