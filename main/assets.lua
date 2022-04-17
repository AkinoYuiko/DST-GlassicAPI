local CHINESE_CODES = {
    ["zh"]  = "zh",
    ["zht"] = "zh",
    ["chs"] = "zh",
    ["cht"] = "zh",
    ["sc"]  = "zh",
}

modimport("strings/" .. (CHINESE_CODES[GLOBAL.LanguageTranslator.defaultlang] or "en"))
modimport("main/tuning")

PrefabFiles = {
    "glassicflash",
    "glassicskins",
    "glassiccutter",
    "moonglasshammer",
    "moonglasspickaxe",
}

Assets = {
    Asset("ANIM", "anim/glassic_rarities.zip"),
}

GlassicAPI.RegisterItemAtlas("ga_inventoryimages", Assets)
