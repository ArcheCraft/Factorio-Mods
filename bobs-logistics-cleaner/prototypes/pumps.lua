if not arches.blc.triggers["blc-pumps"].mk2 then
    arches.lib.functions.technology:remove_recipe_unlock("bob-fluid-handling-2", "bob-pump-2")
    if not arches.blc.triggers["blc-storage-tanks"].mk2 then
        arches.lib.functions.technology:remove("bob-fluid-handling-2")
    end
end

if not arches.blc.triggers["blc-pumps"].mk3 then
    arches.lib.functions.technology:remove_recipe_unlock("bob-fluid-handling-3", "bob-pump-3")
    if not arches.blc.triggers["blc-storage-tanks"].mk3 then
        arches.lib.functions.technology:remove("bob-fluid-handling-3")
    end
end

if not arches.blc.triggers["blc-pumps"].mk4 then
    arches.lib.functions.technology:remove_recipe_unlock("bob-fluid-handling-4", "bob-pump-4")
    if not arches.blc.triggers["blc-storage-tanks"].mk4 then
        arches.lib.functions.technology:remove("bob-fluid-handling-4")
    end
end