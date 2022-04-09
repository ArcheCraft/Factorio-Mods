local arguments = require("arguments")

---@class RecipeBuilder
arches.functions.recipes = arches.functions.recipes or {}

---@class ItemOptionBuilder
arches.functions.recipes.item_options = {}

local item_options = {
    items = {},
    fluids = {}
}
local baked_item_options = nil

local item_options__set__option__arg__ = arguments.define({ "name", "multiplier" })

---Registers a fallback for recipe patching
---@param type string [item | fluid]
---@param name string
---@param option { name: string, multiplier?: integer } | { [0]: string, [1]?: integer }
---@param priority any
function arches.functions.recipes.item_options:set(type, name, option, priority)
    local option_name, option_multiplier = item_options__set__option__arg__:parse(option)
    local table = item_options[type][name]
    if (not table) then
        table = {}
        item_options[type][name] = table
    end
    table[priority] = {
        name = option_name,
        multiplier = option_multiplier
    }

    baked_item_options = nil
end

local function compute_item_options()
    if baked_item_options == nil then
        baked_item_options = {
            items = {},
            fluids = {}
        }

        for name, list in pairs(item_options.items) do
            local max_priority = 0
            for priority, fallback in pairs(list) do
                if data.raw[fallback.name] then
                    max_priority = math.max(max_priority, priority)
                end
            end
            baked_item_options.items[name] = list[max_priority]
        end

        for name, list in pairs(item_options.fluids) do
            table.sort(list, function (a, b)
                return a.priority < b.priority
            end)
            baked_item_options.fluids[name] = list[1]
        end
    end

    return baked_item_options
end

local function get_item_option(type, name)
    local result = compute_item_options()
    if result[type] then
        local option = result[type][name]
        if option then
            return option.name, option.multiplier
        end
    end
    return name, 1
end


local function process_ingredients(ingredients)
    local existing_ingredients = {
        item = {},
        fluid = {}
    }

    local index, length = 1, #ingredients
    while index <= length do
        local element = ingredients[index]

        local type, name, count
        if not element.name then
            type = "item"
            name = element[1]
            count = element[2] or 1
        else
            type = element.type
            name = element.name
            count = element.amount
        end

        local multiplier
        name, multiplier = get_item_option(type, name)
        count = math.ceil(count * multiplier)

        local existing = existing_ingredients[type][name]
        if existing then
            ingredients[existing] = ingredients[existing] + count
            table.remove(ingredients, index)
            length = length - 1
        elseif count == 0 then
            table.remove(ingredients, index)
            length = length - 1
        else
            ingredients[index] = { type = type, name = name, amount = count }
            existing_ingredients[type][name] = index
            index = index + 1
        end
    end
end

local function process_recipe(recipe)
    if recipe.normal or recipe.expensive then
        if recipe.normal then
            process_ingredients(recipe.normal.ingredients)
        end
        if recipe.expensive then
            process_ingredients(recipe.expensive.ingredients)
        end
    else
        process_ingredients(recipe.ingredients)
    end
end

---Builds recipes based on the given recipes.
---Use like data:extend(), but can contain item options
---@param recipes table[]
function arches.functions.recipes:build(recipes)
    for _, recipe in pairs(recipes) do
        process_recipe(recipe)
    end
    data:extend(recipes)
end


---properties that are splittable into expensive and normal
local difficulty_split_keys = {
    ---handled seperately
    ingredients = true,

    enabled = true,
    hidden = true,
    hide_from_stats = true,
    hide_from_player_crafting = true,

    allow_decomposition = true,
    allow_as_intermediate = true,
    allow_intermediates = true,

    always_show_made_in = true,
    show_amount_in_title = true,
    always_show_products = true,

    energy_required = true,
    emissions_multiplier = true,

    requester_paste_multiplier = true,

    overload_multiplier = true,
    allow_inserter_overload = true,

    main_product = true,

    unlock_results = true
}

---properties that cannot be used in patches
local patch_blocked = {
    type = true,
    name = true,

    expensive = true,
    normal = true,

    ---Result handled seperately
    result = true,
    result_count = true,
    results = true,

    ---Amount handled seperately
    amount = true,

    ---Only top level
    crafting_machine_tints = true
}

local function fall_through(a, ...)
    local value = a

    for _, b in pairs(table.pack(...)) do
        if value ~= nil then
            break
        else
            value = b
        end
    end

    return value
end

local function safe_index(target, key)
    return target and target[key]
end

local function patch_item_lists(base, patch)
    local result

    if next(patch) then
        result = {}
        local cached_indices, new_values
        local length

        local function reset()
            cached_indices = {
                item = {},
                fluid = {}
            }
            new_values = {}
            length = 1
        end


        local function add(name, type, amount)
            if amount > 0 then
                local index = cached_indices[type][name]
                if index then
                    new_values[index].amount = new_values[index].amount + amount
                else
                    new_values[length] = { type = type, name = name, amount = amount }
                    cached_indices[type][name] = length
                    length = length + 1
                end
            end
        end

        local function set(name, type, amount)
            if amount > 0 then
                local index = cached_indices[type][name]
                if index then
                    new_values[index].amount = amount
                else
                    new_values[length] = { type = type, name = name, amount = amount }
                    cached_indices[type][name] = length
                    length = length + 1
                end
            elseif amount == 0 then
                local index = cached_indices[type][name]
                if index then
                    new_values[index] = nil
                    cached_indices[type][name] = nil
                end
            end
        end

        local function scale(name, type, multiplier)
            if multiplier > 0 then
                local index = cached_indices[type][name]
                if index then
                    new_values[index].amount = new_values[index].amount * multiplier
                end
            elseif multiplier == 0 then
                set(name, type, 0)
            end
        end


        local function copy_attributes(name, type, data)
            local index = cached_indices[type][name]
            if index then
                for key, value in pairs(data) do
                    if not patch_blocked[key] then
                        new_values[index][key] = value
                    end
                end
            end
        end


        reset()

        for _, item in pairs(base) do
            local type, name, amount = item.type or "item", item.name or item[1], item.amount or item[2]
            add(name, type, amount)
            copy_attributes(name, type, item)
        end

        for _, item in pairs(patch) do
            local type, name, amount = item.type or "item", item.name or item[1], item.amount or item[2]
            if name == "!!" then
                reset()
            else
                local operation
                operation, amount = string.match(amount, "^([%*%+%-=]) (.+)")
                amount = tonumber(amount)
                if operation == "=" then
                    set(name, type, amount)
                    copy_attributes(name, type, item)
                elseif operation == "+" then
                    add(name, type, amount)
                    copy_attributes(name, type, item)
                elseif operation == "-" then
                    add(name, type, -amount)
                    copy_attributes(name, type, item)
                elseif operation == "*" then
                    scale(name, type, amount)
                    copy_attributes(name, type, item)
                end
            end
        end

        for key = 1, length - 1 do
            if new_values[key] then
                table.insert(result, new_values[key])
            end
        end
    else
        result = base
    end

    return result
end

local function merge_patch(base, patch, key)
    if key == "ingredients" then
        return patch_item_lists(base, patch or {})
    else
        return fall_through(base, patch)
    end
end

local function get_split_value(target, key, expensive, is_base)
    local value, value_normal, value_expensive = target[key], safe_index(target.normal, key), safe_index(target.expensive, key)

    if expensive then
        if is_base then
            return fall_through(value_expensive, value, value_normal)
        else
            return fall_through(value_expensive, value)
        end
    else
        if is_base then
            return fall_through(value_normal, value, value_expensive)
        else
            return fall_through(value_normal, value)
        end
    end
end

local function merge_patch_results(target, base, patch, split_difficulty, expensive)
    local base_result, base_count, base_results
    local patch_result, patch_count, patch_results
    if split_difficulty then
        base_result, base_count, base_results = get_split_value(base, "result", expensive, true), get_split_value(base, "result_count", expensive, true), get_split_value(base, "results", expensive, true)
        patch_result, patch_count, patch_results = get_split_value(patch, "result", expensive), get_split_value(patch, "result_count", expensive), get_split_value(patch, "results", expensive)
    else
        base_result, base_count, base_results = base.result, base.result_count, base.results
        patch_result, patch_count, patch_results = patch.result, patch.result_count, patch.results
    end

    if patch_results then
        local results = patch_item_lists(base_result or {{ type = "item", name = base_result, amount = base_count or 1 }}, patch_results)
        if not next(results) then
            results[1] = { "arches-error" , 1 }
        end
        target.results = results
    elseif patch_result then
        target.result = patch_result
        target.result_count = fall_through(patch_count, base_count)
    elseif base_results then
        target.results = base_results
    else
        target.result = base_result
        target.result_count = fall_through(patch_count, base_count)
    end
end

local function apply_patch(patch)
    local result = nil
    local name = patch.name
    local base = name and data.raw.recipe[name]

    if base then
        result = {
            type = "recipe",
            name = name
        }

        local split_difficulty = base.normal or base.expensive or patch.normal or patch.expensive
        if split_difficulty then
            result.normal = {}
            result.expensive = {}

            for key in pairs(difficulty_split_keys) do
                result.normal[key] = merge_patch(get_split_value(base, key, false), get_split_value(patch, key, false), key)
                result.expensive[key] = merge_patch(get_split_value(base, key, true), get_split_value(patch, key, true), key)
            end

            merge_patch_results(result.normal, base, patch, true, false)
            merge_patch_results(result.expensive, base, patch, true, true)
        else
            merge_patch_results(result, base, patch)
        end

        local function top_level_key(key)
            return not patch_blocked[key] and not (split_difficulty and difficulty_split_keys[key])
        end

        for key, value in pairs(base) do
            if top_level_key(key) then
                result[key] = merge_patch(value, patch[key], key)
                patch[key] = nil
            end
        end

        for key, value in pairs(patch) do
            if top_level_key(key)  then
                result[key] = value
            end
        end
    end

    return result
end

---Patches recipes based on the given patches
---@param patch_list table[]
function arches.functions.recipes:patch(patch_list)
    local recipes = {}
    for _, patch in pairs(patch_list) do
        local recipe = apply_patch(patch)
        if recipe then
            table.insert(recipes, recipe)
        end
    end
    if next(recipes) then
        self:build(recipes)
    end
end
