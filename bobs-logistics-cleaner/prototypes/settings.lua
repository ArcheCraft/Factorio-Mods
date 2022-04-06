arches = arches or {}
arches.blc = arches.blc or {}
arches.blc.triggers = arches.blc.triggers or {}

local settings = arches.lib.settings.triggers:withTarget(arches.blc.triggers)
settings:aggregating("blc-belts", "a", "ultimate", {"none", "basic", "turbo", "ultimate"})
settings:aggregating("blc-inserters", "c", "ultimate", {"none", "express", "turbo", "ultimate"})
settings:aggregating("blc-roboports", "i", "mk4", {"none", "mk1", "mk2", "mk3", "mk4"})
settings:aggregating("blc-robots", "h", "mk4", {"none", "mk1", "mk2", "mk3", "mk4"})
settings:aggregating("blc-chests", "g", "mk3", {"none", "mk2", "mk3"})
settings:aggregating("blc-pipes", "b", "plastic", {"none", "copper", "steel", "plastic"})
settings:aggregating("blc-trains", "f", "mk3", {"none", "mk2", "mk3"})
settings:aggregating("blc-pumps", "d", "mk4", {"none", "mk2", "mk3", "mk4"})
settings:aggregating("blc-storage-tanks", "e", "mk4", {"none", "mk2", "mk3", "mk4"})
settings:aggregating("blc-repair-packs", "j", "mk5", {"none", "mk2", "mk3", "mk4", "mk5"})
