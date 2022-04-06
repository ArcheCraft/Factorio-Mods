local arguments = require "arguments"

local RB = {}
local fallbacks = {
    items = {},
    fluids = {}
}
local result = nil

local setFallback_fallback_arg = arguments.define({ "name", "multiplier" })

---Registers a fallback for recipe patching
---@param type string [item | fluid]
---@param name string
---@param fallback { name: string, multiplier?: integer } | { [0]: string, [1]?: integer }
---@param priority any
function RB.setFallback(type, name, fallback, priority)
    local fallback_name, fallback_multiplier = setFallback_fallback_arg:parse(fallback)
    local table = fallbacks[type][name]
    if (not table) then
        table = {}
        fallbacks[type][name] = table
    end
    table[priority] = {
        name = fallback_name,
        multiplier = fallback_multiplier
    }

    result = nil
end

function RB.build()
    if result == nil then
        result = {
            items = {},
            fluids = {}
        }

        for name, list in pairs(fallbacks.items) do
            local max_priority = 0
            for priority, fallback in pairs(list) do
                if data.raw[fallback.name] then
                    max_priority = math.max(max_priority, priority)
                end
            end
            result.items[name] = list[max_priority]
        end

        for name, list in pairs(fallbacks.fluids) do
            table.sort(list, function (a, b)
                return a.priority < b.priority
            end)
            result.fluids[name] = list[1]
        end
    end

    return result
end

local function getFallback(type, name)
    local result = RB.build()
    if result[type] then
        local fallback = result[type][name]
        if fallback then
            return fallback.name, fallback.multiplier
        end
    end
    return name, 1
end

return RB