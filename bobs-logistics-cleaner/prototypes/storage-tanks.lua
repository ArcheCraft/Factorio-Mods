if not arches.blc.triggers["blc-storage-tanks"].mk2 then
    arches.lib.functions.technology:remove_recipe_unlock("bob-fluid-handling-2", {"storage-tank-2", "bob-storage-tank-all-corners-2"})
end

if not arches.blc.triggers["blc-storage-tanks"].mk3 then
    arches.lib.functions.technology:remove_recipe_unlock("bob-fluid-handling-3", {"storage-tank-3", "bob-storage-tank-all-corners-3"})
end

if not arches.blc.triggers["blc-storage-tanks"].mk4 then
    arches.lib.functions.technology:remove_recipe_unlock("bob-fluid-handling-4", {"storage-tank-3", "bob-storage-tank-all-corners-3"})
end
