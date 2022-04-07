arches = arches or {}
arches.blc = arches.blc or {}
arches.blc.triggers = arches.blc.triggers or {}

local settings = arches.settings.triggers:with(arches.blc.triggers, "blc")
settings:aggregating("belts", "a", "ultimate", {"none", "basic", "turbo", "ultimate"})
settings:aggregating("inserters", "c", "ultimate", {"none", "express", "turbo", "ultimate"})
settings:aggregating("roboports", "i", "mk4", {"none", "mk1", "mk2", "mk3", "mk4"})
settings:aggregating("robots", "h", "mk4", {"none", "mk1", "mk2", "mk3", "mk4"})
settings:aggregating("chests", "g", "mk3", {"none", "mk2", "mk3"})
settings:aggregating("pipes", "b", "plastic", {"none", "copper", "steel", "plastic"})
settings:aggregating("trains", "f", "mk3", {"none", "mk2", "mk3"})
settings:aggregating("pumps", "d", "mk4", {"none", "mk2", "mk3", "mk4"})
settings:aggregating("storage_tanks", "e", "mk4", {"none", "mk2", "mk3", "mk4"})
settings:aggregating("repair_packs", "j", "mk5", {"none", "mk2", "mk3", "mk4", "mk5"})
