local _G = GLOBAL
local STRINGS = _G.STRINGS
local Translator = _G.LanguageTranslator
local unpack = _G.unpack
local tonumber = _G.tonumber
local io = _G.io

GlassicAPI = {}
GlassicAPI.SkinHandler = require("skinhandler")

local SLAXML = require("slaxml")
GlassicAPI.RegisterItemAtlas = function(path_to_file, assets_table)
    path_to_file = _G.resolvefilepath("images/"..(path_to_file:find(".xml") and path_to_file or path_to_file..".xml"))

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
        table.insert(assets_table, Asset( "ATLAS", path_to_file))
        table.insert(assets_table, Asset( "ATLAS_BUILD", path_to_file, 256))
    end

    for _, image in ipairs(images) do
        RegisterInventoryItemAtlas(path_to_file, image)
        RegisterInventoryItemAtlas(path_to_file, _G.hash(image))
    end
end

GlassicAPI.InitCharacterAssets = function(char_name, char_gender, assets_table)
    table.insert(assets_table, Asset( "ATLAS", "bigportraits/"..char_name..".xml"))
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

GlassicAPI.SetExclusiveToPlayer = function(name)
	return function(player)
		return not player or player.prefab == name
	end
end


GlassicAPI.SetExclusiveToTag = function(tag)
	return function(player)
	    return not player or player:HasTag(tag)
	end
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

local function merge_internal(target, strings, no_override)
    for k, v in pairs(strings) do
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

local _languages = {
	zh = "chinese_s", -- Chinese
	sc = "chinese_s", -- Simplified Chinese
    chs = "chinese_s", -- Chinese Mod (workshop 367546858)
}
GlassicAPI.MergeTranslationFromPO = function(base_path, override_lang)
    local _defaultlang = Translator.defaultlang
    local lang = override_lang or _defaultlang
    if not _languages[lang] then return end
    local filepath = base_path.."/".._languages[lang]..".po"
    if not _G.resolvefilepath_soft(filepath) then
        print("Could not find a language file matching "..filepath.." in any of the search paths.")
        return
    end
    Translator:LoadPOFile(filepath, lang.."_temp")
    _G.TranslateStringTable(STRINGS)
    Translator.languages[lang.."_temp"] = nil
    Translator.defaultlang = _defaultlang
end

local function write_speech(file, base_strings, strings, indent)
    indent = indent or 1
    local str = ""
    for i = 1, indent do
        str = str .. "\t"
    end
    for k, v in pairs(strings) do
        if type(v) == "table" then
            file:write(str .. k .. " =\n" .. str .. "{\n")
            write_speech(file, base_strings and base_strings[k], v, indent + 1)
            file:write(str .. "},\n")
        else
            local comment = base_strings and base_strings[k] and "" or "-- "
            v = Translator:ConvertEscapeCharactersToString(v)
            if tonumber(k) then
                file:write(str .. comment .. v .. "\",\n" )
            else
                file:write(str .. comment .. k .. " = \"" .. v .. "\",\n" )
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
    for k, v in pairs(data) do
        local path = base.."."..k
		if type(v) == "table" then
			write_for_strings(path, v, file)
        else
            file:write('#. '..path.."\n")
            file:write('msgctxt "'..path..'"\n')
            file:write('msgid "'..v..'"\n')
            file:write('msgstr ""\n\n')
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
	file:write("\n")

    write_for_strings("STRINGS", strings, file)

	file:close()
end

GlassicAPI.ImportFromMain = function(table)
	for _,v in ipairs(table) do
		modimport("main/"..v..".lua")
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

local glassic_main = {
	"assets",
	"actions",
	"recipes",
	"widgets",
	"prefabskin"
}

GlassicAPI.ImportFromMain(glassic_main)

modimport("strings/"..(table.contains({"zh","chs","cht"}, _G.LanguageTranslator.defaultlang) and "zh" or "en")..".lua")
