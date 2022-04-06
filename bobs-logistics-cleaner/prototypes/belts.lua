if not arches.blc.triggers["blc-belts"].basic then
    arches.lib.functions.technology:remove("logistics-0")
    arches.lib.functions.technology:remove_recipe_unlock("logstics", "transport-belt")
    arches.lib.functions.recipes:remove("basic-transport-belt")
    arches.lib.functions.recipes:enable("transport-belt")
end

if not arches.blc.triggers["blc-belts"].turbo then
    arches.lib.functions.technology:remove("logistics-4")

    if arches.blc.triggers["blc-inserters"].turbo then
        arches.lib.functions.technology:replace_prerequisite("turbo-inserter", "logstics-4", "advanced-electronics-2")
    end
end

if not arches.blc.triggers["blc-belts"].ultimate then
    arches.lib.functions.technology:remove("logistics-5")

    if arches.blc.triggers["blc-inserters"].ultimate then
        arches.lib.functions.technology:replace_prerequisite("turbo-inserter", "logstics-5", "utility-science-pack")
    end
end