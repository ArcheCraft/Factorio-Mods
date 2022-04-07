local overwrites = arches.functions:overrides()

if not arches.blc.triggers.robots.mk1 then
    overwrites.technologies:remove("bob-robots-1")
end

if not arches.blc.triggers.robots.mk2 then
    overwrites.technologies:remove("bob-robots-2")
end

if not arches.blc.triggers.robots.mk3 then
    overwrites.technologies:remove("bob-robots-3")
end

if not arches.blc.triggers.robots.mk4 then
    overwrites.technologies:remove("bob-robots-4")
end
