local arguments = require("arguments")

---@class FallbackBuilder
arches.functions.recipes.fallbacks = arches.functions.recipes.fallbacks or {}

local fallbacks = {
    items = {},
    fluids = {}
}
local final_fallbacks = nil

local setFallback_fallback_arg = arguments.define({ "name", "multiplier" })

---Registers a fallback for recipe patching
---@param type string [item | fluid]
---@param name string
---@param fallback { name: string, multiplier?: integer } | { [0]: string, [1]?: integer }
---@param priority any
function arches.functions.recipes.fallbacks:set(type, name, fallback, priority)
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

    final_fallbacks = nil
end

local function compute_fallbacks()
    if final_fallbacks == nil then
        final_fallbacks = {
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
            final_fallbacks.items[name] = list[max_priority]
        end

        for name, list in pairs(fallbacks.fluids) do
            table.sort(list, function (a, b)
                return a.priority < b.priority
            end)
            final_fallbacks.fluids[name] = list[1]
        end
    end

    return final_fallbacks
end

local function getFallback(type, name)
    local result = compute_fallbacks()
    if result[type] then
        local fallback = result[type][name]
        if fallback then
            return fallback.name, fallback.multiplier
        end
    end
    return name, 1
end
