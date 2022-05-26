if not GLOBAL.IsInFrontEnd() then return end

Assets = {}
PrefabFiles = {}

modimport("modmain") -- For API functions & mod env

modimport("main/prefabskin")
modimport("main/strings")
