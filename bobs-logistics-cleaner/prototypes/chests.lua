local overwrites = arches.functions:overrides()

if not arches.blc.triggers.chests.mk2 then
    overwrites.technologies:remove("logistic-system-2")
end

if not arches.blc.triggers.chests.mk3 then
    overwrites.technologies:remove("logistic-system-3")
end