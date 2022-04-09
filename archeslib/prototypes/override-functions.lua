local modifications = {
    technology = {
        removals = {},
        prerequisites = {},
        recipe_unlocks = {}
    },
    recipe = {
        removals = {},
        re_enables = {},
        ingredients = {}
    }
}


local function ensure_subtable(target, key)
    if not target[key] then
        target[key] = {}
    end
    return target[key]
end

local function remove_from_table(target, to_remove)
    for key = #target, 1, -1 do
        if to_remove[key] then
            table.remove(target, key)
        end
    end
end

local function override_subtable(subtable, ov_subtable)
    for ov_key, ov_value in pairs(ov_subtable) do
        if type(ov_value) == "table" then
            if not subtable[ov_key] then
                subtable[ov_key] = {}
            end
            override_subtable(subtable[ov_key], ov_value)
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


---Obtain an instance of OverrideFunctions
---@return OverrideFunctions
function arches.functions:overrides()
    ---@class RecipeOverrideFunctions
    local recipes = {}

    ---Disables a recipe
    ---@param recipe string|string[] The name of the recipe
    function recipes:remove(recipe)
        if type(recipe) == "table" then
            for _, r in pairs(recipe) do
                self:remove(r)
            end
        else
            modifications.recipe.removals[recipe] = true
        end
    end

    ---Re-enables a recipe
    ---@param recipe string|string[] The name of the recipe
    function recipes:re_enable(recipe)
        if type(recipe) == "table" then
            for _, r in pairs(recipe) do
                self:re_enable(r)
            end
        else
            modifications.recipe.re_enables[recipe] = true
        end
    end

    ---Replaces the ingredients of the specified recipe with the given ones
    ---@param recipe string the recipe to modify
    ---@param ingredients table[]
    function recipes:set_ingredients(recipe, ingredients)
        modifications.recipe.ingredients[recipe] = ingredients
    end

    ---@class TechnologyOverrideFunctions
    local technologies = {}

    ---Disables a tech and removes it from the tech tree
    ---@param tech string The name of the tech
    function technologies:remove(tech)
        if type(tech) == "table" then
            for _, t in pairs(tech) do
                self:remove(t)
            end
        else
            modifications.technology.removals[tech] = true
        end
    end

    ---Removes a prerequisite from a technology
    ---@param tech string The tech to remove the prerequisite from
    ---@param prereq string The prerequisite to remove
    function technologies:remove_prereq(tech, prereq)
        if type(tech) == "table" then
            for _, t in pairs(tech) do
                self:remove_prereq(t, prereq)
            end
        elseif type(prereq) == "table" then
            for _, p in pairs(prereq) do
                self:remove_prereq(tech, p)
            end
        else
            ensure_subtable(modifications.technology.prerequisites, tech)[prereq] = false
        end
    end

    ---Replaces a prerequisite of a technology
    ---@param tech string The tech to replace the prerequisite of
    ---@param old_prereq string The prerequisite to replace
    ---@param new_prereq string The prerequisite to replace with
    function technologies:replace_prereq(tech, old_prereq, new_prereq)
        if type(tech) == "table" then
            for _, t in pairs(tech) do
                self:replace_prereq(t, old_prereq, new_prereq)
            end
        elseif type(old_prereq) == "table" then
            for _, p in pairs(old_prereq) do
                self:replace_prereq(tech, p, new_prereq)
            end
        else
            ensure_subtable(modifications.technology.prerequisites, tech)[old_prereq] = new_prereq
        end
    end

    ---Removes a recipe unlock from a technology
    ---@param tech string The tech to remove the recipe unlock from
    ---@param recipe string The recipe unlock to remove
    function technologies:remove_recipe_unlock(tech, recipe)
        if type(tech) == "table" then
            for _, t in pairs(tech) do
                self:remove_recipe_unlock(t, recipe)
            end
        elseif type(recipe) == "table" then
            for _, r in pairs(recipe) do
                self:remove_recipe_unlock(tech, r)
            end
        else
            ensure_subtable(modifications.technology.recipe_unlocks, tech)[recipe] = false
        end
    end

    ---Replaces a recipe unlock of a technology
    ---@param tech string The tech to replace the recipe unlock of
    ---@param old_recipe string The recipe unlock to replace
    ---@param new_recipe string The recipe unlock to replace with
    function technologies:replace_recipe_unlock(tech, old_recipe, new_recipe)
        if type(tech) == "table" then
            for _, t in pairs(tech) do
                self:replace_recipe_unlock(t, old_recipe, new_recipe)
            end
        elseif type(old_recipe) == "table" then
            for _, r in pairs(old_recipe) do
                self:replace_recipe_unlock(tech, r, new_recipe)
            end
        else
            ensure_subtable(modifications.technology.recipe_unlocks, tech)[old_recipe] = new_recipe
        end
    end

    ---@class ItemOverrideFunctions
    local items = {}

    ---Hides an item
    ---@param item string The name of the item
    function items:hide(item)
        if type(item) == "table" then
            for _, i in pairs(item) do
                self:hide(i)
            end
        else
            if angelsmods then
                angelsmods.functions.add_flag(item, "hidden")
            else
                if data.raw.fluid[item] then
                    data.raw.fluid[item].hidden = true
                else
                    local item = data.raw.item[item]
                    if item.flags then
                        table.insert(item.flags, "hidden")
                    else
                        item.flags = {"hidden"}
                    end
                end
                data.raw.item[item].hidden = true
            end
        end
    end

    ---@class OverrideFunctions
    local overrides = {
        recipes = recipes,
        technologies = technologies,
        items = items
    }

    return overrides
end


local function process_recipe(recipe_name, recipe)
    if modifications.recipe.removals[recipe_name] then
        recipe.enabled = false
        if recipe.normal then
            recipe.normal.enabled = false
        end
        if recipe.expensive then
            recipe.expensive.enabled = false
        end
    elseif modifications.recipe.re_enables[recipe_name] then
        recipe.enabled = true
        if recipe.normal then
            recipe.normal.enabled = true
        end
        if recipe.expensive then
            recipe.expensive.enabled = true
        end
    end

    if modifications.recipe.ingredients[recipe_name] then
        recipe.ingredients = modifications.recipe.ingredients[recipe_name]
        if recipe.normal then
            recipe.normal.ingredients = modifications.recipe.ingredients[recipe_name]
        end
        if recipe.expensive then
            recipe.expensive.ingredients = modifications.recipe.ingredients[recipe_name]
        end
    end
end

local function process_tech(tech_name, tech)
    if modifications.technology.removals[tech_name] then
        tech.enabled = false
    end

    local prereq_mods = modifications.technology.prerequisites[tech_name]
    if prereq_mods then
        local to_remove = {}
        for key, prereq in pairs(tech.prerequisites) do
            local new = prereq
            while prereq_mods[new] ~= nil do
                new = prereq_mods[new]
            end
            if not new or modifications.technology.removals[new] then
                to_remove[key] = true
            elseif new ~= prereq then
                tech.prerequisites[key] = new
            end
        end
        remove_from_table(tech.prerequisites, to_remove)
    end

    local recipe_mods = modifications.technology.recipe_unlocks[tech_name]
    if recipe_mods then
        local to_remove = {}
        for key, effect in pairs(tech.effects) do
            if effect.type == "unlock-recipe" then
                local new = effect.recipe
                while recipe_mods[new] ~= nil do
                    new = recipe_mods[new]
                end
                if not new or modifications.recipe.removals[new] then
                    to_remove[key] = true
                elseif new ~= effect then
                    effect.recipe = new
                end
            end
        end
        remove_from_table(tech.effects, to_remove)
    end
end

---Should only be called by archeslibpost in data-updates.lua
function arches.functions:execute_updates()
    log(serpent.block(modifications))

    for name, recipe in pairs(data.raw.recipe) do
        process_recipe(name, recipe)
    end

    for name, tech in pairs(data.raw.technology) do
        process_tech(name, tech)
    end
end

function arches.functions:execute_final_fixes()
    -- Nothing yet
end
