
ENT.TireSoundFade = 0.15
ENT.TireSoundTypes = {
	["roll"] = "lvs/vehicles/generic/wheel_roll.wav",
	["roll_dirt"] = "lvs/vehicles/generic/wheel_roll_dirt.wav",
	["roll_wet"] = "lvs/vehicles/generic/wheel_roll_wet.wav",
	["skid"] = "lvs/vehicles/generic/wheel_skid.wav",
	["skid_dirt"] = "lvs/vehicles/generic/wheel_skid_dirt.wav",
	["skid_wet"] = "lvs/vehicles/generic/wheel_skid_wet.wav",
}

function ENT:TireSoundRemove()
	for snd, _ in pairs( self.TireSoundTypes ) do
		self:StopTireSound( snd )
	end
end

function ENT:TireSoundThink()
	for snd, _ in pairs( self.TireSoundTypes ) do
		local T = self:GetTireSoundTime( snd )

		if T > 0 then
			local speed = math.max( self:GetVelocity():Length() , math.abs( self:GetWheelVelocity() ) )

			local sound = self:StartTireSound( snd )

			local volume = math.min(speed / 1000,1) ^ 2 * T
			local pitch = 100 + math.Clamp((speed - 400) / 200,0,155)

			sound:ChangeVolume( volume, 0 )
			sound:ChangePitch( pitch, 0 ) 
		else
			self:StopTireSound( snd )
		end
	end
end

function ENT:DoTireSound( snd )
	local ply = LocalPlayer()

	if ply:lvsGetVehicle() ~= self and string.StartsWith( snd, "roll" ) then return end

	if not istable( self._TireSounds ) then
		self._TireSounds = {}
	end

	self._TireSounds[ snd ] = CurTime() + self.TireSoundFade
end

function ENT:GetTireSoundTime( snd )
	if not istable( self._TireSounds ) or not self._TireSounds[ snd ] then return 0 end

	return math.max(self._TireSounds[ snd ] - CurTime(),0) / self.TireSoundFade
end

function ENT:StartTireSound( snd )
	if not self.TireSoundTypes[ snd ] or not istable( self._ActiveTireSounds ) then
		self._ActiveTireSounds = {}
	end

	if self._ActiveTireSounds[ snd ] then return self._ActiveTireSounds[ snd ] end

	local sound = CreateSound( self, self.TireSoundTypes[ snd ]  )
	sound:PlayEx(0,100)

	self._ActiveTireSounds[ snd ] = sound

	return sound
end

function ENT:StopTireSound( snd )
	if not istable( self._ActiveTireSounds ) or not self._ActiveTireSounds[ snd ] then return end

	self._ActiveTireSounds[ snd ]:Stop()
	self._ActiveTireSounds[ snd ] = nil
end