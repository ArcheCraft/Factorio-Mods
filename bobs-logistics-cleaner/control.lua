script.on_configuration_changed(function ()
    local techs_to_enable = {
        "logistics-0", "logistics-4", "logistics-5",
        "logistic-system-2", "logistic-system-3",
        "express-inserters", "turbo-inserter", "ultimate-inserter",
        "stack-inserter-2", "stack-inserter-3", "stack-inserter-4",
        "bob-robo-modular-1", "bob-robo-modular-2", "bob-robo-modular-3", "bob-robo-modular-4",
        "bob-robots-1", "bob-robots-2", "bob-robots-3", "bob-robots-4",
        "bob-fluid-handling-2", "bob-fluid-handling-3", "bob-fluid-handling-4",
        "bob-armoured-fluid-wagon", "bob-armoured-railway", "bob-fluid-wagon-2", "bob-railway-2",
        "bob-armoured-fluid-wagon-2", "bob-armoured-railway-2", "bob-fluid-wagon-3", "bob-railway-3",
        "bob-repair-pack-2", "bob-repair-pack-3", "bob-repair-pack-4", "bob-repair-pack-5"
    }

    local recipes_to_enable = {
        "transport-belt", "basic-transport-belt",
        "stone-pipe", "stone-pipe-to-ground", "copper-pipe", "copper-pipe-to-ground",
        "steam-inserter"
    }

    for _, force in pairs(game.forces) do
        force.reset_recipes()
        force.reset_technologies()

        for _, tech in pairs(techs_to_enable) do
            if force.technologies[tech] then
                force.technologies[tech].enabled = game.technology_prototypes[tech].enabled
            end
        end

        for _, recipe in pairs(recipes_to_enable) do
            if force.recipes[recipe] then
                force.recipes[recipe].enabled = game.recipe_prototypes[recipe].enabled
            end
        end

        force.reset_technology_effects()
    end
end)