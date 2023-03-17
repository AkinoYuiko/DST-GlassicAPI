if not GLOBAL.TheNet:GetServerGameMode() == "" then return end

Assets = {}
PrefabFiles = {}

modimport("modmain") -- For API functions & mod env

modimport("main/prefabskin")
modimport("main/strings")
