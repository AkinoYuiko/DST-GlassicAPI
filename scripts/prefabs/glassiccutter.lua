local assets =
{
    Asset("ANIM", "anim/glassiccutter.zip"),
}

local prefabs = {
    "lanternlight",
    "glassic_flash",
    "electrichitsparks",
}

local function turn_on(inst, owner)
    if owner == nil then return end
    if not inst.components.container:FindItem(function(inst) return inst:HasTag("spore") end) then return end
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("lanternlight")
        inst._light.Light:SetFalloff(0.5)
        inst._light.Light:SetIntensity(0.8)
        inst._light.Light:SetRadius(1)
        if inst.components.container:FindItem(function(inst) return inst.prefab == "spore_medium" end) then
            inst._light.Light:SetColour(197/255, 126/255, 126/255)
        elseif inst.components.container:FindItem(function(inst) return inst.prefab == "spore_small" end) then
            inst._light.Light:SetColour(146/255, 225/255, 146/255)
        elseif inst.components.container:FindItem(function(inst) return inst.prefab == "spore_tall" end) then
            inst._light.Light:SetColour(111/255, 111/255, 227/255)
        end
    end

    inst._light.entity:SetParent(owner.entity)
end

local function turn_off(inst)
    if inst._light then
        if inst._light:IsValid() then
            inst._light:Remove()
        end
        inst._light = nil
    end
end

local function get_type_name(inst, noprefix, prefab, name_override)
    local name = name_override or prefab
    return inst.components.container:Has(prefab,1) and (noprefix and name or ("_" .. name))
end

local function get_item_type(inst, noprefix)
    return inst.components.container and
        get_type_name(inst, noprefix, "moonglass") or
        get_type_name(inst, noprefix, "moonrocknugget", "moonrock") or
        (noprefix and "none" or "")
end

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build then
        -- owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideSymbol("swap_object", skin_build, "swap_glassiccutter"..get_item_type(inst))
    else
        owner.AnimState:OverrideSymbol("swap_object", "glassiccutter", "swap_glassiccutter"..get_item_type(inst))
    end

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst.components.container then
        inst.components.container:Open(owner)
    end

    turn_on(inst, owner)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if inst.components.container then
        inst.components.container:Close()
    end
    turn_off(inst)
end

local function auto_refill(inst, owner, item_type)
    local inv = owner.components.inventory
    local container = inst.components.container
    local hat = inv and inv:GetEquippedItem(EQUIPSLOTS.HEAD)
    local hat_container = hat and hat.prefab == "alterguardianhat" and hat.components.container
    local item_fn = function(item) return item.prefab == item_type end
    if not container:Has(item_type, 1) then
        local new_item = inv and inv:FindItem(item_fn)
        if new_item then
            inv:RemoveItem(new_item, true)
            container:GiveItem(new_item)
        elseif hat_container then
            local new_hat_item = hat_container:FindItem(item_fn)
            if new_hat_item then
                hat_container:RemoveItem(new_hat_item, true)
                container:GiveItem(new_hat_item)
            end
        end
    end
end

local function try_consume(inst, chance, item_type)
    if math.random() < chance then
        inst.components.container:ConsumeByName(item_type, 1)
    end
end

local function try_consume_and_refill(inst, owner, item_prefab, chance)
    try_consume(inst, chance, item_prefab)
    auto_refill(inst, owner, item_prefab)
end

local function attacker_testfn(attacker, target)
    return attacker and (attacker.components.health == nil or not attacker.components.health:IsDead())
        and target and target ~= attacker and target:IsValid()
end

local function target_testfn(target)
    return (target.components.health == nil or not target.components.health:IsDead()) and
            (target:HasTag("spiderden") or not target:HasTag("structure")) and
            not target:HasTag("wall")
end

local function get_attacker_mult(attacker)
    local base_mult = TUNING.GLASSICCUTTER.CONSUME_RATE.MOONGLASS.MULT
    local damagemult = attacker.components.combat.damagemultiplier or 1
    damagemult = math.min(2, damagemult)
    damagemult = math.max(1, damagemult)
    local electricmult = attacker.components.electricattacks and 1.5 or 1
    return base_mult * damagemult * electricmult
end

local function onattack_moonglass(inst, attacker, target)
    if attacker_testfn(attacker, target) then
        local moonglass_rate = TUNING.GLASSICCUTTER.CONSUME_RATE.MOONGLASS.BASE
        if target_testfn(target) then
            moonglass_rate = moonglass_rate * get_attacker_mult(attacker)
            SpawnPrefab("glassic_flash"):SetTarget(attacker, target)
        end
        try_consume_and_refill(inst, attacker, "moonglass", moonglass_rate)
    end
end

-- local function onattack_thulecite(inst, attacker, target)
--     if attacker_testfn(attacker, target) then
--         try_consume_and_refill(inst, attacker, "thulecite", TUNING.GLASSICCUTTER.CONSUME_RATE.THULECITE)
--     end
-- end
local function onattack_moonrock(inst, attacker, target)
    if attacker_testfn(attacker, target) then
        if target.components.burnable then
            if target.components.burnable:IsBurning() then
                target.components.burnable:Extinguish()
            elseif target.components.burnable:IsSmoldering() then
                target.components.burnable:SmotherSmolder()
            end
        end
        local freezable = target.components.freezable
        if freezable then
            -- Adjust coldness by players' damage multiplier. The lower multiplier, the higher coldness, max to 2x.
            local extraresistmult = (freezable.extraresist or 0) / (2 * freezable.resistance) + 1
            local playermult = math.min(2, 1 / (attacker.components.combat.damagemultiplier or 1))
            freezable:AddColdness(0.8 * extraresistmult * playermult )
            freezable:SpawnShatterFX()
        end
        try_consume_and_refill(inst, attacker, "moonrocknugget", TUNING.GLASSICCUTTER.CONSUME_RATE.MOONROCK)
    end
end

-- local function update_obsidian_damage(inst)
--     local base_damage = TUNING.GLASSICCUTTER.DAMAGE.OBSIDIAN
--     inst.components.weapon:SetDamage(base_damage + inst.obs_charge)
-- end

-- local function reset_charge_and_task(inst)
--     inst.obs_charge = 0
--     if inst.obs_task then
--         inst.obs_task:Cancel()
--         inst.obs_task = nil
--     end
-- end

-- local function update_obs_charge(inst)
--     inst.obs_charge = math.max(inst.obs_charge - 1, 0)
--     update_obsidian_damage(inst)
--     if inst.obs_charge <= 0 then
--         reset_charge_and_task(inst)
--     end
-- end

-- local function activate_obs_task(inst)
--     update_obsidian_damage(inst)
--     if inst.obs_task == nil then
--         inst.obs_task = inst:DoPeriodicTask(30, update_obs_charge)
--     end
-- end

-- local function onattack_obsidian(inst, attacker, target)
--     if attacker_testfn(attacker, target) then
--         inst.obs_charge = math.min(inst.obs_charge + 1, TUNING.GLASSICCUTTER.MAX_OBS_CHARGE)
--         if inst.obs_task then
--             inst.obs_task:Cancel()
--             inst.obs_task = nil
--         end
--         activate_obs_task(inst)
--         try_consume_and_refill(inst, attacker, "obsidian", TUNING.GLASSICCUTTER.CONSUME_RATE.OBSIDIAN)
--     end
-- end

local function onattack_none(inst, attacker, target)
    if attacker_testfn(attacker, target) and math.random() < TUNING.GLASSICCUTTER.CONSUME_RATE.NONE then
        if attacker.components.talker then
            attacker.components.talker:Say(STRINGS.ANNOUNCE_GLASSICCUTTER_BROKE, 3, true)
        end
        if inst.components.inventoryitem.owner then
            inst.components.inventoryitem.owner:PushEvent("toolbroke", { tool = inst })
        end
        inst.components.container:Close()
        inst.components.container:DropEverything()
        inst:Remove()
    end
end

local GLASSIC_NAMES = {
    "_moonglass",
    "_moonrock",
    -- "_thulecite",
    -- "_obsidian",
    "_dream",
    -- "_excalibur",
    "_frostmourning",
    -- "_flame"
}
local GLASSIC_IDS = table.invert(GLASSIC_NAMES)

local function on_change_image(inst)
    local tail = get_item_type(inst)
    local anim = get_item_type(inst, true)
    local skin_build = inst:GetSkinBuild() or "glassiccutter"
    local display_name = inst:GetSkinBuild() and
                    ((tail == "_moonglass" and "_dream" ) or
                    (tail == "_moonrock" and "_frostmourning" )) or tail
    -- AnimState --
    inst.AnimState:PlayAnimation(anim)
    -- Image --
    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName( skin_build .. tail )
    end
    -- float swap data --
    if inst.components.floater then
        inst.components.floater.swap_data = { sym_build = skin_build, sym_name = "swap_glassiccutter" .. tail, anim = anim}
    end
    -- Equipped --
    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
        owner.AnimState:OverrideSymbol("swap_object", skin_build, "swap_glassiccutter" .. tail)
    end
    inst._nametail:set(GLASSIC_IDS[(display_name)] or 0)
    -- Strcode Name --
    inst.drawnameoverride = rawget(_G, "EncodeStrCode") and EncodeStrCode({content = "NAMES.GLASSICCUTTER" .. string.upper(display_name)})
end

local function on_frag_load(inst, data)
    -- reset_charge_and_task(inst)
    if data.item.prefab == "moonglass" then
        inst.components.weapon:SetDamage(TUNING.GLASSICCUTTER.DAMAGE.MOONGLASS)
        inst.components.weapon:SetOnAttack(onattack_moonglass)
        -- inst.components.equippable.walkspeedmult = TUNING.GLASSICCUTTER.WALKSPEEDMULT.GENERAL
    -- elseif data.item.prefab == "thulecite" then
    --     inst.components.weapon:SetDamage(TUNING.GLASSICCUTTER.DAMAGE.THULECITE)
    --     inst.components.weapon:SetOnAttack(onattack_thulecite)
    --     inst.components.equippable.walkspeedmult = TUNING.GLASSICCUTTER.WALKSPEEDMULT.THULECITE
    elseif data.item.prefab == "moonrocknugget" then
        inst.components.weapon:SetDamage(TUNING.GLASSICCUTTER.DAMAGE.MOONROCK)
        inst.components.weapon:SetOnAttack(onattack_moonrock)
        -- inst.components.equippable.walkspeedmult = TUNING.GLASSICCUTTER.WALKSPEEDMULT.GENERAL
    -- elseif data.item.prefab == "obsidian" then
    --     inst.components.weapon:SetDamage(TUNING.GLASSICCUTTER.DAMAGE.OBSIDIAN)
    --     inst.components.weapon:SetOnAttack(onattack_obsidian)
    --     inst.components.equippable.walkspeedmult = TUNING.GLASSICCUTTER.WALKSPEEDMULT.GENERAL
    elseif data.item:HasTag("spore") then
        inst.components.weapon:SetDamage(TUNING.GLASSICCUTTER.DAMAGE.SPORE)
        -- inst.components.equippable.walkspeedmult = TUNING.GLASSICCUTTER.WALKSPEEDMULT.GENERAL
        turn_on(inst, inst.components.inventoryitem.owner)
    end
    -- anim and image --
    on_change_image(inst)
end

local function on_frag_unload(inst, data)
    -- reset_charge_and_task(inst)
    inst.components.weapon:SetDamage(TUNING.GLASSICCUTTER.DAMAGE.NONE)
    inst.components.weapon:SetOnAttack(onattack_none)
    -- inst.components.equippable.walkspeedmult = TUNING.GLASSICCUTTER.WALKSPEEDMULT.GENERAL
    turn_off(inst)
    -- anim and image --
    on_change_image(inst)
end

local function display_name_fn(inst)
    return STRINGS.NAMES[string.upper("glassiccutter" .. (GLASSIC_NAMES[inst._nametail:value()] or ""))]
end

local function GetStatus(inst)
    local itemtype = get_item_type(inst, true)
    local itemtype_with_skin = inst:GetSkinBuild() and
            (( itemtype == "moonglass" and "dream" ) or
            -- ( itemtype == "thulecite" and "excalibur" ) or
            ( itemtype == "moonrock" and "frostmourning" )) or itemtype
            -- ( itemtype == "obsidian" and "flame" )) or itemtype
    return string.upper(itemtype_with_skin)
end

-- local function OnSave(inst, data)
--     if get_item_type(inst, true) == "obsidian" then
--         data.obs_charge = inst.obs_charge
--     end
-- end

-- local function OnLoad(inst, data)
--     if data and data.obs_charge and get_item_type(inst, true) == "obsidian" then
--         inst.obs_charge = data.obs_charge
--         activate_obs_task(inst)
--     end
-- end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("glassiccutter")
    inst.AnimState:SetBuild("glassiccutter")
    inst.AnimState:PlayAnimation("none")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.0, 0.4, 1.0}, true, -17.5, {sym_build = "glassiccutter", sym_name = "swap_glassiccutter", anim = "none" } )

    inst.entity:SetPristine()

    inst.displaynamefn = display_name_fn
    inst._nametail = net_smallbyte(inst.GUID, "glassiccutter._nametail")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.obs_charge = 0

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.GLASSCUTTER.DAMAGE)
    inst.components.weapon:SetOnAttack(onattack_none)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("glassiccutter")
    inst.components.container.canbeopened = false

    inst:ListenForEvent("itemget", on_frag_load)
    inst:ListenForEvent("itemlose", on_frag_unload)

    -------

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1

    MakeHauntableLaunch(inst)

    inst.GetItemType = get_item_type
    inst.OnChangeImage = on_change_image

    -- inst.OnSave = OnSave
    -- inst.OnLoad = OnLoad

    inst.drawnameoverride = rawget(_G, "EncodeStrCode") and EncodeStrCode({content = "NAMES.GLASSICCUTTER"})

    return inst
end

return Prefab("glassiccutter", fn, assets, prefabs)
