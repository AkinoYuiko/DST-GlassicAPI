local pref = {}

table.insert(pref, CreatePrefabSkin("goldenaxe_victorian", {
	base_prefab = "goldenaxe",
	type = "item",
    rarity = "Glassic",
    assets = {
        Asset("ANIM", "anim/swap_goldenaxe_victorian.zip"),
        Asset("ANIM", "anim/goldenaxe_victorian.zip"),
        Asset("INV_IMAGE", "goldenaxe_victorian"),
    },
    init_fn = function(inst)
        GlassicAPI.SetFloatData(inst, {sym_build = "swap_goldenaxe_victorian", sym_name = "swap_goldenaxe"})
        GlassicAPI.BasicInitFn(inst, "goldenaxe_victorian", "swap_goldenaxe_victorian", "swap_goldenaxe")
    end,
	skin_tags = { "GOLDENAXE", },
}))

table.insert(pref, CreatePrefabSkin("moonglassaxe_northern", {
	base_prefab = "moonglassaxe",
	type = "item",
    rarity = "Glassic",
    assets = {
        Asset("ANIM", "anim/swap_glassaxe_northern.zip"),
        Asset("INV_IMAGE", "glassaxe_northern"),
    },
    init_fn = function(inst)
        inst.AnimState:SetBank("goldenaxe")
        GlassicAPI.SetFloatData(inst, {sym_build = "swap_moonglassaxe_northern", sym_name = "swap_goldenaxe",bank = "goldenaxe"})
        moonglassaxe_init_fn(inst, "moonglassaxe_northern", "swap_moonglassaxe_northern", "swap_goldenaxe")
    end,
	skin_tags = { "MOONGLASSAXE", },
}))

table.insert(pref, CreatePrefabSkin("moonglassaxe_victorian", {
	base_prefab = "moonglassaxe",
	type = "item",
    rarity = "Glassic",
    assets = {
        Asset("ANIM", "anim/swap_glassaxe_victorian.zip"),
        Asset("INV_IMAGE", "glassaxe_victorian"),
    },
    init_fn = function(inst)
        inst.AnimState:SetBank("axe")
        GlassicAPI.SetFloatData(inst, {sym_build = "swap_moonglassaxe_victorian", sym_name = "swap_axe",bank = "axe"})
        moonglassaxe_init_fn(inst, "moonglassaxe_victorian", "swap_moonglassaxe_victorian", "swap_axe")
    end,
	skin_tags = { "MOONGLASSAXE", },
}))

table.insert(pref, CreatePrefabSkin("moonglasshammer_forge", {
	base_prefab = "moonglasshammer",
	type = "item",
    rarity = "Glassic",
    assets = {
        Asset("ANIM", "anim/glasshammer_forge.zip"),
        Asset("ANIM", "anim/swap_glasshammer_forge.zip"),
        Asset("INV_IMAGE", "moonglasshammer_forge"),
    },
    init_fn = function(inst)
        GlassicAPI.SetFloatData(inst, {sym_build = "swap_glasshammer_forge", sym_name = "swap_glasshammer"})
        moonglasshammer_init_fn(inst, "moonglasshammer_forge", "glasshammer_forge") end,
	skin_tags = { "MOONGLASSHAMMER", },
}))

table.insert(pref, CreatePrefabSkin("moonglasspickaxe_northern", {
	base_prefab = "moonglasspickaxe",
	type = "item",
    rarity = "Glassic",
    assets = {
        Asset("ANIM", "anim/swap_glasspickaxe_northern.zip"),
        Asset("ANIM", "anim/glasspickaxe_northern.zip"),
        Asset("INV_IMAGE", "moonglasspickaxe_northern"),
    },
    init_fn = function(inst)
        inst.AnimState:SetBank("goldenpickaxe")
        GlassicAPI.SetFloatData(inst, {sym_build = "swap_moonglasspickaxe_northern", sym_name = "swap_goldenpickaxe",bank = "goldenpickaxe"})
        moonglasspickaxe_init_fn(inst, "moonglasspickaxe_northern", "moonglasspickaxe_northern", "swap_goldenpickaxe")
    end,
	skin_tags = { "MOONGLASSPICKAXE", },
}))

return unpack(pref)