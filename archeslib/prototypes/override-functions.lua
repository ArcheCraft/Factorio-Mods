local utils = arches.functions.utils


local modifications = {
    technology = {
        removals = {},
        prerequisites = {},
        recipe_unlocks = {}
    },
    recipe = {
        patches = {},
        ingredients = {}
    }
}


local function set_patch(name, patch)
    if modifications.recipe.patches[name] then
        arches.functions.recipes:merge_patches(modifications.recipe.patches[name], patch)
    else
        modifications.recipe.patches[name] = patch
    end
end

---Obtain an instance of OverrideFunctions
---@return OverrideFunctions
function arches.functions:overrides()
    ---@class RecipeOverrideFunctions
    local recipes = {}

    ---Apply the given patch to the given recipes
    ---@param recipe string|string[] The recipes to patch
    ---@param patch table The patch to apply
    function recipes:patch_recipes(recipe, patch)
        if type(recipe) == "table" then
            for _, r in pairs(recipes) do
                self:patch_recipes(r, patch)
            end
        else
            patch = table.deepcopy(patch)
            patch.name = recipe
            set_patch(recipe, patch)
        end
    end

    ---Apply the given patches to their recipes
    ---@param patches table[] The patches to apply
    function recipes:apply_patches(patches)
        for _, patch in pairs(patches) do
            local name = patch.name
            if name then
                set_patch(name, patch)
            end
        end
    end

    ---Replaces the given item in every recipe with the new item
    ---@param old string|string[] The item to replace
    ---@param new string The item to replace with
    function recipes:replace_item(old, new)
        if type(old) == "table" then
            for _, i in pairs(old) do
                self:replace_item(i, new)
            end
        else
            modifications.recipe.ingredients[old] = new
        end
    end

    ---Patches the given recipe's normal input with the given ingredients
    ---@param recipe string|string[]
    ---@param ingredients table[]
    function recipes:patch_normal_input(recipe, ingredients)
        if type(recipe) == "table" then
            for _, r in pairs(recipe) do
                self:patch_normal_input(r, ingredients)
            end
        else
            set_patch(recipe, {
                normal = {
                    ingredients = ingredients
                },
                name = recipe
            })
        end
    end

    ---Patches the given recipe's expensive input with the given ingredients
    ---@param recipe string|string[]
    ---@param ingredients table[]
    function recipes:patch_expensive_input(recipe, ingredients)
        if type(recipe) == "table" then
            for _, r in pairs(recipe) do
                self:patch_expensive_input(r, ingredients)
            end
        else
            set_patch(recipe, {
                expensive = {
                    ingredients = ingredients
                },
                name = recipe
            })
        end
    end

    ---Patches the given recipe's input with the given ingredients
    ---@param recipe string|string[]
    ---@param ingredients table[]
    function recipes:patch_input(recipe, ingredients)
        if type(recipe) == "table" then
            for _, r in pairs(recipe) do
                self:patch_input(r, ingredients)
            end
        else
            if utils:exists(modifications.recipe.patches, recipe, function (value) return arches.functions.recipes:is_difficulty_split(value) end) then
                self:patch_normal_input(recipe, ingredients)
                self:patch_expensive_input(recipe, ingredients)
            else
                set_patch(recipe, {
                    ingredients = ingredients,
                    name = recipe
                })
            end
        end
    end

    ---Patches the given recipe's normal output with the given results
    ---@param recipe string|string[]
    ---@param results table[]
    function recipes:patch_normal_output(recipe, results)
        if type(recipe) == "table" then
            for _, r in pairs(recipe) do
                self:patch_normal_output(r, results)
            end
        else
            set_patch(recipe, {
                normal = {
                    results = results
                },
                name = recipe
            })
        end
    end

    ---Patches the given recipe's expensive output with the given results
    ---@param recipe string|string[]
    ---@param results table[]
    function recipes:patch_expensive_output(recipe, results)
        if type(recipe) == "table" then
            for _, r in pairs(recipe) do
                self:patch_expensive_output(r, results)
            end
        else
            set_patch(recipe, {
                expensive = {
                    results = results
                },
                name = recipe
            })
        end
    end

    ---Patches the given recipe's output with the given results
    ---@param recipe string|string[]
    ---@param results table[]
    function recipes:patch_output(recipe, results)
        if type(recipe) == "table" then
            for _, r in pairs(recipe) do
                self:patch_output(r, results)
            end
        else
            if utils:exists(modifications.recipe.patches, recipe, function (value) return arches.functions.recipes:is_difficulty_split(value) end) then
                self:patch_normal_output(recipe, results)
                self:patch_expensive_output(recipe, results)
            else
                set_patch(recipe, {
                    results = results,
                    name = recipe
                })
            end
        end
    end

    ---Removes the given item from the recipe's normal input
    ---@param recipe string|string[]
    ---@param item string|string[]
    function recipes:remove_normal_input(recipe, item)
        if type(recipe) == "table" then
            for _, r in pairs(recipe) do
                self:remove_normal_input(r, item)
            end
        elseif type(item) == "table" then
            for _, i in pairs(item) do
                self:remove_normal_input(recipe, i)
            end
        else
            self:patch_normal_input(recipe, {{ item, 0 }})
        end
    end

    ---Removes the given item from the recipe's expensive input
    ---@param recipe string|string[]
    ---@param item string|string[]
    function recipes:remove_expensive_input(recipe, item)
        if type(recipe) == "table" then
            for _, r in pairs(recipe) do
                self:remove_expensive_input(r, item)
            end
        elseif type(item) == "table" then
            for _, i in pairs(item) do
                self:remove_expensive_input(recipe, i)
            end
        else
            self:patch_expensive_input(recipe, {{ item, 0 }})
        end
    end

    ---Removes the given item from the recipe's input
    ---@param recipe string|string[]
    ---@param item string|string[]
    function recipes:remove_input(recipe, item)
        if type(recipe) == "table" then
            for _, r in pairs(recipe) do
                self:remove_input(r, item)
            end
        elseif type(item) == "table" then
            for _, i in pairs(item) do
                self:remove_input(recipe, i)
            end
        else
            self:patch_input(recipe, {{ item, 0 }})
        end
    end

    ---Removes the given item from the recipe's normal output
    ---@param recipe string|string[]
    ---@param item string|string[]
    function recipes:remove_normal_output(recipe, item)
        if type(recipe) == "table" then
            for _, r in pairs(recipe) do
                self:remove_normal_output(r, item)
            end
        elseif type(item) == "table" then
            for _, i in pairs(item) do
                self:remove_normal_output(recipe, i)
            end
        else
            self:patch_normal_output(recipe, {{ item, 0 }})
        end
    end

    ---Removes the given item from the recipe's expensive output
    ---@param recipe string|string[]
    ---@param item string|string[]
    function recipes:remove_expensive_output(recipe, item)
        if type(recipe) == "table" then
            for _, r in pairs(recipe) do
                self:remove_expensive_output(r, item)
            end
        elseif type(item) == "table" then
            for _, i in pairs(item) do
                self:remove_expensive_output(recipe, i)
            end
        else
            self:patch_expensive_output(recipe, {{ item, 0 }})
        end
    end

    ---Removes the given item from the recipe's output
    ---@param recipe string|string[]
    ---@param item string|string[]
    function recipes:remove_output(recipe, item)
        if type(recipe) == "table" then
            for _, r in pairs(recipe) do
                self:remove_output(r, item)
            end
        elseif type(item) == "table" then
            for _, i in pairs(item) do
                self:remove_output(recipe, i)
            end
        else
            self:patch_output(recipe, {{ item, 0 }})
        end
    end

    ---Disables a recipe
    ---@param recipe string|string[] The name of the recipe
    function recipes:remove(recipe)
        if type(recipe) == "table" then
            for _, r in pairs(recipe) do
                self:remove(r)
            end
        else
            set_patch(recipe, {
                enabled = false,
                hidden = true,
                name = recipe
            })
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
            set_patch(recipe, {
                enabled = true,
                hidden = false,
                name = recipe
            })
        end
    end

    ---@class TechnologyOverrideFunctions
    local technologies = {}

    ---Disables a tech and removes it from the tech tree
    ---@param tech string|string[] The name of the tech
    function technologies:remove(tech)
        if type(tech) == "table" then
            for _, t in pairs(tech) do
                self:remove(t)
            end
        else
            modifications.technology.removals[tech] = true
        end
    end

    ---Disables a tech and replaces it with new_tech in all prerequisites
    ---@param tech string|string[] The tech to remove
    ---@param new_tech string The tech to replace with
    function technologies:replace(tech, new_tech)
        self:remove(tech)
        self:replace_prereq("global", tech, new_tech)
    end

    ---Removes a prerequisite from a technology
    ---@param tech string|string[] The tech to remove the prerequisite from
    ---@param prereq string|string[] The prerequisite to remove
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
            utils:ensure_subtable(modifications.technology.prerequisites, tech)[prereq] = false
        end
    end

    ---Replaces a prerequisite of a technology
    ---@param tech string|string[] The tech to replace the prerequisite of
    ---@param old_prereq string|string[] The prerequisite to replace
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
            utils:ensure_subtable(modifications.technology.prerequisites, tech)[old_prereq] = new_prereq
        end
    end

    ---Removes a recipe unlock from a technology
    ---@param tech string|string[] The tech to remove the recipe unlock from
    ---@param recipe string|string[] The recipe unlock to remove
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
            utils:ensure_subtable(modifications.technology.recipe_unlocks, tech)[recipe] = false
        end
    end

    ---Replaces a recipe unlock of a technology
    ---@param tech string|string[] The tech to replace the recipe unlock of
    ---@param old_recipe string|string[] The recipe unlock to replace
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
            utils:ensure_subtable(modifications.technology.recipe_unlocks, tech)[old_recipe] = new_recipe
        end
    end

    ---@class ItemOverrideFunctions
    local items = {}

    ---Hides an item
    ---@param item string|string[] The name of the item
    function items:hide(item)
        if type(item) == "table" then
            for _, i in pairs(item) do
                self:hide(i)
            end
        else
            if angelsmods and data.raw.fluid[item] then
                angelsmods.functions.disable_barreling_recipes(item)
            end

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

    ---@class OverrideFunctions
    ---@field recipes RecipeOverrideFunctions
    ---@field technologies TechnologyOverrideFunctions
    ---@field items ItemOverrideFunctions
    local overrides = {
        recipes = recipes,
        technologies = technologies,
        items = items
    }

    return overrides
end


local function process_recipe_ingredients(name, ingredient_mods, ingredients)
    if utils:contains(ingredients, function (value, _)
        local name = value.name or value[1]
        return utils:contains(ingredient_mods, function (_, key)
            return key == name
        end)
    end) then
        local patches = {}
        for old, new in pairs(ingredient_mods) do
            table.insert(patches, {
                new, "! " .. old
            })
        end
        set_patch(name, {
            name = name,
            ingredients = patches
        })
    end
end

local function process_recipe(recipe_name, recipe)
    local ingredient_mods = modifications.recipe.ingredients
    if ingredient_mods then
        if recipe.normal or recipe.expensive then
            if recipe.normal then
                process_recipe_ingredients(recipe_name, ingredient_mods, recipe.normal.ingredients)
            end
            if recipe.expensive then
                process_recipe_ingredients(recipe_name, ingredient_mods, recipe.expensive.ingredients)
            end
        else
            process_recipe_ingredients(recipe_name, ingredient_mods, recipe.ingredients)
        end
    end
end

local function process_tech(tech_name, tech)
    if modifications.technology.removals[tech_name] then
        tech.enabled = false
    end

    local prereq_mods = modifications.technology.prerequisites[tech_name]
    local global_prereq_mods = modifications.technology.prerequisites.global
    if prereq_mods or global_prereq_mods then
        local to_remove = {}
        for key, prereq in pairs(tech.prerequisites) do
            local new = prereq
            while prereq_mods[new] ~= nil or global_prereq_mods[new ~= nil] do
                if prereq_mods[new] ~= nil then
                    new = prereq_mods[new]
                else
                    new = global_prereq_mods[new]
                end
            end
            if not new or modifications.technology.removals[new] then
                to_remove[key] = true
            elseif new ~= prereq then
                tech.prerequisites[key] = new
            end
        end
        utils:remove_from_table(tech.prerequisites, to_remove)
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
                if not new or (modifications.recipe.patches[new] and not modifications.recipe.patches[new].enabled) then
                    to_remove[key] = true
                elseif new ~= effect then
                    effect.recipe = new
                end
            end
        end
        utils:remove_from_table(tech.effects, to_remove)
    end
end


local function execute()
    for name, recipe in pairs(data.raw.recipe) do
        process_recipe(name, recipe)
    end

    for name, tech in pairs(data.raw.technology) do
        process_tech(name, tech)
    end

    arches.functions.recipes:patch(modifications.recipe.patches)
end

---Should only be called by archeslibpost in data-updates.lua
function arches.functions:execute_updates()
    log(serpent.block(modifications))

    execute()

    modifications.technology.removals = {}
    modifications.technology.prerequisites = {}
    modifications.technology.recipe_unlocks = {}
    modifications.recipe.patches = {}
    modifications.recipe.ingredients = {}
end

---Should only be called by archeslibpost in data-final-fixes.lua
function arches.functions:execute_final_fixes()
    log(serpent.block(modifications))

    execute()
end
