local overwrites = arches.functions:overrides()

if not arches.blc.triggers.storage_tanks.mk2 then
    overwrites.technologies:remove_recipe_unlock("bob-fluid-handling-2", {"storage-tank-2", "bob-storage-tank-all-corners-2"})
end

if not arches.blc.triggers.storage_tanks.mk3 then
    overwrites.technologies:remove_recipe_unlock("bob-fluid-handling-3", {"storage-tank-3", "bob-storage-tank-all-corners-3"})
end

if not arches.blc.triggers.storage_tanks.mk4 then
    overwrites.technologies:remove_recipe_unlock("bob-fluid-handling-4", {"storage-tank-3", "bob-storage-tank-all-corners-3"})
end
