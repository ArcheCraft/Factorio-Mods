arches = arches or {}
arches.lib = arches.lib or {}
arches.lib.functions = arches.lib.functions or {}
arches.lib.settings = arches.lib.settings or {}

require("prototypes/data-triggers")

require("prototypes/arches-functions")
arches.lib.functions.RB = require("prototypes/recipe-builder")