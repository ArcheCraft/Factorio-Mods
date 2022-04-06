if not arches.blc.triggers["blc-pipes"].copper then
    arches.lib.functions.recipes:remove("copper-pipe")
    arches.lib.functions.recipes:remove("copper-pipe-to-ground")
    arches.lib.functions.recipes:remove("stone-pipe")
    arches.lib.functions.recipes:remove("stone-pipe-to-ground")
end

if not arches.blc.triggers["blc-pipes"].steel then
    arches.lib.functions.technology:remove_recipe_unlock("steel-processing", {"steel-pipe", "steel-pipe-to-ground"})
end

if not arches.blc.triggers["blc-pipes"].plastic then
    arches.lib.functions.technology:remove_recipe_unlock("plastics", {"plastics-pipe", "plastic-pipe-to-ground"})
end