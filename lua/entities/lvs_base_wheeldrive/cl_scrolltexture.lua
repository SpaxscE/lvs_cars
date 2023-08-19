
ENT.ScrollTextureData = {
	["$alphatest"] = "1",
	["$translate"] = "[0.0 0.0 0.0]",
	["Proxies"] = {
		["TextureTransform"] = {
			["translateVar"] = "$translate",
			["centerVar"]    = "$center",
			["resultVar"]    = "$basetexturetransform",
		}
	}
}

function ENT:GetRotationDelta( name, rot )
	name =  "_deltaAng"..name

	if not self[ name ] then self[ name ] = Angle(0,0,0) end

	local ang = Angle(0,0,rot)
	local cur = ang:Right()
	local old = self[ name ]:Up()

	local delta = self:AngleBetweenNormal( cur, old ) - 90

	self[ name ] = ang

	return delta
end

function ENT:CalcScroll( name, rot )
	local delta = self:GetRotationDelta( name, rot )

	name =  "_deltaScroll"..name

	if not self[ name ] then self[ name ] = 0 end

	self[ name ] = self[ name ] + delta

	if self[ name ] > 32768 then
		self[ name ] = self[ name ] - 32768
	end

	if self[ name ] < -32768 then
		self[ name ] = self[ name ] + 32768
	end

	return self[ name ]
end

function ENT:ScrollTexture( name, material, pos )
	if not isstring( name ) or not isstring( material ) or not isvector( pos ) then return "" end

	local id = self:EntIndex()
	local class = self:GetClass()

	local texture_name = class.."_["..id.."]_"..name

	if istable( self._StoredScrollTextures ) then
		if self._StoredScrollTextures[ texture_name ] then
			self._StoredScrollTextures[ texture_name ]:SetVector("$translate", pos )

			return "!"..texture_name
		end
	else
		self._StoredScrollTextures = {}
	end

	local data = table.Copy( self.ScrollTextureData )
	data["$basetexture"] = material

	local mat = CreateMaterial(texture_name, "VertexLitGeneric", data )

	self._StoredScrollTextures[ texture_name ] = mat

	return "!"..texture_name
end