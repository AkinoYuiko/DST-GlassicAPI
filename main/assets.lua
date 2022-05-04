modimport("main/tuning")
modimport("main/strings")

PrefabFiles = {
    "glassicflash",
    "glassicskins",
    "glassiccutter",
    "moonglasshammer",
    "moonglasspickaxe",
}

Assets = {
    Asset("ANIM", "anim/glassicrarities.zip"),
}

GlassicAPI.RegisterItemAtlas("ginventoryimages", Assets)
