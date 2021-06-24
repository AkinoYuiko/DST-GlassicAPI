local _G = GLOBAL
local unpack = _G.unpack

GlassicAPI = {}
GlassicAPI.SkinHandler = require("skinhandler")

local SLAXML = require("slaxml")
GlassicAPI.RegisterItemAtlas = function(path_to_file, assets_table)
    path_to_file = _G.resolvefilepath("images/"..(path_to_file:find(".xml") and path_to_file or path_to_file..".xml"))

    local images = {}
    local file = _G.io.open(path_to_file, "r")
    local parser = SLAXML:parser({
        attribute = function(name, value)
            if name == "name" then
                table.insert(images, value)
            end
        end
    })
    parser:parse(file:read("*a"))
    file:close()

    if assets_table then
        table.insert(assets_table, Asset( "ATLAS", path_to_file))
        table.insert(assets_table, Asset( "ATLAS_BUILD", path_to_file, 256))
    end

    for _, image in ipairs(images) do
        RegisterInventoryItemAtlas(path_to_file, image)
        RegisterInventoryItemAtlas(path_to_file, _G.hash(image))
    end
end

GlassicAPI.InitCharacterAssets = function(char_name, char_gender, assets_table)
    table.insert(assets_table, Asset( "ATLAS", "bigportraits/"..char_name.."_none.xml"))
    table.insert(assets_table, Asset( "ATLAS", "images/names_"..char_name..".xml"))
    table.insert(assets_table, Asset( "ATLAS", "images/avatars/avatar_"..char_name..".xml"))
    table.insert(assets_table, Asset( "ATLAS", "images/avatars/avatar_ghost_"..char_name..".xml"))
    table.insert(assets_table, Asset( "ATLAS", "images/avatars/self_inspect_"..char_name..".xml"))
    table.insert(assets_table, Asset( "ATLAS", "images/saveslot_portraits/"..char_name..".xml"))

    AddModCharacter(char_name, char_gender)
end

GlassicAPI.InitMinimapAtlas = function(path_to_file, assets_table)
    local file = "images/"..path_to_file..".xml"
    if assets_table then
        table.insert(assets_table, Asset( "ATLAS", file))
    end
    AddMinimapAtlas(file)
end

GlassicAPI.SetExclusiveToPlayer = function(player, name)
    return not player or player.prefab == name
end

GlassicAPI.SetExclusiveToTag = function(player, tag)
    return not player or player:HasTag(tag)
end

GlassicAPI.SetFloatData = function(inst, data)
    if inst.components.floater and data then
        inst.components.floater.swap_data = data
    end
end

GlassicAPI.PostInitFloater = function(inst, base_fn, ...)
    local ret = { base_fn(inst, ...) }
    if inst.components.floater then
        if inst.components.floater:IsFloating() then
            inst.components.floater:SwitchToDefaultAnim(true)
            inst.components.floater:SwitchToFloatAnim()
        end
    end
    return unpack(ret)
end

GlassicAPI.BasicInitFn = function(inst, skin_name, build_name, sym_build, sym_name)
    
    if inst.components.placer == nil and not _G.TheWorld.ismastersim then return end

    inst.skinname = skin_name
    inst.AnimState:SetBuild(build_name)

    if inst.components.inventoryitem ~= nil then
        inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
    end

    if inst.components.floater ~= nil then
        if inst.components.floater:IsFloating() then
            inst.components.floater:SwitchToDefaultAnim(true)
            inst.components.floater:SwitchToFloatAnim()
        end
    end

    local function onequipfn(inst, data)
        data.owner.AnimState:OverrideSymbol("swap_object", sym_build, sym_name)
    end

    inst:ListenForEvent("equipped", onequipfn)
    inst:ListenForEvent("stoprowing", onequipfn) -- IA compatible after stopping rowing.
    inst.OnSkinChange = function(inst) 
        inst:RemoveEventCallback("equipped", onequipfn)
        inst:RemoveEventCallback("stoprowing", onequipfn) -- IA compatible after stopping rowing.
    end
end

local initialize_modmain = _G.ModManager.InitializeModMain
_G.ModManager.InitializeModMain = function(self, _modname, env, mainfile, ...)
    if mainfile == "modmain.lua" then
        env.GlassicAPI = GlassicAPI
    end
    return initialize_modmain(self, _modname, env, mainfile, ...)
end
_G.GlassicAPI = GlassicAPI

modimport("scripts/glassic/assets.lua")
modimport("scripts/glassic/actions.lua")
modimport("scripts/glassic/recipes.lua")
modimport("scripts/glassic/widgets.lua")
modimport("scripts/glassic/prefabskin.lua")

modimport("strings/"..(table.contains({"zh","chs","cht"}, _G.LanguageTranslator.defaultlang) and "zh" or "en")..".lua")
