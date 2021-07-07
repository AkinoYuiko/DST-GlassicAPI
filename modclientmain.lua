if GLOBAL.TheNet:GetIsClient() or GLOBAL.TheNet:GetIsServer() then return end

modimport("modmain") -- For API functions & mod env

Assets = {
    Asset("ANIM", "anim/glassic_rarities.zip"),
}
GlassicAPI.SkinHandler.SetRarity("Glassic", 0.1, { 40 / 255, 150 / 255, 128 / 255, 1 }, "glassic", "glassic_rarities")

if table.contains({"zh", "chs", "cht"}, GLOBAL.LanguageTranslator.defaultlang) then
    GLOBAL.STRINGS.UI.RARITY.Glassic = "玻璃制品"
else
    GLOBAL.STRINGS.UI.RARITY.Glassic = "Glassic"
end
