if not GLOBAL.IsInFrontEnd() then return end

-- local CHINESE_CODES = {
--     ["chs"] = "玻璃制品",
--     ["cht"] = "玻璃制品",
--     ["sc"]  = "玻璃制品",
--     ["zh"]  = "玻璃制品",
--     ["zht"] = "玻璃制品",
-- }

Assets = {}
PrefabFiles = {}

modimport("modmain") -- For API functions & mod env

modimport("main/prefabskin")
modimport("main/strings")
