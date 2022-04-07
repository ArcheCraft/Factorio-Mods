---@class SettingsTriggers
arches.settings.triggers = arches.settings.triggers or {}

local triggers = {
    boolean = {},
    aggregating = {}
}

---@param name string
local function map_name(name) return name:gsub("_", "-") end

---Defines a boolean trigger
---@param name string The name of the trigger
---@param order string The order of the triggers setting
---@param default boolean The default for the trigger
---@param target string The table to put the result of the trigger in
---@param mod_id string The id of the calling mod to be prepended to the setting's id
function arches.settings.triggers:boolean(name, order, default, target, mod_id)
    table.insert(triggers.boolean, {
        name = name,
        target = target,
        id = mod_id .. "-" .. map_name(name)
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
    table.insert(triggers.aggregating, {
        name = name,
        target = target,
        id = mod_id .. "-" .. map_name(name),
        allowed = allowed
    })
end

---Returns an instance with a target specified
---@param target string The table to put the results of the triggers in
---@param mod_id string The id of the calling mod to be prepended to the setting's id
---@return SettingsTriggersWithTarget
function arches.settings.triggers:with(target, mod_id)
    --- @class SettingsTriggersWithTarget
    local res = {}

    ---Defines a boolean trigger
    ---@param name string The name of the trigger
    ---@param order string The order of the triggers setting
    ---@param default boolean The default for the trigger
    function res:boolean(name, order, default)
        arches.settings.triggers:boolean(name, order, default, target, mod_id)
    end

    ---Defines an aggregating trigger
    ---@param name string The name of the trigger
    ---@param order string The order of the triggers setting
    ---@param default string The default for the trigger
    ---@param allowed string[] The allowed values in the order they will aggregate (first will always be  present)
    function res:aggregating(name, order, default, allowed)
        arches.settings.triggers:aggregating(name, order, default, allowed, target, mod_id)
    end

    return res
end

---Reads the triggers specified into their respective target
function arches.settings.triggers:read()
    for _, v in pairs(triggers.boolean) do
        v.target[v.name] = settings.startup[v.id].value
    end

    for _, v in pairs(triggers.aggregating) do
        local res = {}
        v.target[v.name] = res
        local setting = settings.startup[v.id].value
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
