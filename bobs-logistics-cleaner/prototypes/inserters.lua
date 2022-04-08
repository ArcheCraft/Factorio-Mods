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
    overwrites.recipes:set_ingredients("inserter", {
        {type = "item", name = "circuit-grey", amount = 1},
        {type = "item", name = "mechanical-parts", amount = 1},
        {type = "item", name = "angels-servo-motor-1", amount = 1}
    })
    overwrites.recipes:set_ingredients("fast-inserter", {
        {type = "item", name = "inserter", amount = 1},
        {type = "item", name = "circuit-red-loaded", amount = 2},
        {type = "item", name = "angels-servo-motor-1", amount = 1}
    })
    overwrites.recipes:set_ingredients("filter-inserter", {
        {type = "item", name = "fast-inserter", amount = 1},
        {type = "item", name = "circuit-red-loaded", amount = 3}
    })
    overwrites.recipes:set_ingredients("stack-inserter", {
        {type = "item", name = "fast-inserter", amount = 1},
        {type = "item", name = "circuit-green-loaded", amount = 4},
        {type = "item", name = "circuit-orange-loaded", amount = 1},
        {type = "item", name = "angels-servo-motor-2", amount = 2}
    })
    overwrites.recipes:set_ingredients("stack-filter-inserter", {
        {type = "item", name = "fast-inserter", amount = 1},
        {type = "item", name = "circuit-orange-loaded", amount = 3},
        {type = "item", name = "angels-servo-motor-3", amount = 1}
    })
end
