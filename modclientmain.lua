if GLOBAL.TheNet:GetIsClient() or GLOBAL.TheNet:GetIsServer() then return end

modimport("modmain")

GlassicAPI.SkinHandler.SetRarity("Glassic", 0.1, { 40 / 255, 150 / 255, 128 / 255, 1 }, "reward")

local STRINGS = GLOBAL.STRINGS
if table.contains({"zh", "chs", "cht"}, GLOBAL.LanguageTranslator.defaultlang) then
    STRINGS.UI.RARITY.Glassic = "玻璃制品"
else
    STRINGS.UI.RARITY.Glassic = "Glassic"
end
