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
    skin_tags = { "GOLDENAXE", "VICTORIAN" },
}))

table.insert(prefabs, CreatePrefabSkin("cane_glass", {
    base_prefab = "cane",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/cane_glass.zip" ),
        Asset( "PKGREF", "anim/dynamic/cane_glass.dyn" ),
    },
    init_fn = function(inst)
        GlassicAPI.SetFloatData(inst, {sym_build = "cane_glass", sym_name = "swap_cane"})
        GlassicAPI.BasicInitFn(inst, "cane_glass")
    end,
    skin_tags = { "CANE", "GLASSIC" },
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
        GlassicAPI.BasicInitFn(inst, "moonglassaxe_northern")
    end,
    build_name_override = "glassaxe_northern",
    skin_tags = { "MOONGLASSAXE", "GLASSIC" },
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
        GlassicAPI.BasicInitFn(inst, "moonglassaxe_victorian")
    end,
    build_name_override = "glassaxe_victorian",
    skin_tags = { "MOONGLASSAXE", "GLASSIC" },
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
        GlassicAPI.BasicInitFn(inst, "moonglasshammer_forge")
    end,
    build_name_override = "glasshammer_forge",
    skin_tags = { "MOONGLASSHAMMER", "GLASSIC" },
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
        GlassicAPI.BasicInitFn(inst, "moonglasspickaxe_northern")
    end,
    build_name_override = "glasspickaxe_northern",
    skin_tags = { "MOONGLASSPICKAXE", "GLASSIC" },
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
    skin_tags = { "GLASSICCUTTER", "GLASSIC" },

}))

return unpack(prefabs)
