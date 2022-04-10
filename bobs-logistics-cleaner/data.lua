arches = arches or {}
---@class BLCGlobals
arches.blc = arches.blc or {}
---@type table
arches.blc.triggers = arches.blc.triggers or {}

require("prototypes.settings")
arches.settings.triggers.read()

log(serpent.block(arches.blc.triggers))

require("prototypes.belts")
require("prototypes.inserters")
require("prototypes.roboports")
require("prototypes.robots")
require("prototypes.chests")
require("prototypes.pipes")
require("prototypes.pumps")
require("prototypes.trains")
require("prototypes.storage-tanks")
require("prototypes.repair-packs")