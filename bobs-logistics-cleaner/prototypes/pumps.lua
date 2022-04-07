local overwrites = arches.functions:overrides()

if not arches.blc.triggers.pumps.mk2 then
    overwrites.technologies:remove_recipe_unlock("bob-fluid-handling-2", "bob-pump-2")
    if not arches.blc.triggers.storage_tanks.mk2 then
        overwrites.technologies:remove("bob-fluid-handling-2")
    end
end

if not arches.blc.triggers.pumps.mk3 then
    overwrites.technologies:remove_recipe_unlock("bob-fluid-handling-3", "bob-pump-3")
    if not arches.blc.triggers.storage_tanks.mk3 then
        overwrites.technologies:remove("bob-fluid-handling-3")
    end
end

if not arches.blc.triggers.pumps.mk4 then
    overwrites.technologies:remove_recipe_unlock("bob-fluid-handling-4", "bob-pump-4")
    if not arches.blc.triggers.storage_tanks.mk4 then
        overwrites.technologies:remove("bob-fluid-handling-4")
    end
end