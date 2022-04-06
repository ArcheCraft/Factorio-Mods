local tech = data.raw.technology["angels-flare-stack"]
if angelsmods.industries and angelsmods.industries.tech then
    tech.unit.ingredients = {
        {"angels-science-pack-red", 1},
        {"datacore-processing-1", 2}
    }
else
    tech.unit.ingredients = {
        {"automation-science-pack", 1}
    }
end
tech.prerequisites = {"angels-fluid-control", "basic-chemistry-2"}
