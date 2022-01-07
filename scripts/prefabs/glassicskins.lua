local prefabs = {}

table.insert(prefabs, CreatePrefabSkin("goldenaxe_victorian", {
    base_prefab = "goldenaxe",
    type = "item",
    rarity = "Glassic",
    assets = {
    Asset( "DYNAMIC_ANIM", "anim/dynamic/goldenaxe_victorian.zip" ),
    Asset( "PKGREF", "anim/dynamic/goldenaxe_victorian.dyn" ),
    },
    init_fn = function(inst)
        GlassicAPI.SetFloatData(inst, {sym_build = "goldenaxe_victorian", sym_name = "swap_goldenaxe"})
        GlassicAPI.BasicInitFn(inst, "goldenaxe_victorian")
    end,
    skin_tags = { "GOLDENAXE" },
}))

table.insert(prefabs, CreatePrefabSkin("moonglassaxe_northern", {
    base_prefab = "moonglassaxe",
    type = "item",
    rarity = "Glassic",
    assets = {
    Asset( "DYNAMIC_ANIM", "anim/dynamic/glassaxe_northern.zip" ),
    Asset( "PKGREF", "anim/dynamic/glassaxe_northern.dyn" ),
    },
    init_fn = function(inst)
        GlassicAPI.SetFloatData(inst, {sym_build = "glassaxe_northern", sym_name = "swap_glassaxe", bank = "glassaxe"})
        ga_moonglassaxe_init_fn(inst, "moonglassaxe_northern", "glassaxe_northern")
    end,
    skin_tags = { "MOONGLASSAXE" },
}))

table.insert(prefabs, CreatePrefabSkin("moonglassaxe_victorian", {
    base_prefab = "moonglassaxe",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/glassaxe_victorian.zip" ),
        Asset( "PKGREF", "anim/dynamic/glassaxe_victorian.dyn" ),
    },
    init_fn = function(inst)
        GlassicAPI.SetFloatData(inst, {sym_build = "glassaxe_victorian", sym_name = "swap_glassaxe", bank = "glassaxe"})
        ga_moonglassaxe_init_fn(inst, "moonglassaxe_victorian", "glassaxe_victorian")
    end,
    skin_tags = { "MOONGLASSAXE" },
}))

table.insert(prefabs, CreatePrefabSkin("moonglasshammer_forge", {
    base_prefab = "moonglasshammer",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/glasshammer_forge.zip" ),
        Asset( "PKGREF", "anim/dynamic/glasshammer_forge.dyn" ),
    },
    init_fn = function(inst)
        GlassicAPI.SetFloatData(inst, {sym_build = "glasshammer_forge", sym_name = "swap_glasshammer", bank = "glasshammer"})
        moonglasshammer_init_fn(inst, "moonglasshammer_forge", "glasshammer_forge")
    end,
    skin_tags = { "MOONGLASSHAMMER" },
}))

table.insert(prefabs, CreatePrefabSkin("moonglasspickaxe_northern", {
    base_prefab = "moonglasspickaxe",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/glasspickaxe_northern.zip" ),
        Asset( "PKGREF", "anim/dynamic/glasspickaxe_northern.dyn" ),
    },
    init_fn = function(inst)
        GlassicAPI.SetFloatData(inst, {sym_build = "glasspickaxe_northern", sym_name = "swap_glasspickaxe", bank = "glasspickaxe"})
        moonglasspickaxe_init_fn(inst, "moonglasspickaxe_northern", "glasspickaxe_northern")
    end,
    skin_tags = { "MOONGLASSPICKAXE" },
}))


table.insert(prefabs, CreatePrefabSkin("glassiccutter_dream", {
    base_prefab = "glassiccutter",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/glassiccutter_dream.zip" ),
        Asset( "PKGREF", "anim/dynamic/glassiccutter_dream.dyn" ),
    },
    init_fn = function(inst)
        glassiccutter_init_fn(inst, "glassiccutter_dream")
    end,
    skin_tags = { "GLASSICCUTTER" },

}))

return unpack(prefabs)
