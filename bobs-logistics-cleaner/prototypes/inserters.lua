if not arches.blc.triggers["blc-inserters"].express then
    arches.lib.functions.technology:remove("express-inserters")
    arches.lib.functions.technology:remove("stack-inserter-2")
end

if not arches.blc.triggers["blc-inserters"].turbo then
    arches.lib.functions.technology:remove("turbo-inserter")
    arches.lib.functions.technology:remove("stack-inserter-3")
end

if not arches.blc.triggers["blc-inserters"].ultimate then
    arches.lib.functions.technology:remove("ultimate-inserter")
    arches.lib.functions.technology:remove("stack-inserter-4")
end