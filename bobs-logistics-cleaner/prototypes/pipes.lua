local overwrites = arches.functions:overrides()

if not arches.blc.triggers.pipes.copper then
    overwrites.technologies:remove("copper-pipe")
    overwrites.technologies:remove("copper-pipe-to-ground")
    overwrites.technologies:remove("stone-pipe")
    overwrites.technologies:remove("stone-pipe-to-ground")
end

if not arches.blc.triggers.pipes.steel then
    overwrites.technologies:remove_recipe_unlock("steel-processing", {"steel-pipe", "steel-pipe-to-ground"})
end

if not arches.blc.triggers.pipes.plastic then
    overwrites.technologies:remove_recipe_unlock("plastics", {"plastics-pipe", "plastic-pipe-to-ground"})
end