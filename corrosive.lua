-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore
    = minetest, nodecore
local math_random
    = math.random
-- LUALOCALS > ---------------------------------------------------------

local modname = minetest.get_current_modname()

local acidef = {
	description = "Corrosive",
	tiles = {modname .."_corrosive.png^[opacity:64"},
	special_tiles = {modname .. "_corrosive.png^[opacity:64", modname .. "_corrosive.png^[opacity:64"},
	use_texture_alpha = "blend",
--	color = "maroon",
	paramtype = "light",
	liquid_viscosity = 7,
	liquid_renewable = false,
	liquid_range = 8,
	liquid_alternative_flowing = modname .. ":acid_flowing",
	liquid_alternative_source = modname .. ":acid_source",
	pointable = false,
	walkable = false,
	light_source = 5,
	sunlight_propagates = false,
	air_pass = false,
	drowning = 2,
	damage_per_second = 4,
	groups = {
		lux_emit = 16,
		corrosive = 1,
		damage_touch = 9,
		igniter = 1
	},
	post_effect_color = {a = 64, r = 255, g = 75, b = 75},
	sounds = nodecore.sounds("nc_terrain_bubbly")
}
minetest.register_node(modname .. ":acid_source", nodecore.underride({
			drawtype = "liquid",
			liquidtype = "source",
			buildable_to = false,
		}, acidef))
minetest.register_node(modname .. ":acid_flowing", nodecore.underride({
			drawtype = "flowingliquid",
			liquidtype = "flowing",
			paramtype2 = "flowingliquid",
			buildable_to = true,
		}, acidef))

nodecore.register_ambiance({
		label = "acid source ambiance",
		nodenames = {modname .. ":acid_source"},
		neigbors = {"air"},
		interval = 1,
		chance = 10,
		sound_name = "nc_terrain_bubbly",
		sound_gain = 0.2
	})
nodecore.register_ambiance({
		label = "acid flow ambiance",
		nodenames = {modname .. ":acid_flowing"},
		neigbors = {"air"},
		interval = 1,
		chance = 10,
		sound_name = "nc_terrain_bubbly",
		sound_gain = 0.2
	})

local src = modname .. ":acid_source"
local flow = modname .. ":acid_flowing"
local function near(pos, crit)
	return #nodecore.find_nodes_around(pos, crit, {1, 1, 1}, {1, 0, 1}) > 0
end

nodecore.register_fluidwandering(
	"acid",
	{src},
	2,
	function(pos, _, gen)
		if gen < 16 or math_random(1, 2) == 1 then return end
		minetest.set_node(pos, {name = flow})
		nodecore.sound_play("nc_api_craft_hiss", {gain = 1, pos = pos})
		nodecore.smokefx(pos, 0.2, 80)
		nodecore.fallcheck(pos)
		return true
	end
)

