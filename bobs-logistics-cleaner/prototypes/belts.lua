local overwrites = arches.functions:overrides()

if not arches.blc.triggers.belts.basic then
    overwrites.technologies:remove("logistics-0")
    overwrites.technologies:remove_recipe_unlock("logstics", "transport-belt")
    overwrites.recipes:remove("basic-transport-belt")
    overwrites.recipes:re_enable("transport-belt")
end

if not arches.blc.triggers.belts.turbo then
    overwrites.technologies:remove("logistics-4")

    if arches.blc.triggers.inserters.turbo then
        overwrites.technologies:replace_prereq("turbo-inserter", "logstics-4", "advanced-electronics-2")
    end
end

if not arches.blc.triggers.belts.ultimate then
    overwrites.technologies:remove("logistics-5")

    if arches.blc.triggers.inserters.ultimate then
        overwrites.technologies:replace_prereq("turbo-inserter", "logstics-5", "utility-science-pack")
    end
end