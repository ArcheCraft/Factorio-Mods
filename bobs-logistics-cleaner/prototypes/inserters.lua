local overwrites = arches.functions:overrides()

local disabled = mods["angelsindustries"] and arches.blc.triggers.no_industries_inserters

if disabled or not arches.blc.triggers.inserters.express then
    overwrites.technologies:remove("express-inserters")
    overwrites.technologies:remove("stack-inserter-2")
end

if disabled or not arches.blc.triggers.inserters.turbo then
    overwrites.technologies:remove("turbo-inserter")
    overwrites.technologies:remove("stack-inserter-3")
end

if disabled or not arches.blc.triggers.inserters.ultimate then
    overwrites.technologies:remove("ultimate-inserter")
    overwrites.technologies:remove("stack-inserter-4")
end

if disabled or arches.blc.triggers.no_steam_inserter then
    overwrites.recipes:remove("steam-inserter")
end

if disabled then
    overwrites.recipes:patch_recipes("inserter", {
        ingredients = {
            {"!!"},
            {"circuit-grey", 1},
            {"mechanical-parts", 1},
            {"angels-servo-motor-1", 1}
        }
    })
    overwrites.recipes:patch_recipes("fast-inserter", {
        ingredients = {
            {"!!"},
            {"inserter", 1},
            {"circuit-red-loaded", 2},
            {"angels-servo-motor-1", 1}
        }
    })
    overwrites.recipes:patch_recipes("filter-inserter", {
        ingredients = {
            {"!!"},
            {"fast-inserter", 1},
            {"circuit-red-loaded", 3}
        }
    })
    overwrites.recipes:patch_recipes("stack-inserter", {
        ingredients = {
            {"!!"},
            {"fast-inserter", 1},
            {"circuit-green-loaded", 4},
            {"circuit-orange-loaded", 1},
            {"angels-servo-motor-2", 2}
        }
    })
    overwrites.recipes:patch_recipes("stack-filter-inserter", {
        ingredients = {
            {"!!"},
            {"fast-inserter", 1},
            {"circuit-orange-loaded", 3},
            {"angels-servo-motor-3", 1}
        }
    })
end
