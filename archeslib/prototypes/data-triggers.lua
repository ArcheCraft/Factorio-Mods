---@class DataTrigger
arches.lib.settings.triggers = arches.lib.settings.triggers or {}

local triggers = {
    boolean = {},
    aggregating = {}
}

---Defines a boolean trigger
---@param name string The name of the trigger
---@param order string The order of the triggers setting
---@param default boolean The default for the trigger
---@param target string The table to put the result of the trigger in
function arches.lib.settings.triggers:boolean(name, order, default, target)
    table.insert(triggers.boolean, {
        name = name,
        target = target
    })
end

---Defines an aggregating trigger
---@param name string The name of the trigger
---@param order string The order of the triggers setting
---@param default string The default for the trigger
---@param allowed string[] The allowed values in the order they will aggregate (first will always be  present)
---@param target string The table to put the result of the trigger in
function arches.lib.settings.triggers:aggregating(name, order, default, allowed, target)
    table.insert(triggers.aggregating, {
        name = name,
        target = target,
        allowed = allowed
    })
end

---Returns an instance with a target specified
---@param target string The table to put the results of the triggers in
---@return SettingsTriggerWithTarget
function arches.lib.settings.triggers:withTarget(target)
    --- @class SettingsTriggerWithTarget
    local res = {}

    ---Defines a boolean trigger
    ---@param name string The name of the trigger
    ---@param order string The order of the triggers setting
    ---@param default boolean The default for the trigger
    function res:boolean(name, order, default)
        arches.lib.settings.triggers:boolean(name, order, default, target)
    end

    ---Defines an aggregating trigger
    ---@param name string The name of the trigger
    ---@param order string The order of the triggers setting
    ---@param default string The default for the trigger
    ---@param allowed string[] The allowed values in the order they will aggregate (first will always be  present)
    function res:aggregating(name, order, default, allowed)
        arches.lib.settings.triggers:aggregating(name, order, default, allowed, target)
    end

    return res
end

---Reads the triggers specified into their respective target
function arches.lib.settings.triggers:read()
    for _, v in pairs(triggers.boolean) do
        v.target[v.name] = settings.startup[v.name].value
    end

    for _, v in pairs(triggers.aggregating) do
        local res = {}
        v.target[v.name] = res
        local setting = settings.startup[v.name].value
        for i = 1, #v.allowed do
            local option = v.allowed[i]
            res[option] = true
            if setting == option then
                break
            end
        end
    end

    triggers = {
        boolean = {},
        aggregating = {}
    }
end
