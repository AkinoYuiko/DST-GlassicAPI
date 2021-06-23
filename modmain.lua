local GlassicAPI = {}

GlassicAPI.SkinHandler = require("skinhandler")

local SLAXML = require("slaxml")
GlassicAPI.RegisterAtlasFile = function(filename, is_full_path, should_hash)
    if not is_full_path then
        filename = GLOBAL.resolvefilepath("images/inventoryimages/"..(filename:find(".xml") and filename or filename..".xml"))
    end
    local images = {}
    local file = GLOBAL.io.open(filename, "r")
    local parser = SLAXML:parser({
        attribute = function(name, value)
            if name == "name" then
                table.insert(images, value)
            end
        end
    })
    parser:parse(file:read("*a"))
    file:close()

    for _, image in ipairs(images) do
        print(image)
        RegisterInventoryItemAtlas(filename, image)
        if should_hash ~= false then
            RegisterInventoryItemAtlas(filename, GLOBAL.hash(image))
        end
    end
end

GlassicAPI.RegisterAtlas = function(atlas, image, should_hash)
    -- if not prefab then return end
    RegisterInventoryItemAtlas(GLOBAL.resolvefilepath("images/inventoryimages/"..atlas..".xml"), (image ~= nil and image or atlas)..".tex")
    if should_hash then
        RegisterInventoryItemAtlas(GLOBAL.resolvefilepath("images/inventoryimages/"..atlas..".xml"), GLOBAL.hash((image ~= nil and image or atlas)..".tex"))
    end
end

GlassicAPI.SetExclusiveToPlayer = function(player, name)
    return not player or player.prefab == name
end

GlassicAPI.SetFloatData = function(inst, data)
    if inst.components.floater then
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
    return GLOBAL.unpack(ret)
end

GlassicAPI.BasicInitFn = function(inst, skin_name, build_name, sym_build, sym_name)
    
    if inst.components.placer == nil and not GLOBAL.TheWorld.ismastersim then return end

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

local create_env = GLOBAL.CreateEnvironment
GLOBAL.CreateEnvironment = function(...)
    local env = create_env(...)
    env.GlassicAPI = GlassicAPI
    return env
end
GLOBAL.GlassicAPI = GlassicAPI

modimport("scripts/glassic/assets.lua")
modimport("scripts/glassic/actions.lua")
modimport("scripts/glassic/recipes.lua")
modimport("scripts/glassic/widgets.lua")
modimport("scripts/glassic/prefabskin.lua")

modimport("strings/"..(table.contains({"zh","chs","cht"}, GLOBAL.LanguageTranslator.defaultlang) and "zh" or "en")..".lua")