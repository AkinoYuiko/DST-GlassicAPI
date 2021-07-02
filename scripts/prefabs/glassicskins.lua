local pref = {}

table.insert(pref, CreatePrefabSkin("goldenaxe_victorian", {
	base_prefab = "goldenaxe",
	type = "item",
    rarity = "Glassic",
    assets = {
        -- Asset("ANIM", "anim/swap_goldenaxe_victorian.zip"),
        Asset("ANIM", "anim/goldenaxe_victorian.zip"),
        Asset("INV_IMAGE", "goldenaxe_victorian"),
    },
    init_fn = function(inst)
        GlassicAPI.SetFloatData(inst, {sym_build = "goldenaxe_victorian", sym_name = "swap_goldenaxe"})
        GlassicAPI.BasicInitFn(inst, "goldenaxe_victorian", "goldenaxe_victorian", "goldenaxe_victorian", "swap_goldenaxe")
    end,
	skin_tags = { "GOLDENAXE", },
}))

table.insert(pref, CreatePrefabSkin("moonglassaxe_northern", {
	base_prefab = "moonglassaxe",
	type = "item",
    rarity = "Glassic",
    assets = {
        Asset("ANIM", "anim/glassaxe_northern.zip"),
        Asset("INV_IMAGE", "glassaxe_northern"),
    },
    init_fn = function(inst)
        GlassicAPI.SetFloatData(inst, {sym_build = "glassaxe_northern", sym_name = "swap_glassaxe", bank = "glassaxe"})
        moonglassaxe_init_fn(inst, "moonglassaxe_northern", "glassaxe_northern", "swap_glassaxe")
    end,
	skin_tags = { "MOONGLASSAXE", },
}))

table.insert(pref, CreatePrefabSkin("moonglassaxe_victorian", {
	base_prefab = "moonglassaxe",
	type = "item",
    rarity = "Glassic",
    assets = {
        Asset("ANIM", "anim/glassaxe_victorian.zip"),
        Asset("INV_IMAGE", "glassaxe_victorian"),
    },
    init_fn = function(inst)
        GlassicAPI.SetFloatData(inst, {sym_build = "glassaxe_victorian", sym_name = "swap_glassaxe", bank = "glassaxe"})
        moonglassaxe_init_fn(inst, "moonglassaxe_victorian", "glassaxe_victorian", "swap_glassaxe")
    end,
	skin_tags = { "MOONGLASSAXE", },
}))

table.insert(pref, CreatePrefabSkin("moonglasshammer_forge", {
	base_prefab = "moonglasshammer",
	type = "item",
    rarity = "Glassic",
    assets = {
        Asset("ANIM", "anim/glasshammer_forge.zip"),
        -- Asset("ANIM", "anim/swap_glasshammer_forge.zip"),
        Asset("INV_IMAGE", "moonglasshammer_forge"),
    },
    init_fn = function(inst)
        GlassicAPI.SetFloatData(inst, {sym_build = "glasshammer_forge", sym_name = "swap_glasshammer", bank = "glasshammer"})
        moonglasshammer_init_fn(inst, "moonglasshammer_forge", "glasshammer_forge")
    end,
	skin_tags = { "MOONGLASSHAMMER", },
}))

table.insert(pref, CreatePrefabSkin("moonglasspickaxe_northern", {
	base_prefab = "moonglasspickaxe",
	type = "item",
    rarity = "Glassic",
    assets = {
        Asset("ANIM", "anim/glasspickaxe_northern.zip"),
        Asset("INV_IMAGE", "moonglasspickaxe_northern"),
    },
    init_fn = function(inst)
        GlassicAPI.SetFloatData(inst, {sym_build = "glasspickaxe_northern", sym_name = "swap_glasspickaxe", bank = "glasspickaxe"})
        moonglasspickaxe_init_fn(inst, "moonglasspickaxe_northern", "glasspickaxe_northern")
    end,
	skin_tags = { "MOONGLASSPICKAXE", },
}))

return unpack(pref)