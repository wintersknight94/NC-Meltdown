-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, math, ipairs
    = minetest, nodecore, math, ipairs
-- LUALOCALS > ---------------------------------------------------------

local modname = minetest.get_current_modname()
local src = modname .. ":acid_source"
local flow = modname .. ":acid_flowing"

local acid_table = { -- node, corroded
	{"nc_terrain:dirt_with_grass",			"nc_terrain:dirt"},
	{"nc_terrain:dirt",						"nc_terrain:dirt_loose"},
	{"nc_terrain:dirt_loose",			"air"},
	{"nc_terrain:stone",					"nc_terrain:cobble"},
	{"nc_lode:stone",						"nc_terrain:cobble"},
	{"nc_lode:ore",						"nc_lode:cobble"},
	{"nc_lode:cobble",						"nc_lode:cobble_loose"},
	{"nc_lignite:stone",					"nc_terrain:cobble"},
	{"nc_terrain:cobble",					"nc_terrain:cobble_loose"},
	{"nc_terrain:cobble_loose",				"nc_terrain:gravel"},
	{"nc_terrain:gravel",					"nc_terrain:gravel_loose"},
	{"nc_terrain:gravel_loose",			"air"},
	{"nc_stonework:bricks_stone_bonded",		"nc_stonework:bricks_stone"},
	{"nc_stonework:bricks_adobe_bonded",		"nc_stonework:bricks_adobe"},
	{"nc_stonework:bricks_sandstone_bonded",	"nc_stonework:bricks_sandstone"},
	{"nc_stonework:bricks_coalstone_bonded",	"nc_stonework:bricks_coalstone"},
	{"nc_stonework:bricks_cloudstone_bonded",	"nc_stonework:bricks_cloudstone"},
	{"nc_stonework:bricks_stone",				"nc_terrain:gravel"},
	{"nc_stonework:bricks_adobe",				"nc_terrain:dirt"},
	{"nc_stonework:bricks_sandstone",			"nc_terrain:sand"},
	{"nc_stonework:bricks_coalstone",			"nc_terrain:gravel"},
	{"nc_stonework:bricks_cloudstone",			"nc_optics:glass_crude"},
	{"nc_optics:glass",						"nc_optics:glass_crude"},
	{"nc_optics:glass_opaque",				"nc_optics:glass_crude"},
	{"nc_optics:glass_float",				"nc_optics:glass_crude"},
	{"nc_optics:glass_crude",				"nc_terrain:sand"},
	{"nc_terrain:sand",						"nc_terrain:sand_loose"},
	{"nc_terrain:sand_loose",			"air"},
	{"nc_lux:stone",						"nc_lux:cobble1"},
	{"nc_lux:cobble1",						"nc_lux:cobble1_loose"},
	{"nc_lux:cobble2",						"nc_lux:cobble2_loose"},
	{"nc_lux:cobble3",						"nc_lux:cobble3_loose"},
	{"nc_lux:cobble4",						"nc_lux:cobble4_loose"},
	{"nc_lux:cobble5",						"nc_lux:cobble5_loose"},
	{"nc_lux:cobble6",						"nc_lux:cobble6_loose"},
	{"nc_lux:cobble7",						"nc_lux:cobble7_loose"},
	{"nc_concrete:adobe",					"nc_terrain:dirt"},
	{"nc_concrete:sandstone",				"nc_terrain:sand"},
	{"nc_concrete:coalstone",				"nc_terrain:gravel"},
	{"nc_concrete:cloudstone",				"nc_optics:glass_crude"},
	{"nc_concrete:concrete_adobe_bindy",		"nc_concrete:adobe"},
	{"nc_concrete:concrete_sandstone_bindy",	"nc_concrete:sandstone"},
	{"nc_concrete:concrete_coalstone_bindy",	"nc_concrete:coalstone"},
	{"nc_concrete:concrete_adobe_boxy",		"nc_concrete:adobe"},
	{"nc_concrete:concrete_sandstone_boxy",		"nc_concrete:sandstone"},
	{"nc_concrete:concrete_coalstone_boxy",		"nc_concrete:coalstone"},
	{"nc_concrete:concrete_adobe_bricky",			"nc_concrete:adobe"},
	{"nc_concrete:concrete_sandstone_bricky",		"nc_concrete:sandstone"},
	{"nc_concrete:concrete_coalstone_bricky",		"nc_concrete:coalstone"},
	{"nc_concrete:concrete_adobe_hashy",			"nc_concrete:adobe"},
	{"nc_concrete:concrete_sandstone_hashy",		"nc_concrete:sandstone"},
	{"nc_concrete:concrete_coalstone_hashy",		"nc_concrete:coalstone"},
	{"nc_concrete:concrete_adobe_horzy",			"nc_concrete:adobe"},
	{"nc_concrete:concrete_sandstone_horzy",		"nc_concrete:sandstone"},
	{"nc_concrete:concrete_coalstone_horzy",		"nc_concrete:coalstone"},
	{"nc_concrete:concrete_adobe_iceboxy",			"nc_concrete:adobe"},
	{"nc_concrete:concrete_sandstone_iceboxy",		"nc_concrete:sandstone"},
	{"nc_concrete:concrete_coalstone_iceboxy",		"nc_concrete:coalstone"},
	{"nc_concrete:concrete_adobe_vermy",			"nc_concrete:adobe"},
	{"nc_concrete:concrete_sandstone_vermy",		"nc_concrete:sandstone"},
	{"nc_concrete:concrete_coalstone_vermy",		"nc_concrete:coalstone"},
	{"nc_concrete:concrete_adobe_verty",			"nc_concrete:adobe"},
	{"nc_concrete:concrete_sandstone_verty",		"nc_concrete:sandstone"},
	{"nc_concrete:concrete_coalstone_verty",		"nc_concrete:coalstone"},
	{"nc_lode:block_tempered",						"nc_lode:block_annealed"},
	{"nc_lode:frame_tempered",						"nc_lode:frame_annealed"},
	{"nc_lode:rod_tempered",						"nc_lode:rod_annealed"},
	{"nc_lode:bar_tempered",						"nc_lode:bar_annealed"},
	{"nc_terrain:water_flowing",				"air"},
	{"nc_terrain:water_gray_flowing",			"air"},
	{"wc_coal:lignite",								"wc_coal:lignite_loose"},
	{"wc_coal:bituminite",							"wc_coal:bituminite_loose"},
	{"wc_coal:anthracite",							"wc_coal:anthracite_loose"},
	{"wc_naturae:muck",								"nc_terrain:dirt"},
	{"nc_terrain:hard_stone_1",						"nc_terrain:stone"},
	{"nc_terrain:hard_stone_2",						"nc_terrain:hard_stone_1"},
	{"nc_terrain:hard_stone_3",						"nc_terrain:hard_stone_2"},
	{"nc_terrain:hard_stone_4",						"nc_terrain:hard_stone_3"},
	{"nc_terrain:hard_stone_5",						"nc_terrain:hard_stone_4"},
	{"nc_terrain:hard_stone_6",						"nc_terrain:hard_stone_5"},
	{"nc_terrain:hard_stone_7",						"nc_terrain:hard_stone_6"},
	{"nc_lode:stone",								"nc_terrain:stone"},
	{"nc_lode:stone_1",								"nc_lode:stone"},
	{"nc_lode:stone_2",								"nc_lode:stone_1"},
	{"nc_lode:stone_3",								"nc_lode:stone_2"},
	{"nc_lode:stone_4",								"nc_lode:stone_3"},
	{"nc_lode:stone_5",								"nc_lode:stone_4"},
	{"nc_lode:stone_6",								"nc_lode:stone_5"},
	{"nc_lode:stone_7",								"nc_lode:stone_6"},
}

for i in ipairs (acid_table) do
	local node		= acid_table[i][1]
	local corrode		= acid_table[i][2]
	
nodecore.register_abm({
		label = "Corrosion",
		nodenames = {node},
		neighbors = {"group:corrosive"},
--		neighbors = {src, flow},
		neighbors_invert = true,
		interval = 2,
		chance = 2,
		action = function(pos)
			nodecore.sound_play("nc_api_craft_hiss", {gain = 0.2, pos = pos})
			nodecore.smokefx(pos, 0.2, 80)
			minetest.set_node(pos, {name = corrode})
			minetest.check_for_falling(pos)
		end
	})

end
