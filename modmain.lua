local ENV = env
GLOBAL.setfenv(1, GLOBAL)

GlassicAPI = {}

GlassicAPI.SkinHandler = require "skinhandler"

local SLAXML = require "slaxml"
GlassicAPI.RegisterItemAtlas = function(path_to_file, assets_table)
    path_to_file = resolvefilepath("images/"..(path_to_file:find(".xml") and path_to_file or path_to_file..".xml"))

    local images = {}
    local file = io.open(path_to_file, "r")
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
        table.insert(assets_table, Asset("ATLAS", path_to_file))
        table.insert(assets_table, Asset("ATLAS_BUILD", path_to_file, 256))
    end

    for _, image in ipairs(images) do
        RegisterInventoryItemAtlas(path_to_file, image)
        RegisterInventoryItemAtlas(path_to_file, hash(image))
    end
end

GlassicAPI.InitCharacterAssets = function(char_name, char_gender, assets_table, has_crafting_menu)
    table.insert(assets_table, Asset("ATLAS", "bigportraits/"..char_name..".xml"))
    table.insert(assets_table, Asset("ATLAS", "bigportraits/"..char_name.."_none.xml"))
    table.insert(assets_table, Asset("ATLAS", "images/names_"..char_name..".xml"))
    table.insert(assets_table, Asset("ATLAS", "images/avatars/avatar_"..char_name..".xml"))
    table.insert(assets_table, Asset("ATLAS", "images/avatars/avatar_ghost_"..char_name..".xml"))
    table.insert(assets_table, Asset("ATLAS", "images/avatars/self_inspect_"..char_name..".xml"))
    table.insert(assets_table, Asset("ATLAS", "images/saveslot_portraits/"..char_name..".xml"))
    if has_crafting_menu then
        table.insert(assets_table, Asset("ATLAS", "images/crafting_menu_avatars/avatar_"..char_name..".xml"))
    end

    ENV.AddModCharacter(char_name, char_gender)
end

GlassicAPI.InitMinimapAtlas = function(path_to_file, assets_table)
    local file = "images/"..path_to_file..".xml"
    if assets_table then
        table.insert(assets_table, Asset("ATLAS", file))
    end
    ENV.AddMinimapAtlas(file)
end

GlassicAPI.SetExclusiveToPlayer = function(name)
    return function(player)
        return not player or player.prefab == name
    end
end

GlassicAPI.SetExclusiveToPlayers = function(table)
    return function(player)
        return not player or table.contains(table, player.prefab)
    end
end

GlassicAPI.SetExclusiveToTag = function(tag)
    return function(player)
        return not player or player:HasTag(tag)
    end
end

GlassicAPI.SetFloatData = function(inst, swap_data)
    if inst.components.floater and swap_data then
        inst.components.floater.swap_data = swap_data
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

GlassicAPI.BasicOnequipFn = function(inst, slot, build, symbol)

    local function onequiphandfn(inst, data)
        data.owner.AnimState:OverrideSymbol("swap_object", build, symbol)
    end

    local function onequipbodyfn(inst, data)
        data.owner.AnimState:OverrideSymbol("swap_body", build, "swap_body")
    end

    local function onequiphatfn(inst, data)
        data.owner.AnimState:OverrideSymbol("swap_hat", build, "swap_hat")
    end

    if not TheWorld.ismastersim then return end
    -- if not GLOBAL.TheWorld.ismastersim then return end

    local onequipfn = ( slot == "hand" and onequiphandfn )
                        or ( slot == "body" and onequipbodyfn )
                        or ( slot == "hat" and onequiphatfn )
                        or nil
    inst:ListenForEvent("equipped", onequipfn)
    if slot == "hand" then
        inst:ListenForEvent("stoprowing", onequiphandfn) -- IA compatible after stopping rowing.
    end
    inst.OnReskinFn = function(inst)
        inst:RemoveEventCallback("equipped", onequipfn)
        inst:RemoveEventCallback("stoprowing", onequiphandfn) -- IA compatible after stopping rowing.
    end
end

GlassicAPI.BasicInitFn = function(inst, skinname, override_build)

    if inst.components.placer == nil and not TheWorld.ismastersim then return end
    -- if inst.components.placer == nil and not GLOBAL.TheWorld.ismastersim then return end

    inst.skinname = skinname
    inst.AnimState:SetBuild(override_build or skinname)

    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
    end

    if inst.components.floater then
        if inst.components.floater:IsFloating() then
            inst.components.floater:SwitchToDefaultAnim(true)
            inst.components.floater:SwitchToFloatAnim()
        end
    end

end

GlassicAPI.ShellComponent = Class(function(self, inst)
    self.inst = inst
end)

GlassicAPI.SortRecipeToTarget = function(filter_name, prefab, target, pre_target)
    local filter = CRAFTING_FILTERS[filter_name]
    if filter then
        local RECIPES_KEYS = table.invert(filter.recipes)
        local target_sort = RECIPES_KEYS[target]
        if target_sort then
            local old_sort = RECIPES_KEYS[prefab]
            local new_sort = target_sort + (pre_target and 0 or 1)

            if old_sort then
                table.insert(filter.recipes, new_sort, table.remove(filter.recipes, old_sort))
            else
                table.insert(filter.recipes, new_sort, prefab)
            end
        end
        filter.default_sort_values = table.invert(filter.recipes)
    end
end

local function merge_internal(target, strings, no_override)
    for _, k, v in sorted_pairs(strings) do
        if type(v) == "table" then
            if not target[k] then
                target[k] = {}
            end
            merge_internal(target[k], v, no_override)
        else
            if not (no_override and target[k] ~= nil) then
                target[k] = v
            end
        end
    end
end
GlassicAPI.MergeStringsToGLOBAL = function(strings, custom_field, no_override)
    merge_internal(custom_field or STRINGS, strings, no_override)
end

local CHINESE_CODES = {
    zh = "chinese_s", -- Simplified Chinese
    zht = "chinese_t", -- Traditional Chinese
    chs = "chinese_s", -- Chinese Mod (workshop 367546858)
    cht = "chinese_t",
    sc = "chinese_s" ,
}
GlassicAPI.MergeTranslationFromPO = function(base_path, override_lang)
    local _defaultlang = LanguageTranslator.defaultlang
    local lang = override_lang or _defaultlang
    if not CHINESE_CODES[lang] then return end
    local filepath = base_path.."/"..CHINESE_CODES[lang]..".po"
    if not resolvefilepath_soft(filepath) then
        print("Could not find a language file matching "..filepath.." in any of the search paths.")
        return
    end
    LanguageTranslator:LoadPOFile(filepath, lang.."_temp")
    TranslateStringTable(STRINGS)
    LanguageTranslator.languages[lang.."_temp"] = nil
    LanguageTranslator.defaultlang = _defaultlang
end

-- Basically LanguageTranslator.ConvertEscapeCharactersToString, but replace "\"s first
GlassicAPI.ConvertEscapeCharactersToString = function(str)
    local newstr = string.gsub(str, "\\", "\\\\")
    newstr = string.gsub(newstr, "\n", "\\n")
    newstr = string.gsub(newstr, "\r", "\\r")
    newstr = string.gsub(newstr, "\"", "\\\"")

    return newstr
end

local function write_speech(file, base_strings, strings, indent)
    indent = indent or 1
    local str = ""
    for i = 1, indent do
        str = str .. "\t"
    end
    for _, k, v in sorted_pairs(strings) do
        if type(v) == "table" then
            file:write(str .. k .. " =\n" .. str .. "{\n")
            write_speech(file, base_strings and base_strings[k], v, indent + 1)
            file:write(str .. "}, \n")
        else
            local comment = base_strings and base_strings[k] and "" or "-- "
            v = GlassicAPI.ConvertEscapeCharactersToString(v)
            if tonumber(k) then
                file:write(str .. comment .. "\"" .. v .. "\", \n" )
            else
                file:write(str .. comment .. k .. " = \"" .. v .. "\", \n" )
            end
        end
    end
end
GlassicAPI.MergeSpeechFile = function(base_strings, file, source)
    local speech = require(source or "speech_wilson")
    file:write("return {\n")
    merge_internal(speech, base_strings)
    write_speech(file, base_strings, speech)
    file:write("}")
    file:write("\n")
    file:close()
end

local function write_for_strings(base, data, file)
    for _, k, v in sorted_pairs(data) do
        local path = base.."."..k
        if type(v) == "table" then
            write_for_strings(path, v, file)
        else
            file:write('\n')
            file:write('#. '..path..'\n')
            file:write('msgctxt "'..path..'"\n')
            file:write('msgid "'..GlassicAPI.ConvertEscapeCharactersToString(v)..'"\n')
            file:write('msgstr ""\n')
        end
    end
end
GlassicAPI.MakePOTFromStrings = function(file, strings)
    file:write("msgid \"\"\n")
    file:write("msgstr \"\"\n")
    file:write("\"Application: Dont' Starve\\n\"")
    file:write("\n")
    file:write("\"POT Version: 2.0\\n\"")
    file:write("\n")

    write_for_strings("STRINGS", strings, file)

    file:close()
end

local initialize_modmain = ModManager.InitializeModMain
ModManager.InitializeModMain = function(self, _modname, env, mainfile, ...)
    if mainfile == "modmain.lua" then
        env.GlassicAPI = GlassicAPI
    end
    return initialize_modmain(self, _modname, env, mainfile, ...)
end

-- GLOBAL.GlassicAPI = GlassicAPI
ENV.GlassicAPI = GlassicAPI

if ENV.is_mim_enabled then return end

local main_files = {
    "actions",
    "assets",
    "prefabskin",
    "recipes",
    "reskin_tool",
    "widgets",
}

for i = 1, #main_files do
    ENV.modimport("main/" .. main_files[i])
end

local CHINESE_CODES = {
    ["chs"] = "zh",
    ["cht"] = "zh",
    ["sc"]  = "zh",
    ["zh"]  = "zh",
    ["zht"] = "zh",
}

ENV.modimport("strings/" .. (CHINESE_CODES[LanguageTranslator.defaultlang] or "en"))
