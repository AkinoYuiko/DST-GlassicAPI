local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function _can_cast_fn(doer, target, pos)

    local prefab_to_skin = target.prefab
    local is_beard = false

    if table.contains( GetActiveCharacterList(), prefab_to_skin ) then -- Changed DST_CHARACTERLIST to GetActiveCharacterList()
        --We found a player, check if it's us
        if doer.userid == target.userid and target.components.beard ~= nil and target.components.beard.is_skinnable then
            prefab_to_skin = target.prefab .. "_beard"
            is_beard = true
        else
            return false
        end
    end

    if PREFAB_SKINS[prefab_to_skin] ~= nil then
        for _,item_type in pairs(PREFAB_SKINS[prefab_to_skin]) do
            if TheInventory:CheckClientOwnership(doer.userid, item_type) then
                return true
            end
        end
    end

    --Is there a skin to turn off?
    local curr_skin = is_beard and target.components.beard.skinname or target.skinname
    if curr_skin ~= nil then
        return true
    end

    return false
end

ENV.AddPrefabPostInit("reskin_tool", function(inst)
    if not TheWorld.ismastersim then return end
    if inst.components.spellcaster then
        inst.components.spellcaster:SetCanCastFn(_can_cast_fn)
    end
end)
