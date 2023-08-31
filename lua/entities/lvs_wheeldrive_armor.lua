AddCSLuaFile()

ENT.Type            = "anim"
ENT.DoNotDuplicate = true

ENT.RenderGroup = RENDERGROUP_BOTH 

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",0, "Base" )

	self:NetworkVar( "Float",0, "HP" )
	self:NetworkVar( "Float",1, "MaxHP" )
	self:NetworkVar( "Float",2, "IgnoreForce" )

	self:NetworkVar( "Vector",0, "Mins" )
	self:NetworkVar( "Vector",1, "Maxs" )

	self:NetworkVar( "Bool",0, "Destroyed" )

	if SERVER then
		self:SetMaxHP( 100 )
		self:SetHP( 100 )
	end
end

if SERVER then
	function ENT:Initialize()	
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		self:DrawShadow( false )
	end

	function ENT:Think()
		return false
	end

	function ENT:OnTakeDamage( dmginfo )
		local Damage = dmginfo:GetDamage()
		local Force = dmginfo:GetDamageForce()

		if dmginfo:IsDamageType( DMG_BURN ) then return true end

		local IsBlastDamage = dmginfo:IsDamageType( DMG_BLAST )

		if not IsBlastDamage then
			if Force:Length() <= self:GetIgnoreForce() then return false end
		end

		local CurHealth = self:GetHP()

		local NewHealth = math.Clamp( CurHealth - Damage, 0, self:GetMaxHP() )

		self:SetHP( NewHealth )

		if not dmginfo:IsDamageType( DMG_AIRBOAT + DMG_SNIPER + DMG_DIRECT + DMG_BLAST ) then return end

		local pos = dmginfo:GetDamagePosition()
		local dir = Force:GetNormalized()

		local trace = util.TraceLine( {
			start = pos - dir * 20,
			endpos = pos + dir * 20,
			filter = function( ent ) return ent == self:GetBase() end
		} )

		if trace.Entity == self:GetBase() and not IsBlastDamage then
			local Ax = math.acos( math.Clamp( trace.HitNormal:Dot( dir ) ,-1,1) )
			local Fx = math.cos( Ax )

			local HitAngle = 90 - (180 - math.deg( Ax ))

			if HitAngle > 10 then
				local hit_decal = ents.Create( "lvs_wheeldrive_armor_penetrate" )
				hit_decal:SetPos( trace.HitPos )
				hit_decal:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
				hit_decal:Spawn()
				hit_decal:Activate()
				hit_decal:SetParent( trace.Entity )
			else

				local NewDir = dir - trace.HitNormal * Fx * 2

				local hit_decal = ents.Create( "lvs_wheeldrive_armor_bounce" )
				hit_decal:SetPos( trace.HitPos )
				hit_decal:SetAngles( NewDir:Angle() )
				hit_decal:Spawn()
				hit_decal:Activate()
				hit_decal:EmitSound("lvs/armor_rico"..math.random(1,4)..".wav", 95, 100, math.min( dmginfo:GetDamage() / 1000, 1 ) )

				local PhysObj = hit_decal:GetPhysicsObject()
				if IsValid( PhysObj ) then
					PhysObj:EnableDrag( false )
					PhysObj:SetVelocityInstantaneous( NewDir * 2000 + Vector(0,0,250) )
					PhysObj:SetAngleVelocityInstantaneous( VectorRand() * 250 )
				end

				self:SetHP( CurHealth )

				return
			end
		end

		if NewHealth <= 0 then
			self:SetDestroyed( true )

			local Attacker = dmginfo:GetAttacker() 
			if IsValid( Attacker ) and Attacker:IsPlayer() then
				net.Start( "lvs_car_markers" )
				net.Send( Attacker )
			end
		end

		return true
	end

	return
end

function ENT:Initialize()
end

function ENT:OnRemove()
end

function ENT:Think()
end


function ENT:Draw()
end

local function DrawText( pos, text, col )
	cam.Start2D()
		local data2D = pos:ToScreen()

		if not data2D.visible then return end

		local font = "TargetIDSmall"

		local x = data2D.x
		local y = data2D.y

		draw.DrawText( text, font, x + 1, y + 1, Color( 0, 0, 0, 120 ), TEXT_ALIGN_CENTER )
		draw.DrawText( text, font, x + 2, y + 2, Color( 0, 0, 0, 50 ), TEXT_ALIGN_CENTER )
		draw.DrawText( text, font, x, y, col or color_white, TEXT_ALIGN_CENTER )
	cam.End2D()
end

local LVS = LVS
local BoxMat = Material("models/wireframe")
local ColorSelect = Color(0,127,255,150)
local ColorNormal = Color(50,50,50,150)
local ColorTransBlack = Color(0,0,0,150)
local OutlineThickness = Vector(0.5,0.5,0.5)
local ColorText = Color(255,0,0,255)

function ENT:DrawTranslucent()
	if not LVS.DeveloperEnabled then return end

	local ply = LocalPlayer()

	if not IsValid( ply ) or ply:InVehicle() then return end

	local boxOrigin = self:GetPos()
	local boxAngles = self:GetAngles()
	local boxMins = self:GetMins()
	local boxMaxs = self:GetMaxs()

	local HitPos, _, _ = util.IntersectRayWithOBB( ply:GetShootPos(), ply:GetAimVector() * 1000, boxOrigin, boxAngles, boxMins, boxMaxs )

	local InRange = isvector( HitPos )

	local Col = InRange and ColorSelect or ColorNormal

	render.SetColorMaterial()
	render.DrawBox( boxOrigin, boxAngles, boxMins, boxMaxs, Col )
	render.DrawBox( boxOrigin, boxAngles, boxMaxs + OutlineThickness, boxMins - OutlineThickness, ColorTransBlack )

	local boxCenter = (self:LocalToWorld( boxMins ) + self:LocalToWorld( boxMaxs )) * 0.5

	if not InRange then return end

	DrawText( boxCenter, "Armor: "..(self:GetIgnoreForce() / 100).."mm\nHealth:"..self:GetHP().."/"..self:GetMaxHP(), ColorText )
end
