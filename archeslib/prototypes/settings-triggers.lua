---@class SettingsTrigger
arches.lib.settings.triggers = arches.lib.settings.triggers or {}

---Defines a boolean trigger
---@param name string The name of the trigger
---@param order string The order of the triggers setting
---@param default boolean The default for the trigger
---@param target string The table to put the result of the trigger in
function arches.lib.settings.triggers:boolean(name, order, default, target)
    data:extend({
        {
            type = "bool-setting",
            name = name,
            order = order,
            setting_type = "startup",
            default_value = default
        }
    })
end

---Defines an aggregating trigger
---@param name string The name of the trigger
---@param order string The order of the triggers setting
---@param default string The default for the trigger
---@param allowed string[] The allowed values in the order they will aggregate (first will always be  present)
---@param target string The table to put the result of the trigger in
function arches.lib.settings.triggers:aggregating(name, order, default, allowed, target)
    data:extend({
        {
            type = "string-setting",
            name = name,
            order = order,
            setting_type = "startup",
            default_value = default,
            allowed_values = allowed
        }
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
