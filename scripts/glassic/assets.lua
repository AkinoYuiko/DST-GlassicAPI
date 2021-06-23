PrefabFiles = { "glassicskins" }

Assets = {}
local assets_table = {
    "glassiccutter",
    "moonglasshammer",
    "moonglasspickaxe",
}

for _, v in ipairs(assets_table) do
    table.insert(PrefabFiles, v)
    table.insert(Assets, Asset("ATLAS", "images/inventoryimages/"..v..".xml"))
    table.insert(Assets, Asset("ATLAS_BUILD", "images/inventoryimages/"..v..".xml", 256))
end

local GlassicAPI = GLOBAL.GlassicAPI
GlassicAPI.RegisterAtlasFile("moonglasshammer")
GlassicAPI.RegisterAtlasFile("moonglasspickaxe")
GlassicAPI.RegisterAtlasFile("goldenaxe_victorian")
GlassicAPI.RegisterAtlasFile("moonglassaxe_northern")
GlassicAPI.RegisterAtlasFile("moonglassaxe_victorian")
GlassicAPI.RegisterAtlasFile("moonglasshammer_forge")
GlassicAPI.RegisterAtlasFile("moonglasspickaxe_northern")
GlassicAPI.RegisterAtlasFile("glassiccutter")