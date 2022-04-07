local overwrites = arches.functions:overrides()

if not arches.blc.triggers.trains.mk2 then
    overwrites.technologies:remove("bob-railway-2")
    overwrites.technologies:remove("bob-fluid-wagon-2")
    overwrites.technologies:remove("bob-armoured-railway")
    overwrites.technologies:remove("bob-armoured-fluid-wagon")
end

if not arches.blc.triggers.trains.mk3 then
    overwrites.technologies:remove("bob-railway-3")
    overwrites.technologies:remove("bob-fluid-wagon-3")
    overwrites.technologies:remove("bob-armoured-railway-2")
    overwrites.technologies:remove("bob-armoured-fluid-wagon-2")
end
