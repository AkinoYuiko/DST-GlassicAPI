local SKIN_AFFINITY_INFO = require("skin_affinity_info")
local ALL_MOD_SKINS = {}
local HEADSKIN_CHARACTERS = {}
local OVERRIDE_RARITY_DATA = {}
local CHARACTER_EXCLUSIVE_SKINS = {}

local function GetPlayerFromID(id)
    if type(id) == "table" then
        return id.prefab and id or nil
    end
    for _, player in ipairs(AllPlayers) do
        if player.userid == id then
            return player
        end
    end
end

local function GetModSkins()
    return ALL_MOD_SKINS
end

local function AddModSkin(skin_name, test_fn)
    ALL_MOD_SKINS[skin_name] = test_fn or true
end

local function RemoveModSkin(skin_name)
    ALL_MOD_SKINS[skin_name] = nil
end

local function IsModSkin(skin_name)
    return ALL_MOD_SKINS[skin_name] ~= nil
end

local function IsValidModSkin(skin_name, userid)
    local test_fn = ALL_MOD_SKINS[skin_name]
    return test_fn and (test_fn == true or test_fn(GetPlayerFromID(userid)))
end

local function SetCharacterExclusiveSkin(skin_name, characters)
    CHARACTER_EXCLUSIVE_SKINS[skin_name] = type(characters) == "string" and {characters} or characters
end

local function DoesCharacterHasSkin(skin_name, character)
    if IsModSkin(skin_name) then
        local characters = CHARACTER_EXCLUSIVE_SKINS[skin_name]
        if characters then
            character = type(character) == "table" and character.prefab or character
            if character then
                return table.contains(characters, character)
            end
        end
    end
    return true
end

-- skin index for networking between server and clients
local function IndexSkinIDs(prefab)
    PREFAB_SKINS_IDS[prefab] = {}
    for index, skin in pairs(PREFAB_SKINS[prefab] or {}) do
        PREFAB_SKINS_IDS[prefab][skin] = index
    end
end

local get_full_inventory = InventoryProxy.GetFullInventory
InventoryProxy.GetFullInventory = function(...)
    local items = get_full_inventory(...)
    for skin_name in pairs(ALL_MOD_SKINS) do
        table.insert(items, {
            item_type = skin_name,
            modified_time = 0,
            item_id = "1",
        })
    end
    return items
end

local check_ownership = InventoryProxy.CheckOwnership
InventoryProxy.CheckOwnership = function(self, skin, ...)
    if IsValidModSkin(skin) then
        return true
    end
    return check_ownership(self, skin, ...)
end

local check_client_ownership = InventoryProxy.CheckClientOwnership
InventoryProxy.CheckClientOwnership = function(self, userid, skin, ...)
    if not DoesCharacterHasSkin(skin, GetPlayerFromID(userid)) then
        return false
    end
    if IsValidModSkin(skin, userid) then
        return true
    end
    return check_client_ownership(self, userid, skin, ...)
end

local check_ownership_get_latest = InventoryProxy.CheckOwnershipGetLatest
InventoryProxy.CheckOwnershipGetLatest = function(self, item_type, ...)
    if not DoesCharacterHasSkin(item_type, ThePlayer) then
        return false
    end
    if IsValidModSkin(item_type, ThePlayer) then
        return true, -2333 -- :nope:
    end
    return check_ownership_get_latest(self, item_type, ...)
end

local spawn_prefab = SpawnPrefab
SpawnPrefab = function(name, skin, skin_id, creator, ...)
    local ent = spawn_prefab(name, skin, skin_id, creator, ...)
    if IsModSkin(skin) and DoesCharacterHasSkin(skin, GetPlayerFromID(creator)) then
        local init_fn = Prefabs[skin].init_fn
        if init_fn then init_fn(ent) end
    end
    return ent
end

local reskin_entity = Sim.ReskinEntity
Sim.ReskinEntity = function(self, guid, targetskinname, reskinname, ...)
    local ent = Ents[guid]
    -- execute OnSkinChange before reskin_entity to avoid event issues.
    if ent.OnSkinChange then
        ent:OnSkinChange()
        ent.OnSkinChange = nil
    end

    -- do reskin
    local rt = { reskin_entity(self, guid, targetskinname, reskinname, ...) }

    -- mod skin init_fn
    if IsModSkin(reskinname) then
        local init_fn = Prefabs[reskinname].init_fn
        if init_fn then init_fn(ent) end
    end
    return unpack(rt)
end

local Floater = require("components/floater")
local switch_to_float_anim = Floater.SwitchToFloatAnim
Floater.SwitchToFloatAnim = function(self, ...)
    local rt = { switch_to_float_anim(self, ...) }
    local skinname = self.inst.skinname
    if IsModSkin(skinname) and self.do_bank_swap and self.swap_data then
        local symbol = self.swap_data.sym_name or self.swap_data.sym_build
        self.inst.AnimState:OverrideSymbol("swap_spear", self.swap_data.sym_build or skinname, symbol)
    end
    return unpack(rt)
end

local function ApplyTempCharacter(base_fn, ...)
    if #HEADSKIN_CHARACTERS == 0 then return base_fn(...) end
    local added_characters = {}
    for _, v in ipairs(HEADSKIN_CHARACTERS) do
        if not table.contains(DST_CHARACTERLIST, v) then
            table.insert(added_characters, v)
            table.insert(DST_CHARACTERLIST, v)
        end
    end
    local rt = { base_fn(...) }
    for i = #DST_CHARACTERLIST, 1, -1 do
        if table.contains(HEADSKIN_CHARACTERS, DST_CHARACTERLIST[i]) then
            table.remove(DST_CHARACTERLIST, i)
        end
    end
    return unpack(rt)
end

local validate_spawn_prefab_request = ValidateSpawnPrefabRequest
ValidateSpawnPrefabRequest = function(...)
    return ApplyTempCharacter(validate_spawn_prefab_request, ...)
end

local LoadoutSelect = require("widgets/redux/loadoutselect")
local LoadoutSelect_ctor = LoadoutSelect._ctor
LoadoutSelect._ctor = function(...)
    return ApplyTempCharacter(LoadoutSelect_ctor, ...)
end

local apply_skin_presets = LoadoutSelect.ApplySkinPresets
LoadoutSelect.ApplySkinPresets = function(...)
    return ApplyTempCharacter(apply_skin_presets, ...)
end

local SkinPresetsPopup = require("screens/redux/skinpresetspopup")
local SkinPresetsPopup_ctor = SkinPresetsPopup._ctor
SkinPresetsPopup._ctor = function(self, ...)
    local rt = { ApplyTempCharacter(SkinPresetsPopup_ctor, self, ...) }

    local scroll_widget_apply = self.scroll_list.update_fn
    self.scroll_list.update_fn = function(...)
        return ApplyTempCharacter(scroll_widget_apply, ...)
    end

    return unpack(rt)
end

local DefaultSkinSelectionPopup = require("screens/redux/defaultskinselection")
local DefaultSkinSelectionPopup_GetSkinsList = DefaultSkinSelectionPopup.GetSkinsList
DefaultSkinSelectionPopup.GetSkinsList = function(self, ...)
    local player_prefab = self.character
    local check_ownership = InventoryProxy.CheckOwnership
    InventoryProxy.CheckOwnership = function(self, name, ...)
        if not DoesCharacterHasSkin(name, player_prefab) then
            return false
        end
        return check_ownership(self, name, ...)
    end
    local rt = { DefaultSkinSelectionPopup_GetSkinsList(self, ...) }
    InventoryProxy.CheckOwnership = check_ownership
    return unpack(rt)
end

local function IsCharacter(prefab)
    return table.contains(GetActiveCharacterList(), prefab)
end

local function AddModSkins(data)
    for base_prefab, prefab_skins in pairs(data) do
        if IsCharacter(base_prefab) and not table.contains(HEADSKIN_CHARACTERS, base_prefab) then
            table.insert(HEADSKIN_CHARACTERS, base_prefab)
        end
        if not PREFAB_SKINS[base_prefab] then
            PREFAB_SKINS[base_prefab] = {}
        end
        for _, skin_data in ipairs(prefab_skins) do
            local skin_name = type(skin_data) == "table" and skin_data.name or skin_data
            if IsCharacter(base_prefab) and skin_name ~= base_prefab.."_none" then
                if not SKIN_AFFINITY_INFO[base_prefab] then
                    SKIN_AFFINITY_INFO[base_prefab] = {}
                end
                if not table.contains(SKIN_AFFINITY_INFO[base_prefab], skin_name) then
                    table.insert(SKIN_AFFINITY_INFO[base_prefab], skin_name)
                end
            end
            if not table.contains(PREFAB_SKINS[base_prefab], skin_name) then
                table.insert(PREFAB_SKINS[base_prefab], skin_name)
            end
            AddModSkin(skin_name, type(skin_data) == "table" and skin_data.test_fn)
            SetCharacterExclusiveSkin(skin_name, type(skin_data) == "table" and skin_data.exclusive_char)
        end
        IndexSkinIDs(base_prefab)
    end
end

local AccountItemFrame = require("widgets/redux/accountitemframe")
local set_rarity = AccountItemFrame._SetRarity
AccountItemFrame._SetRarity = function(self, rarity, ...)
    local mod_rarity_data = OVERRIDE_RARITY_DATA[rarity]
    if mod_rarity_data then
        local build = mod_rarity_data.build or "frame_BG"
        local symbol = mod_rarity_data.symbol or mod_rarity_data.build and rarity or GetFrameSymbolForRarity(rarity)
        self:GetAnimState():OverrideSymbol("SWAP_frameBG", build, symbol)
    else
        return set_rarity(self, rarity, ...)
    end
end

local function SetRarity(rarity, order, color, frame_symbol, override_build)
    RARITY_ORDER[rarity] = order
    SKIN_RARITY_COLORS[rarity] = color
    if frame_symbol or override_build then
        OVERRIDE_RARITY_DATA[rarity] = {
            symbol = frame_symbol,
            build = override_build
        }
    else
        OVERRIDE_RARITY_DATA[rarity] = nil
    end
end

return {
    GetModSkins                 = GetModSkins,
    AddModSkin                  = AddModSkin,
    RemoveModSkin               = RemoveModSkin,
    IsModSkin                   = IsModSkin,
    IsValidModSkin              = IsValidModSkin,

    SetCharacterExclusiveSkin   = SetCharacterExclusiveSkin,
    DoesCharacterHasSkin        = DoesCharacterHasSkin,

    AddModSkins                 = AddModSkins,  -- to import skin data
    SetRarity                   = SetRarity,
}
