local SKIN_AFFINITY_INFO = require("skin_affinity_info")
local ALL_MOD_SKINS = {}
local HEADSKIN_CHARACTERS = {}

local function GetPlayerFromID(id)
    if type(id) == "table" then return id end
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

local function IsModSkin(name)
    return ALL_MOD_SKINS[name] ~= nil
end

local function IsValidModSkin(name, userid)
    local test_fn = ALL_MOD_SKINS[name]
    return test_fn and (test_fn == true or test_fn(GetPlayerFromID(userid)))
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
InventoryProxy.CheckOwnership = function(self, name, ...)
    if IsValidModSkin(name) then
        return true
    end
    return check_ownership(self, name, ...)
end

local check_client_ownership = InventoryProxy.CheckClientOwnership
InventoryProxy.CheckClientOwnership = function(self, userid, name, ...)
    if IsValidModSkin(name, userid) then
        return true
    end
    return check_client_ownership(self, userid, name, ...)
end

local check_ownership_get_latest = InventoryProxy.CheckOwnershipGetLatest
InventoryProxy.CheckOwnershipGetLatest = function(self, item_type, ...)
    if IsValidModSkin(item_type, ThePlayer) then
        return true, -2333
    end
    return check_ownership_get_latest(self, item_type, ...)
end

local spawn_prefab = SpawnPrefab
SpawnPrefab = function(name, skin, ...)
    local ent = spawn_prefab(name, skin, ...)
    if IsModSkin(skin) then
        local init_fn = Prefabs[skin].init_fn
        if init_fn then init_fn(ent) end
    end
    return ent
end

local reskin_entity = Sim.ReskinEntity
Sim.ReskinEntity = function(self, guid, targetskinname, reskinname, ...)
    local ent = Ents[guid]
    local reskin = reskin_entity(self, guid, targetskinname, reskinname, ...)
    if IsModSkin(reskinname) then
        local init_fn = Prefabs[reskinname].init_fn
        if init_fn then init_fn(ent) end
    elseif IsModSkin(targetskinname) then
        if ent.components.inventoryitem then
            if ent.OnSkinChange then ent.OnSkinChange(ent) ent.OnSkinChange = nil end
        end
    end
    return reskin
end

local function ApplyTempCharacter(base_fn, ...)
    if #HEADSKIN_CHARACTERS == 0 then return base_fn(...) end
    local OFFICIAL_LIST = DST_CHARACTERLIST
    DST_CHARACTERLIST = ArrayUnion(DST_CHARACTERLIST, HEADSKIN_CHARACTERS)
    local ret = { base_fn(...) }
    -- for i, v in ipairs_reverse(DST_CHARACTERLIST) do
    --     if table.contains(HEADSKIN_CHARACTERS, v) then
    --         table.remove(DST_CHARACTERLIST, i)
    --     end
    -- end
    DST_CHARACTERLIST = OFFICIAL_LIST
    return unpack(ret)
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
    local ret = { ApplyTempCharacter(SkinPresetsPopup_ctor, self, ...) }

    local scroll_widget_apply = self.scroll_list.update_fn
    self.scroll_list.update_fn = function(...)
        return ApplyTempCharacter(scroll_widget_apply, ...)
    end

    return unpack(ret)
end

local function AddModSkins(data)
    for base_prefab, prefab_skins in pairs(data) do
        if prefab_skins.is_char and not table.contains(HEADSKIN_CHARACTERS, base_prefab) then
            table.insert(HEADSKIN_CHARACTERS, base_prefab)
        end
        if not PREFAB_SKINS[base_prefab] then
            PREFAB_SKINS[base_prefab] = {}
        end
        for _, skin_data in ipairs(prefab_skins) do
            local skin_name = type(skin_data) == "table" and skin_data.name or skin_data
            if prefab_skins.is_char and skin_name ~= base_prefab.."_none" then
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
        end
        IndexSkinIDs(base_prefab)
    end
end

local function SetRarity(rarity, order, color, frame_symbol)
    RARITY_ORDER[rarity] = order
    SKIN_RARITY_COLORS[rarity] = color
    local get_frame_symbol_for_rarity = GetFrameSymbolForRarity
    GetFrameSymbolForRarity = function(_rarity, ...)
        if _rarity == rarity then
            return frame_symbol
        end
        return get_frame_symbol_for_rarity(_rarity, ...)
    end
end

return {
    GetModSkins     = GetModSkins,
    AddModSkin      = AddModSkin,
    RemoveModSkin   = RemoveModSkin,
    IsModSkin       = IsModSkin,
    IsValidModSkin  = IsValidModSkin,

    AddModSkins     = AddModSkins,  -- to import skin data
    SetRarity       = SetRarity,
}
