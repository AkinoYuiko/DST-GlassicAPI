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
