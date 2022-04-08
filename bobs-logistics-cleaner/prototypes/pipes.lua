local overwrites = arches.functions:overrides()

if not arches.blc.triggers.pipes.copper then
    overwrites.recipes:remove("copper-pipe")
    overwrites.recipes:remove("copper-pipe-to-ground")
    overwrites.recipes:remove("stone-pipe")
    overwrites.recipes:remove("stone-pipe-to-ground")
end

if not arches.blc.triggers.pipes.steel then
    overwrites.technologies:remove_recipe_unlock("steel-processing", {"steel-pipe", "steel-pipe-to-ground"})
end

if not arches.blc.triggers.pipes.plastic then
    overwrites.technologies:remove_recipe_unlock("plastics", {"plastic-pipe", "plastic-pipe-to-ground"})
end