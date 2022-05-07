local ENV = env
GLOBAL.setfenv(1, GLOBAL)

GlassicAPI = {}

------------------------------------------------------------------------------------------------------------
-- SkinHandler helps you create skins quickly.
GlassicAPI.SkinHandler = require "skinhandler"
------------------------------------------------------------------------------------------------------------

-- RegisterItemAtlas helps you register inventory item atlas, so you don't need to specify each mod prefab's inventory image and atlas
-- It's suitable for a atlas that contains mulitiple images.
-- The root folder is "MODROOT/images"
-- e.g. GlassicAPI.RegisterItemAtlas("inventoryimages") will import "MODROOT/images/inventoryimges.xml" and register every element inside.
-- set 'assets_table' to Assets.
---@param path_to_file string
---@param assets_table table
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

------------------------------------------------------------------------------------------------------------

-- InitCharacterAssets helps you init assets that a mod character needs.
-- e.g. GlassicAPI.InitCharacterAssets("civi", "male", Assets, true)
-- set 'assets_table' to Assets.
-- if your mod character has crafting menu icon, set 'has_crafting_menu' to true
---@param chat_name string
---@param gender string
---@param assets_table table
---@param has_crafting_menu boolean
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

------------------------------------------------------------------------------------------------------------

-- testfn for SkinHandler, try on your own.
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

------------------------------------------------------------------------------------------------------------

-- use in skins' initfn most.
-- before basic init, you need to specify skins' floating swap_data to make the anim switch looks normal.
---@param swap_data table
GlassicAPI.SetFloatData = function(inst, swap_data)
    if inst.components.floater and swap_data then
        inst.components.floater.swap_data = swap_data
    end
end

-- used to fix reskin issue on official skinned items. now it's less necessary to use.
---@param base_fn function
---@return function
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

------------------------------------------------------------------------------------------------------------

-- one of the main init fn that equippable skinned items require.
-- for equippable items, you need to set BasicOnequipFn to override symbols when you equip your skinned item.
-- e.g. GlassicAPI.BasicOnequipFn(inst, "hat", "alterguardianhat_nope")
-- e.g. GlassicAPI.BasicOnequipFn(inst, "hand", "glasscutter_angri", "swap_glasscutter")
---@param slot string
---@param build string
---@param override_symbol string
---if slot is "hand". override_build needs specified.
GlassicAPI.BasicOnequipFn = function(inst, slot, build, override_symbol)
    local onequipfns =
    {
        hand = function(inst, data) data.owner.AnimState:OverrideSymbol("swap_object", build, override_symbol) end,
        body = function(inst, data) data.owner.AnimState:OverrideSymbol("swap_body", build, "swap_body") end,
        hat = function(inst, data) data.owner.AnimState:OverrideSymbol("swap_hat", build, "swap_hat") end,
    }
    if not TheWorld.ismastersim then return end

    local onequipfn = onequipfns[slot]
    inst:ListenForEvent("equipped", onequipfn)
    if slot == "hand" then
        inst:ListenForEvent("stoprowing", onequipfn)
    end
    inst.OnReskinFn = function(inst)
        inst:RemoveEventCallback("equipped", onequipfn)
        inst:RemoveEventCallback("stoprowing", onequipfn)
    end
end

-- main init fn that skinned items require.
-- e.g. GlassicAPI.BasicInitFn(inst, "cane_oops")
-- e.g. GlassicAPI.BasicInitFn(inst, "moonglasspickaxe_northern", "glasspickaxe_northern")
---@param skinname string
---@param override_build string
-- override_build is not required.
GlassicAPI.BasicInitFn = function(inst, skinname, override_build)
    if inst.components.placer == nil and not TheWorld.ismastersim then return end

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

-- all actions require component. to avoid compatibility issues, it's better that we use a new component to set actions.
-- GlassicAPI.ShellComponent helps you create such a component.
-- e.g. "scripts/components/glasssocket.lua"
-- usage: return GlassicAPI.ShellComponent
GlassicAPI.ShellComponent = Class(function(self, inst)
    self.inst = inst
end)

------------------------------------------------------------------------------------------------------------

local TechTree = require("techtree")
local function rebuild_techtree(name)
    TECH.NONE = TechTree.Create()

    for k, v in pairs(AllRecipes) do
        v.level = TechTree.Create(v.level)
    end

    for k, v in pairs(TUNING.PROTOTYPER_TREES) do
        v = TechTree.Create(v)
        TUNING.PROTOTYPER_TREES[k] = TUNING.PROTOTYPER_TREES[k] or {}
        TUNING.PROTOTYPER_TREES[k][name] = TUNING.PROTOTYPER_TREES[k][name] or 0
    end
end

-- custom tech may allows you to build custom prototyper or allows muliti prototypers to bonus a tech simultaneously.
-- e.g. GlassicAPI.AddTech("FRIENDSHIPRING")
---@param name string
GlassicAPI.AddTech = function(name)
    table.insert(TechTree.AVAILABLE_TECH, name)
    table.insert(TechTree.BONUS_TECH, name)
    rebuild_techtree(name)
end

-- e.g.
-- GlassicAPI.MergeTechBonus("MOONORB_UPGRADED", "FRIENDSHIPRING", 2)
-- GlassicAPI.MergeTechBonus("MOON_ALTAR_FULL", "FRIENDSHIPRING", 2)
-- GlassicAPI.MergeTechBonus("OBSIDIAN_BENCH", "FRIENDSHIPRING", 2)
-- allows muliti prototypers to bonus a tech simultaneously.
GlassicAPI.MergeTechBonus = function(target, name, level)
    scheduler:ExecuteInTime(0, function()
        if TUNING.PROTOTYPER_TREES[target] then
            TUNING.PROTOTYPER_TREES[target][name] = level
        end
    end)
end

------------------------------------------------------------------------------------------------------------

local function init_recipe_print(...)
    if KnownModIndex:IsModInitPrintEnabled() then
        print("Glassic API", ...)
    end
end

local add_recipe_to_filter = function(recipe_name, filter_name)
    init_recipe_print("AddRecipeToFilter", recipe_name)
    local filter = CRAFTING_FILTERS[filter_name]
    if filter ~= nil and filter.default_sort_values[recipe_name] == nil then
        table.insert(filter.recipes, recipe_name)
        filter.default_sort_values[recipe_name] = #filter.recipes
    end
end
-- a smarter way to add a mod recipe, and you don't need to think about filters too much.
-- also, with confog.hidden, you can set your recipe no searching or in "EVERYTHING" filter.
-- same format as AddRecipe2
GlassicAPI.AddRecipe = function(name, ingredients, tech, config, filters)
    init_recipe_print("AddRecipe", name)
    require("recipe")
    mod_protect_Recipe = false
    local rec = Recipe2(name, ingredients, tech, config)

    if not rec.is_deconstruction_recipe then

        if config and config.nounlock then
            add_recipe_to_filter(name, CRAFTING_FILTERS.CRAFTING_STATION.name)
        end

        if config and config.builder_tag and config.nochar == nil then
            add_recipe_to_filter(name, CRAFTING_FILTERS.CHARACTER.name)
        end

        if config and config.nomods == nil then
            add_recipe_to_filter(name, CRAFTING_FILTERS.MODS.name)
        end

        if config and config.hidden then
            GlassicAPI.RecipeNoSearch(name)
        end

        if filters then
            for _, filter_name in ipairs(filters) do
                add_recipe_to_filter(name, filter_name)
            end
        end
    end

    mod_protect_Recipe = true
    rec:SetModRPCID()
    return rec
end

------------------------------------------------------------------------------------------------------------

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

-- a quick way to sort recipes before or after current recipes.
---@param a string - the recipe name that you want to sort
---@param b string - the target recipe name that we base on.
---@param filter_type string
-- e.g. GlassicAPI.RecipeSortAfter("darkcrystal", "purplegem") will sort "darkcrystal" after "purplegem" in all filters that "purplegem" has.
-- e.g. GlassicAPI.RecipeSortAfter("darkcrystal", "purplegem", "MAGIC") will only sort "darkcrystal" after "purplegem" in "MAGIC" filter.
-- e.g. GlassicAPI.RecipeSortAfter("darkcrystal", "purplegem", "TOOLS") will only sort "darkcrystal" to the last in "TOOLS" because "purplegem" is not in "TOOLS".
-- one of b and filter_type must not be nil.
GlassicAPI.RecipeSortBefore = function(a, b, filter_type)
    try_sorting(a, b, filter_type, 0)
end

GlassicAPI.RecipeSortAfter = function(a, b, filter_type)
    try_sorting(a, b, filter_type, 1)
end

-- set a recipe not listed in search filter or "EVERYTHING".
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

------------------------------------------------------------------------------------------------------------

local function merge_internal(target, strings, no_override)
    for k, v in pairs(strings) do
        if type(v) == "table" then
            if type(target[k]) == "string" then
                if no_override then
                    error("MERGE PROTECTION: Can not merge a table to a string!")
                else
                    target[k] = {}
                end
            elseif not target[k] then
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

local CHS_CODES = {
    zh = "chinese_s", -- Simplified Chinese
    zht = "chinese_t", -- Traditional Chinese
    chs = "chinese_s", -- Chinese Mod (workshop 367546858)
    cht = "chinese_t",
    sc = "chinese_s",
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
    "containerwidgets",
    "prefabskin",
    "recipes",
    "reskin_tool",
}

for i = 1, #main_files do
    ENV.modimport("main/" .. main_files[i])
end
