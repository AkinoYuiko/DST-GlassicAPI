local SKIN_AFFINITY_INFO = require("skin_affinity_info")
local ALL_MOD_SKINS = {}
local HEADSKIN_CHARACTERS = {}
local OVERRIDE_RARITY_DATA = {}
local CHARACTER_EXCLUSIVE_SKINS = {}

local function get_player_from_id(id)
    if type(id) == "table" then
        return id.prefab and id or nil
    end
    for _, player in ipairs(AllPlayers) do
        if player.userid == id then
            return player
        end
    end
end

local function get_mod_skins()
    return ALL_MOD_SKINS
end

local function add_mod_skin(skin_name, test_fn)
    ALL_MOD_SKINS[skin_name] = test_fn or true
end

local function remove_modskin(skin_name)
    ALL_MOD_SKINS[skin_name] = nil
end

local function is_mod_skin(skin_name)
    return ALL_MOD_SKINS[skin_name] ~= nil
end

local function is_valid_mod_skin(skin_name, userid)
    local test_fn = ALL_MOD_SKINS[skin_name]
    return test_fn and (test_fn == true or test_fn(get_player_from_id(userid)))
end

local function set_character_exlusive_skin(skin_name, characters)
    CHARACTER_EXCLUSIVE_SKINS[skin_name] = type(characters) == "string" and {characters} or characters
end

local function does_character_has_skin(skin_name, character)
    if is_mod_skin(skin_name) then
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
local function index_skin_ids(prefab)
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
    if is_valid_mod_skin(skin) then
        return true
    end
    return check_ownership(self, skin, ...)
end

local check_client_ownership = InventoryProxy.CheckClientOwnership
InventoryProxy.CheckClientOwnership = function(self, userid, skin, ...)
    if not does_character_has_skin(skin, get_player_from_id(userid)) then
        return false
    end
    if is_valid_mod_skin(skin, userid) then
        return true
    end
    return check_client_ownership(self, userid, skin, ...)
end

local check_ownership_get_latest = InventoryProxy.CheckOwnershipGetLatest
InventoryProxy.CheckOwnershipGetLatest = function(self, item_type, ...)
    if not does_character_has_skin(item_type, ThePlayer) then
        return false
    end
    if is_valid_mod_skin(item_type, ThePlayer) then
        return true, -2333 -- :nope:
    end
    return check_ownership_get_latest(self, item_type, ...)
end

local spawn_prefab = SpawnPrefab
SpawnPrefab = function(name, skin, skin_id, creator, ...)
    local ent = spawn_prefab(name, skin, skin_id, creator, ...)
    if is_mod_skin(skin) and does_character_has_skin(skin, get_player_from_id(creator)) then
        local init_fn = Prefabs[skin].init_fn
        if init_fn then init_fn(ent) end
    end
    return ent
end

local reskin_entity = Sim.ReskinEntity
Sim.ReskinEntity = function(self, guid, targetskinname, reskinname, ...)
    local ent = Ents[guid]
    -- execute OnReskinFn before reskin_entity to avoid event issues.
    if ent.OnReskinFn then
        ent:OnReskinFn()
        ent.OnReskinFn = nil
    end

    -- do reskin
    local ret = { reskin_entity(self, guid, targetskinname, reskinname, ...) }

    -- mod skin init_fn
    if is_mod_skin(reskinname) then
        local init_fn = Prefabs[reskinname].init_fn
        if init_fn then init_fn(ent) end
    end
    return unpack(ret)
end

local Floater = require("components/floater")
local switch_to_float_anim = Floater.SwitchToFloatAnim
Floater.SwitchToFloatAnim = function(self, ...)
    local ret = { switch_to_float_anim(self, ...) }
    local skinname = self.inst.skinname
    if is_mod_skin(skinname) and self.do_bank_swap and self.swap_data then
        local symbol = self.swap_data.sym_name or self.swap_data.sym_build
        self.inst.AnimState:OverrideSymbol("swap_spear", self.swap_data.sym_build or skinname, symbol)
    end
    return unpack(ret)
end

local function apply_temp_character(base_fn, ...)
    if #HEADSKIN_CHARACTERS == 0 then return base_fn(...) end
    local added_characters = {}
    for _, v in ipairs(HEADSKIN_CHARACTERS) do
        if not table.contains(DST_CHARACTERLIST, v) then
            table.insert(added_characters, v)
            table.insert(DST_CHARACTERLIST, v)
        end
    end
    local ret = { base_fn(...) }
    for i = #DST_CHARACTERLIST, 1, -1 do
        if table.contains(HEADSKIN_CHARACTERS, DST_CHARACTERLIST[i]) then
            table.remove(DST_CHARACTERLIST, i)
        end
    end
    return unpack(ret)
end

local validate_spawn_prefab_request = ValidateSpawnPrefabRequest
ValidateSpawnPrefabRequest = function(...)
    return apply_temp_character(validate_spawn_prefab_request, ...)
end

local LoadoutSelect = require("widgets/redux/loadoutselect")
local LoadoutSelect_ctor = LoadoutSelect._ctor
LoadoutSelect._ctor = function(...)
    return apply_temp_character(LoadoutSelect_ctor, ...)
end

local apply_skin_presets = LoadoutSelect.ApplySkinPresets
LoadoutSelect.ApplySkinPresets = function(...)
    return apply_temp_character(apply_skin_presets, ...)
end

local SkinPresetsPopup = require("screens/redux/skinpresetspopup")
local SkinPresetsPopup_ctor = SkinPresetsPopup._ctor
SkinPresetsPopup._ctor = function(self, ...)
    local ret = { apply_temp_character(SkinPresetsPopup_ctor, self, ...) }

    local scroll_widget_apply = self.scroll_list.update_fn
    self.scroll_list.update_fn = function(...)
        return apply_temp_character(scroll_widget_apply, ...)
    end

    return unpack(ret)
end

local DefaultSkinSelectionPopup = require("screens/redux/defaultskinselection")
local DefaultSkinSelectionPopup_GetSkinsList = DefaultSkinSelectionPopup.GetSkinsList
DefaultSkinSelectionPopup.GetSkinsList = function(self, ...)
    local player_prefab = self.character
    local check_ownership = InventoryProxy.CheckOwnership
    InventoryProxy.CheckOwnership = function(self, name, ...)
        if not does_character_has_skin(name, player_prefab) then
            return false
        end
        return check_ownership(self, name, ...)
    end
    local ret = { DefaultSkinSelectionPopup_GetSkinsList(self, ...) }
    InventoryProxy.CheckOwnership = check_ownership
    return unpack(ret)
end

local function is_character(prefab)
    return table.contains(GetActiveCharacterList(), prefab)
end

local function add_mod_skins(data)
    for base_prefab, prefab_skins in pairs(data) do
        if is_character(base_prefab) and not table.contains(HEADSKIN_CHARACTERS, base_prefab) then
            table.insert(HEADSKIN_CHARACTERS, base_prefab)
        end
        if not PREFAB_SKINS[base_prefab] then
            PREFAB_SKINS[base_prefab] = {}
        end
        for _, skin_data in ipairs(prefab_skins) do
            local skin_name = type(skin_data) == "table" and skin_data.name or skin_data
            if is_character(base_prefab) and skin_name ~= base_prefab.."_none" then
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
            add_mod_skin(skin_name, type(skin_data) == "table" and skin_data.test_fn)
            set_character_exlusive_skin(skin_name, type(skin_data) == "table" and skin_data.exclusive_char)
        end
        index_skin_ids(base_prefab)
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

local function set_rarity(rarity, order, color, override_symbol, override_build)
    RARITY_ORDER[rarity] = order
    SKIN_RARITY_COLORS[rarity] = color
    if override_symbol or override_build then
        OVERRIDE_RARITY_DATA[rarity] = {
            symbol = override_symbol,
            build = override_build
        }
    else
        OVERRIDE_RARITY_DATA[rarity] = nil
    end
end

return {
    GetModSkins                 = get_mod_skins,
    AddModSkin                  = add_mod_skin,
    RemoveModSkin               = remove_modskin,
    IsModSkin                   = is_mod_skin,
    IsValidModSkin              = is_valid_mod_skin,

    SetCharacterExclusiveSkin   = set_character_exlusive_skin,
    DoesCharacterHasSkin        = does_character_has_skin,

    AddModSkins                 = add_mod_skins,  -- to import skin data
    SetRarity                   = set_rarity,
}
