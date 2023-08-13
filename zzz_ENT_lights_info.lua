
ENT.Lights = {
	{
		Trigger = "main", --[[ Each table in ENT.Lights MUST have this! Everything below is optional.
						valid triggers are:
						"main"
						"main+high"
						"main+brake"
						"high"
						"brake"
						"reverse"
						"turnright"
						"turnleft"
						"fog"
]]

		--SubMaterialID = 1, -- link this trigger to submaterial ID 1 for use with the blend-supmaterial system

--[[
		Sprites = { -- add sprites
			{ pos = Vector(79.02,19.17,25.57) }, -- minimum requires a pos, everything else is optional and will use default values when not set.

			
			{ -- full list of variables:
				pos = Vector(0,0,0),
				mat = Material( "sprites/light_ignorez" ),
				width = 50,
				height = 50,
				colorR = 255,
				colorG = 255,
				colorB = 255,
				colorA = 255
			},


			-- settings recommendations:
			-- (you may need to adjust width and height for each vehicle)

			{ pos = Vector(0,0,0), colorB = 200, colorA = 150 }, -- recommended settings for headlight
			{ pos = Vector(0,0,0), colorG = 0, colorB = 0, colorA = 150 }, -- recommended settings for tail light/brake light
			{ pos = Vector(0,0,0), colorG = 100, colorB = 0, colorA = 50 }, -- recommended settings for turn signals
			{ pos = Vector(0,0,0), colorB = 200, colorA = 150 }, -- recommended settings for fog lights
			{ pos = Vector(0,0,0), colorA = 150 }, - -recommended settings for reverse lights
		},
]]

--[[
		ProjectedTextures = {-- add projected textures
			{ pos = Vector(0,0,0), ang = Angle(0,0,0) }, -- minimum requires a pos and ang, everything else is optional and will use default values when not set.

			{ -- full list of variables ( i recommend only replacing what you really need to replace so you dont mess up the highbeam/lowbeam system) :
				pos = Vector(0,0,0),
				ang = Angle(0,0,0),
				mat = "effects/lvs/car_projectedtexture",
				farz = 1000,
				nearz = 75,
				fov = 40,
				colorR = 255,
				colorG = 255,
				colorB = 255,
				colorA = 255,
				brightness = 5,
				shadows = true,
			},

			{ pos = Vector(0,0,0), ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true }, -- (recommended settings)
		},
]]

--[[
		DynamicLights = {}, -- dynamic lights
			{ pos = Vector(0,0,0), ang = Angle(0,0,0) }, -- minimum requires a pos, everything else is optional and will use default values when not set.
	
			{ -- full list of variables ( i recommend only replacing what you really need to replace so you dont mess up the highbeam/lowbeam system) :
				pos = Vector(0,0,0),
				colorR = 255,
				colorG = 255,
				colorB = 255,
				brightness = 0.1,
				decay= 1000,
				size = 128,
				lifetime = 0.1,
			},

			-- settings recommendations:

			-- DONT USE DYNAMIC LIGHTS THEY ARE UGLY
]]
	},
}
