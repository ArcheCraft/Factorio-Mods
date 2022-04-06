arches.lib.settings.overrides = arches.lib.settings.overrides or {}

local data = {
    defaults = {},
    overwrites = {}
}

--- Sets the default value for a setting
--- @param setting_type string [bool-setting | int-setting | double-setting | string-setting]
--- @param setting_name string
--- @param value boolean | string | int | double
function arches.lib.settings.overrides:set_default_value(setting_type, setting_name, value)
    self.data.defaults[#self.data.defaults + 1] = { 
        type = setting_type,
        name = setting_name,
        value = value
    }
end

--- Forces a setting to a specific value
--- @param setting_type string [bool-setting | int-setting | double-setting | string-setting]
--- @param setting_name string
--- @param value boolean | string | int | double
function arches.lib.settings.overrides:overwrite(setting_type, setting_name, value)
    -- setting_type: [bool-setting | int-setting | double-setting | string-setting]
    self.data.overwrites[#self.data.overwrites + 1] = {
        type = setting_type,
        name = setting_name,
        value = value
    }
end

--- Sets the default value for a setting
--- @param setting_type string [bool-setting | int-setting | double-setting | string-setting]
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
--- @param setting_type string [bool-setting | int-setting | double-setting | string-setting]
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
function arches.lib.settings.overrides.execute()
    for _, def in pairs(data.defaults) do
        set_default_value(def.type, def.name, def.value)
    end

    data.defaults = {}
    
    for _, ov in pairs(data.overwrites) do
        overwrite(ov.type, ov.name, ov.value)
    end

    data.overwrites = {}
end