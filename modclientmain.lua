local STRINGS, LanguageTranslator, TheNet = GLOBAL.STRINGS, GLOBAL.LanguageTranslator, GLOBAL.TheNet

if TheNet:GetIsClient() or TheNet:GetIsServer() then return end

modimport("modmain") -- For API functions & mod env

Assets = { Asset("ANIM", "anim/glassic_rarities.zip") }
GlassicAPI.SkinHandler.SetRarity("Glassic", 0.1, { 40 / 255, 150 / 255, 128 / 255, 1 }, "glassic", "glassic_rarities")

STRINGS.UI.RARITY.Glassic = table.contains({"zh", "chs", "cht"}, LanguageTranslator.defaultlang) and "玻璃制品" or "Glassic"
