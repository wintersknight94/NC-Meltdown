-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, math
    = minetest, nodecore, math
-- LUALOCALS > ---------------------------------------------------------
local modname = minetest.get_current_modname()
------------------------------------------------------------------------
nodecore.register_abm({
		label = "Reactor Meltdown",
		nodenames = {"nc_lux:cobble8"},
--		neighbors = {"nc_terrain:lava_source"},
		interval = 600,
		chance = 100,
		action = function(pos)
			nodecore.set_loud(pos, {name = modname ..":acid_source"})
		end
	})
------------------------------------------------------------------------
nodecore.register_abm({
		label = "Thermal Meltdown",
		nodenames = {"nc_lux:cobble8"},
		neighbors = {"group:lava"},
		interval = 300,
		chance = 10,
		action = function(pos)
			nodecore.set_loud(pos, {name = modname ..":acid_source"})
		end
	})
------------------------------------------------------------------------
