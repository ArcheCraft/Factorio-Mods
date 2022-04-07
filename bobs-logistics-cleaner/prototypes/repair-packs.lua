local overwrites = arches.functions:overrides()

if not arches.blc.triggers.repair_packs.mk2 then
    overwrites.technologies:remove("bob-repair-pack-2")
end

if not arches.blc.triggers.repair_packs.mk3 then
    overwrites.technologies:remove("bob-repair-pack-3")
end

if not arches.blc.triggers.repair_packs.mk4 then
    overwrites.technologies:remove("bob-repair-pack-4")
end

if not arches.blc.triggers.repair_packs.mk5 then
    overwrites.technologies:remove("bob-repair-pack-5")
end