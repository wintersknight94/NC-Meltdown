-- LUALOCALS < ---------------------------------------------------------
local minetest, nodecore, math
    = minetest, nodecore, math
-- LUALOCALS > ---------------------------------------------------------

local modname = minetest.get_current_modname()


nodecore.register_abm({
		label = "Reactor Meltdown",
		nodenames = {"nc_lux:cobble8"},
--		neighbors = {"nc_terrain:lava_source"},
		interval = 2,
		chance = 2,
		action = function(pos)
			nodecore.set_loud(pos, {name = modname ..":acid_source"})
		end
	})
