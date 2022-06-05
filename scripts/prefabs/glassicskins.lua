local prefabs = {}

table.insert(prefabs, CreatePrefabSkin("goldenaxe_victorian", {
    base_prefab = "goldenaxe",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/goldenaxe_victorian.zip" ),
        Asset( "PKGREF", "anim/dynamic/goldenaxe_victorian.dyn" ),
    },
    init_fn = GlassicAPI.BasicInitFn,
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
    init_fn = GlassicAPI.BasicInitFn,
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
    init_fn = GlassicAPI.BasicInitFn,
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
    init_fn = GlassicAPI.BasicInitFn,
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
    init_fn = GlassicAPI.BasicInitFn,
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
    init_fn = GlassicAPI.BasicInitFn,
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
    init_fn = function(inst) glassiccutter_init_fn(inst, "glassiccutter_dream") end,
    skin_tags = { "GLASSICCUTTER", "GLASSIC" },

}))

table.insert(prefabs, CreatePrefabSkin("orangestaff_glass", {
    base_prefab = "orangestaff",
    type = "item",
    rarity = "Glassic",
    assets = {
        Asset( "DYNAMIC_ANIM", "anim/dynamic/orangestaff_glass.zip" ),
        Asset( "PKGREF", "anim/dynamic/orangestaff_glass.dyn" ),
    },
    init_fn = glassic_orangestaff_init_fn,
    skin_sound = { "dontstarve/common/gem_shatter", "", },
    fx_prefab = { "", "", "glash_fx", "glash_fx", },
    skin_tags = { "ORANGESTAFF", "GLASSIC" },
}))

return unpack(prefabs)
