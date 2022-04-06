arches.lib.functions.items = {}

function arches.lib.functions.items:remove_item(item, replace)
    
end

function arches.lib.functions.items:hide(type, item)
    if type == "fluid" then
        data.raw[type][item].hidden = true
    elseif type == "item" then
        if angelsmods then
            angelsmods.functions.add_flag(item, "hidden")
        end
    end
end


arches.lib.functions.recipes = {}

local recipe_removals = {
    all = {}
}

local recipe_enables = {}

function arches.lib.functions.recipes:remove(recipe)
    recipe_removals.all[recipe] = true
end

function arches.lib.functions.recipes:enable(recipe)
    recipe_enables[recipe] = true
end


arches.lib.functions.technology = {}

local technology_replacements = {
    prerequisites = {}
}

local technology_removals = {
    prerequisites = {},
    recipe_unlocks = {},
    all = {}
}

function arches.lib.functions.technology:replace_prerequisite(tech, old_prereq, new_prereq)
    local res = technology_replacements.prerequisites[tech] or {}
    res[old_prereq] = new_prereq
    technology_replacements.prerequisites[tech] = res
end

function arches.lib.functions.technology:remove_prerequisite(tech, prereq)
    if type(prereq) == "table" then
        for _, v in pairs(prereq) do
            self:remove_prerequisite(tech, v)
        end
    else
        local res = technology_removals.prerequisites[tech] or {}
        res[prereq] = true
        technology_removals.prerequisites[tech] = res
    end
end

function arches.lib.functions.technology:remove_recipe_unlock(tech, unlock)
    if type(unlock) == "table" then
        for _, v in pairs(unlock) do
            self:remove_recipe_unlock(tech, v)
        end
    else
        local res = technology_removals.recipe_unlocks[tech] or {}
        res[unlock] = true
        technology_removals.recipe_unlocks[tech] = res
    end
end

function arches.lib.functions.technology:remove(tech)
    technology_removals.all[tech] = true
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

local function remove_from_table(target, to_remove)
    for key = #target, 1, -1 do
        if to_remove[key] then
            table.remove(target, key)
        end
    end
end


local function execute_recipe(recipe_name, recipe)
    if recipe_removals.all[recipe_name] then
        recipe.enabled = false
        if recipe.normal then
            recipe.normal.enabled = false
        end
        if recipe.expensive then
            recipe.expensive.enabled = false
        end
    elseif recipe_enables[recipe_name] then
        recipe.enabled = true
        if recipe.normal then
            recipe.normal.enabled = true
        end
        if recipe.expensive then
            recipe.expensive.enabled = true
        end
    end
end

local function execute_tech(tech_name, tech)
    if technology_removals.all[tech_name] then
        tech.enabled = false
    end

    if technology_removals.recipe_unlocks[tech] then
        local to_remove = {}
        for key, effect in pairs(tech.effect) do
            if effect.type == "unlock-recipe" then
                if technology_removals.recipe_unlocks[tech][effect.recipe] then
                    to_remove[key] = true
                end
            end
        end
        remove_from_table(tech.effects, to_remove)
    end

    if technology_removals.prerequisites[tech] then
        local to_remove = {}
        for key, prereq in pairs(tech.prerequisites) do
            local new = technology_replacements.prerequisites[tech][prereq]
            if new then
                tech.prerequisites[key] = new
            end
            if technology_removals.prerequisites[tech][prereq] or technology_removals.all[prereq] then
                to_remove[key] = true
            end
        end
        remove_from_table(tech.prerequisites, to_remove)
    end
end

---Executed by 'archeslibpost' in data-final-fixes.lua
function arches.lib.functions:execute()
    for name, recipe in pairs(data.raw.recipe) do
        execute_recipe(name, recipe)
    end

    for name, tech in pairs(data.raw.technology) do
        execute_tech(name, tech)
    end
end
