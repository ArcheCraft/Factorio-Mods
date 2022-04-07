local overwrites = arches.functions:overrides()

if not arches.blc.triggers.inserters.express then
    overwrites.technologies:remove("express-inserters")
    overwrites.technologies:remove("stack-inserter-2")
end

if not arches.blc.triggers.inserters.turbo then
    overwrites.technologies:remove("turbo-inserter")
    overwrites.technologies:remove("stack-inserter-3")
end

if not arches.blc.triggers.inserters.ultimate then
    overwrites.technologies:remove("ultimate-inserter")
    overwrites.technologies:remove("stack-inserter-4")
end