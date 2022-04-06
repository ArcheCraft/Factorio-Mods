if not arches.blc.triggers["blc-trains"].mk2 then
    arches.lib.functions.technology:remove("bob-railway-2")
    arches.lib.functions.technology:remove("bob-fluid-wagon-2")
    arches.lib.functions.technology:remove("bob-armoured-railway")
    arches.lib.functions.technology:remove("bob-armoured-fluid-wagon")
end

if not arches.blc.triggers["blc-trains"].mk3 then
    arches.lib.functions.technology:remove("bob-railway-3")
    arches.lib.functions.technology:remove("bob-fluid-wagon-3")
    arches.lib.functions.technology:remove("bob-armoured-railway-2")
    arches.lib.functions.technology:remove("bob-armoured-fluid-wagon-2")
end
