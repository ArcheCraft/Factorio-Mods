---@class ArchesUtils
arches.functions.utils = {}

---Ensures the given subtable exists and returns it
---@param target table The target where the subtable needs to exists
---@param key string The key of the subtable
---@return table subtable The subtable
function arches.functions.utils:ensure_subtable(target, key)
    if not target[key] then
        target[key] = {}
    end
    return target[key]
end

---Removes the given elements from the table
---@generic K
---@param target table<K, any> The table to modify
---@param to_remove table<K, true> The values to remove
function arches.functions.utils:remove_from_table(target, to_remove)
    for key = #target, 1, -1 do
        if to_remove[key] then
            table.remove(target, key)
        end
    end
end

---Overrides elements in one table with elements from another table
---@param subtable table The table to overwrite
---@param ov_subtable table The elements with which the subtable is overwritten
function arches.functions.utils:override_subtable(subtable, ov_subtable)
    for ov_key, ov_value in pairs(ov_subtable) do
        if type(ov_value) == "table" then
            if not subtable[ov_key] then
                subtable[ov_key] = {}
            end
            self:override_subtable(subtable[ov_key], ov_value)
        else
            if ov_value == "set_to_nil" then
                subtable[ov_key] = nil
            elseif ov_value == "do_not_modify" then
            else
                subtable[ov_key] = ov_value
            end
        end
    end
end

---Returns the first value that is not equal to nil
---@generic T
---@param a T | nil
---@param ... T | nil The fallback values
---@return T
function arches.functions.utils:fall_through(a, ...)
    local value = a

    local args = table.pack(...)
    for index = 1, #args do
        if value ~= nil then
            break
        else
            value = args[index]
        end
    end

    return value
end

---Only returns the table indexes with given key if the table is not nil
---@generic K, V
---@param target table<K, V> | nil The table to index
---@param key K The key
---@return V? element The value of the table for the given key or nil if the table was nil
function arches.functions.utils:safe_index(target, key)
    return target and target[key]
end

---Appends the values of the new table to the end of the old table
---@param target table The original table
---@param new table The values to be appended
function arches.functions.utils:append_table(target, new)
    local offset = #target
    for index = 1, #new do
        target[index + offset] = new[index]
    end
end

---Checks whether the table contains the given element
---@generic K, V
---@param target table<K, V> The target table
---@param element V | fun(value: V, key: K): boolean A value that is checked for equality or a function that performs a custom check
---@return boolean
function arches.functions.utils:contains(target, element)
    if type(element) == "function" then
        for key, value in pairs(target) do
            if element(value, key) then
                return true
            end
        end

        return false
    else
        for _, value in pairs(target) do
            if value == element then
                return true
            end
        end

        return false
    end
end

---Checks whether the given key exists in the table and optionally checks whether the given predicate returns true for its value
---@generic K, V
---@param target table<K, V>
---@param key K
---@param predicate nil | fun(value: V): boolean
---@return boolean
function arches.functions.utils:exists(target, key, predicate)
    if target[key] ~= nil then
        if predicate then
            return predicate(target[key])
        else
            return true
        end
    else
        return false
    end
end

function arches.functions.utils:to_string(value)
    if value == nil then
        return "nil"
    elseif type(value) == "table" then
        return serpent.block(value)
    elseif type(value) == "function" then
        return "<function>"
    elseif type(value) == "boolean" then
        return value and "true" or "false"
    else
        return "" .. value
    end
end
