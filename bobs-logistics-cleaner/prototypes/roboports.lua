local overwrites = arches.functions:overrides()

if not arches.blc.triggers.roboports.mk1 then
    overwrites.technologies:remove("bob-robo-modular-1")
end

if not arches.blc.triggers.roboports.mk2 then
    overwrites.technologies:remove("bob-robo-modular-2")
end

if not arches.blc.triggers.roboports.mk3 then
    overwrites.technologies:remove("bob-robo-modular-3")
end

if not arches.blc.triggers.roboports.mk4 then
    overwrites.technologies:remove("bob-robo-modular-4")
end
