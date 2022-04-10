---@class ArchesSettingsOverrides
arches.settings.overrides = arches.settings.overrides or {}

arches.settings.overrides.data = {
    defaults = {},
    overwrites = {}
}

--- Sets the default value for a setting
--- @param setting_type '"bool-setting"'|'"int-setting"'|'"double-setting"'|'"string-setting"'' The type of the setting
--- @param setting_name string
--- @param value boolean | string | int | double
function arches.settings.overrides:set_default_value(setting_type, setting_name, value)
    table.insert(self.data.defaults, { 
        type = setting_type,
        name = setting_name,
        value = value
    })
end

--- Forces a setting to a specific value
--- @param setting_type '"bool-setting"'|'"int-setting"'|'"double-setting"'|'"string-setting"'' The type of the setting
--- @param setting_name string
--- @param value boolean | string | int | double
function arches.settings.overrides:overwrite(setting_type, setting_name, value)
    -- setting_type: [bool-setting | int-setting | double-setting | string-setting]
    table.insert(self.data.overwrites + 1, {
        type = setting_type,
        name = setting_name,
        value = value
    })
end

--- Sets the default value for a setting
--- @param setting_type '"bool-setting"'|'"int-setting"'|'"double-setting"'|'"string-setting"'' The type of the setting
--- @param setting_name string
--- @param value boolean | string | int | double
local function set_default_value(setting_type, setting_name, value)
    if data.raw[setting_type] then
        local setting = data.raw[setting_type][setting_name]
        if (setting) then
            setting.default_value = value
        end
    end
end

--- Forces a setting to a specific value
--- @param setting_type '"bool-setting"'|'"int-setting"'|'"double-setting"'|'"string-setting"'' The type of the setting
--- @param setting_name string
--- @param value boolean | string | int | double
local function overwrite(setting_type, setting_name, value)
    -- setting_type: [bool-setting | int-setting | double-setting | string-setting]
    if data.raw[setting_type] then
        local setting = data.raw[setting_type][setting_name]
        if setting then
            if setting_type == 'bool-setting' then
                setting.forced_value = value
            else
                setting.default_value = value
                setting.allowed_values = {value}
            end
            setting.hidden = true
        else
            log('Error: missing setting ' .. setting_name)
        end
    else
        log('Error: missing setting type ' .. setting_type)
    end
end

--- Executes the data collected until now. Done automatically by 'archeslibpost'.
function arches.settings.overrides:execute()
    for _, def in pairs(self.data.defaults) do
        set_default_value(def.type, def.name, def.value)
    end

    self.data.defaults = {}
    
    for _, ov in pairs(self.data.overwrites) do
        overwrite(ov.type, ov.name, ov.value)
    end

    self.data.overwrites = {}
end