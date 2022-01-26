if not GLOBAL.IsInFrontEnd() then return end

local CHINESE_CODES = {
    ["chs"] = true,
    ["cht"] = true,
    ["sc"]  = true,
    ["zh"]  = true,
    ["zht"] = true,
}

modimport("modmain") -- For API functions & mod env
Assets = { Asset("ANIM", "anim/glassic_rarities.zip") }

GlassicAPI.SkinHandler.SetRarity("Glassic", 0.1, { 40 / 255, 150 / 255, 128 / 255, 1 }, "glassic", "glassic_rarities")

GLOBAL.STRINGS.UI.RARITY.Glassic = CHINESE_CODES[GLOBAL.LanguageTranslator.defaultlang] and "玻璃制品" or "Glassic"
