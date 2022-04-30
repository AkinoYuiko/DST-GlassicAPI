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

    local floater = inst.components.floater
    if floater and floater:IsFloating() and not (floater.wateranim or floater.landanim) then
        floater:SwitchToDefaultAnim(true)
        floater:SwitchToFloatAnim()
    end

end

GlassicAPI.ShellComponent = Class(function(self, inst)
    self.inst = inst
end)

local function init_recipe_print(...)
    if KnownModIndex:IsModInitPrintEnabled() then
        local modname = getfenvminfield(3, "modname")
        print(ModInfoname(modname), ...)
    end
end

GlassicAPI.AddTech = function(name)
    local TechTree = require("techtree")
    table.insert(TechTree.AVAILABLE_TECH, name)
    table.insert(TechTree.BONUS_TECH, name)

    for k in pairs(TUNING.PROTOTYPER_TREES) do
        TUNING.PROTOTYPER_TREES[k] = TUNING.PROTOTYPER_TREES[k] or {}
        TUNING.PROTOTYPER_TREES[k][name] = TUNING.PROTOTYPER_TREES[k][name] or 0
    end
end

GlassicAPI.MergeTechBonus = function(target, name, level)
    scheduler:ExecuteInTime(0, function()
        if TUNING.PROTOTYPER_TREES[target] then
            TUNING.PROTOTYPER_TREES[target][name] = level
        end
    end)
end

GlassicAPI.AddRecipe = function(name, ingredients, tech, config, filters)
    init_recipe_print("GlassicRecipe", name)
    require("recipe")
    mod_protect_Recipe = false
    local rec = Recipe2(name, ingredients, tech, config)

    if not rec.is_deconstruction_recipe then

        if config and config.nounlock then
            ENV.AddRecipeToFilter(name, CRAFTING_FILTERS.CRAFTING_STATION.name)
        end

        if config and config.builder_tag and config.nochar == nil then
			ENV.AddRecipeToFilter(name, CRAFTING_FILTERS.CHARACTER.name)
        end

        if config and config.nomods == nil then
			ENV.AddRecipeToFilter(name, CRAFTING_FILTERS.MODS.name)
        end

        if config and config.hidden then
			GlassicAPI.RecipeNoSearch(name)
        end

        if filters then
            for _, filter_name in ipairs(filters) do
                ENV.AddRecipeToFilter(name, filter_name)
            end
        end
    end

    mod_protect_Recipe = true
    rec:SetModRPCID()
    return rec
end

local function get_index(t, v)
    for index, value in pairs(t) do
        if value == v then
            return index
        end
    end
end

local function do_sorting(a, b, filter_name, offset, force_sort)
    local filter = CRAFTING_FILTERS[filter_name]
    if filter and filter.recipes and type(filter.recipes) == "table" then
        local target_position
        local recipes = filter.recipes
        if get_index(recipes, a) then
            if force_sort or table.contains(recipes, b) then
                recipes[get_index(recipes, a)] = nil
                target_position = #recipes + 1
            end
        end

        if get_index(recipes, b) then
            target_position = get_index(recipes, b) + offset
        end

        if type(target_position) == "number" then
            table.insert(recipes, target_position, a)
            filter.default_sort_values[a] = filter.default_sort_values[a] or #recipes
        end
    end
end

local function try_sorting(a, b, filter_type, offset)
    if filter_type then
        do_sorting(a, b, filter_type, offset, true)
    elseif b then
        for filter, data in pairs(CRAFTING_FILTERS) do
            do_sorting(a, b, filter, offset)
        end
    end
end

GlassicAPI.RecipeSortBefore =  function(a, b, filter_type)
    try_sorting(a, b, filter_type, 0)
end

GlassicAPI.RecipeSortAfter = function(a, b, filter_type)
    try_sorting(a, b, filter_type, 1)
end

GlassicAPI.RecipeNoSearch = function(recipe)
    local CraftingMenuWidget = require("widgets/redux/craftingmenu_widget")
    local is_recipe_valid_for_search = CraftingMenuWidget.IsRecipeValidForSearch
    function CraftingMenuWidget:IsRecipeValidForSearch(name)
        local ret = {is_recipe_valid_for_search(self, name)}
        if name == recipe then
            return
        end
        return unpack(ret)
    end
end

local function merge_internal(target, strings, no_override)
    for k, v in pairs(strings) do
        if type(v) == "table" then
            target[k] = target[k] or {}
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

local CHS_CODES = {
    zh = "chinese_s", -- Simplified Chinese
    zht = "chinese_t", -- Traditional Chinese
    chs = "chinese_s", -- Chinese Mod (workshop 367546858)
    cht = "chinese_t",
    sc = "chinese_s" ,
}
GlassicAPI.MergeTranslationFromPO = function(base_path, override_lang)
    local _defaultlang = LanguageTranslator.defaultlang
    local lang = override_lang or _defaultlang
    if not CHS_CODES[lang] then return end
    local filepath = base_path.."/"..CHS_CODES[lang]..".po"
    if not resolvefilepath_soft(filepath) then
        print("Could not find a language file matching "..filepath.." in any of the search paths.")
        return
    end
    local temp_lang = lang.."_temp"
    LanguageTranslator:LoadPOFile(filepath, temp_lang)
    merge_internal(LanguageTranslator.languages[lang], LanguageTranslator.languages[temp_lang])
    TranslateStringTable(STRINGS)
    LanguageTranslator.languages[temp_lang] = nil
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
    "assets",
    "actions",
    "prefabskin",
    "recipes",
    "reskin_tool",
    "containerwidgets",
}

for i = 1, #main_files do
    ENV.modimport("main/" .. main_files[i])
end
