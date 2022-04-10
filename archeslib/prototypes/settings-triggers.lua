---@class ArchesSettingsTriggers
arches.settings.triggers = arches.settings.triggers or {}

---@param name string
local function map_name(name) return name:gsub("_", "-") end

---Defines a boolean trigger
---@param name string The name of the trigger
---@param order string The order of the triggers setting
---@param default boolean The default for the trigger
---@param target string The table to put the result of the trigger in
---@param mod_id string The id of the calling mod to be prepended to the setting's id
function arches.settings.triggers:boolean(name, order, default, target, mod_id)
    data:extend({
        {
            type = "bool-setting",
            name = mod_id .. "-" .. map_name(name),
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
---@param mod_id string The id of the calling mod to be prepended to the setting's id
function arches.settings.triggers:aggregating(name, order, default, allowed, target, mod_id)
    data:extend({
        {
            type = "string-setting",
            name = mod_id .. "-" .. map_name(name),
            order = order,
            setting_type = "startup",
            default_value = default,
            allowed_values = allowed
        }
    })
end

---Returns an instance with a target specified
---@param target string The table to put the results of the triggers in
---@param mod_id string The id of the calling mod to be prepended to the setting's id
---@return SettingsTriggersWithTarget
function arches.settings.triggers:with(target, mod_id)
    local res = {}

    function res:boolean(name, order, default)
        arches.settings.triggers:boolean(name, order, default, target, mod_id)
    end

    function res:aggregating(name, order, default, allowed)
        arches.settings.triggers:aggregating(name, order, default, allowed, target, mod_id)
    end

    return res
end
