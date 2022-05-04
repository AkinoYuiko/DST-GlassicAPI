if not GLOBAL.IsInFrontEnd() then return end

local CHINESE_CODES = {
    ["chs"] = "玻璃制品",
    ["cht"] = "玻璃制品",
    ["sc"]  = "玻璃制品",
    ["zh"]  = "玻璃制品",
    ["zht"] = "玻璃制品",
}

modimport("modmain") -- For API functions & mod env
Assets = { Asset("ANIM", "anim/glassicrarities.zip") }

GlassicAPI.SkinHandler.SetRarity("Glassic", 0.1, { 40 / 255, 150 / 255, 128 / 255, 1 }, "glassic", "glassic_rarities")

GLOBAL.STRINGS.UI.RARITY.Glassic = CHINESE_CODES[GLOBAL.LanguageTranslator.defaultlang] or "Glassic"
