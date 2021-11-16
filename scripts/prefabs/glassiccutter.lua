local assets =
{
    Asset("ANIM", "anim/glassiccutter.zip"),
}

local prefabs = {
    "lanternlight",
    "glassic_flash",
    "electrichitsparks",
    "alterguardianhat_projectile",
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
    if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove()
        end
        inst._light = nil
    end
end

local function GetItemType(inst, noprefix)
    return inst.components.container and (
        (inst.components.container:Has("moonglass",1) and (noprefix and "moonglass" or "_moonglass")) or
        (inst.components.container:Has("thulecite",1) and (noprefix and "thulecite" or "_thulecite")) or
        (inst.components.container:Has("moonrocknugget",1) and (noprefix and "moonrock" or "_moonrock"))) or
        (noprefix and "none" or "")
end

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build then
        -- owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideSymbol("swap_object", skin_build, "swap_glassiccutter"..GetItemType(inst))
    else
        owner.AnimState:OverrideSymbol("swap_object", "glassiccutter", "swap_glassiccutter"..GetItemType(inst))
    end

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end

    turn_on(inst, owner)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    -- local skin_build = inst:GetSkinBuild()
    -- if skin_build then
    --     owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    -- end

    if inst.components.container ~= nil then
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

local function onattack_base_check(attacker, target)
    return attacker and (attacker.components.health == nil or not attacker.components.health:IsDead())
        and target and target ~= attacker and target:IsValid()
end

local function onattack_moonglass(inst, attacker, target)
    if onattack_base_check(attacker, target) then
        if (target.components.health == nil or not target.components.health:IsDead()) and
            (target:HasTag("spiderden") or not target:HasTag("structure")) and
            not target:HasTag("wall")
            then

            SpawnPrefab("glassic_flash"):SetTarget(attacker, target)
        end

        try_consume_and_refill(inst, attacker, "moonglass", 0.25)
    end
end

local function onattack_thulecite(inst, attacker, target)
    if onattack_base_check(attacker, target) then
        try_consume_and_refill(inst, attacker, "thulecite", 0.032)
    end
end
local function onattack_moonrock(inst, attacker, target)
    if onattack_base_check(attacker, target) then
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
        try_consume_and_refill(inst, attacker, "moonrocknugget", 0.5)
    end
end
local function onattack_none(inst, attacker, target)
    if onattack_base_check(attacker, target) and math.random() < 0.01 then
        if inst.components.inventoryitem.owner ~= nil then
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
    "_thulecite",
    "_dream",
    "_excalibur",
    "_frostmourning"
}
local GLASSIC_IDS = table.invert(GLASSIC_NAMES)

local function OnChangeImage(inst)
    local tail = GetItemType(inst)
    local anim = GetItemType(inst, true)
    local skin_build = inst:GetSkinBuild() or "glassiccutter"
    local display_name = inst:GetSkinBuild() and
                        (( tail == "_moonglass" and "_dream" ) or
                        ( tail == "_thulecite" and "_excalibur" ) or
                        ( tail == "_moonrock" and "_frostmourning" ))
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
    inst._nametail:set(GLASSIC_IDS[(display_name or tail)] or 0)
end

local function OnAmmoLoaded(inst, data)
    if data.item.prefab == "moonglass" then
        inst.components.weapon:SetDamage(TUNING.GLASSCUTTER.DAMAGE)
        inst.components.weapon:SetOnAttack(onattack_moonglass)
        inst.components.equippable.walkspeedmult = 1
    elseif data.item.prefab == "thulecite" then
        inst.components.weapon:SetDamage(TUNING.RUINS_BAT_DAMAGE)
        inst.components.weapon:SetOnAttack(onattack_thulecite)
        inst.components.equippable.walkspeedmult = 1.1
    elseif data.item.prefab == "moonrocknugget" then
        inst.components.weapon:SetDamage(TUNING.ALTERGUARDIANHAT_GESTALT_DAMAGE)
        inst.components.weapon:SetOnAttack(onattack_moonrock)
        inst.components.equippable.walkspeedmult = 1
    elseif data.item:HasTag("spore") then
        inst.components.weapon:SetDamage(TUNING.GLASSCUTTER.DAMAGE / 2)
        inst.components.equippable.walkspeedmult = 1
        turn_on(inst, inst.components.inventoryitem.owner)
    end
    -- anim and image --
    OnChangeImage(inst)
end

local function OnAmmoUnloaded(inst, data)
    inst.components.weapon:SetDamage(TUNING.GLASSCUTTER.DAMAGE)
    inst.components.weapon:SetOnAttack(onattack_none)
    inst.components.equippable.walkspeedmult = 1
    turn_off(inst)
    -- anim and image --
    OnChangeImage(inst)
end

local function displaynamefn(inst)
    return STRINGS.NAMES[string.upper("glassiccutter" .. (GLASSIC_NAMES[inst._nametail:value()] or ""))]
end

local function descriptionfn(inst, viewer)
    return GetString(viewer.prefab, "DESCRIBE", string.upper("glassiccutter" .. (GLASSIC_NAMES[inst._nametail:value()] or "")) )
end

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

    MakeInventoryFloatable(inst, "med", 0.05, {1.0, 0.4, 1.0}, true, -17.5, {sym_build = "glassiccutter", sym_name = "swap_glassiccutter", anim = "none" } )

    inst.entity:SetPristine()

    inst.displaynamefn = displaynamefn
    inst._nametail = net_tinybyte(inst.GUID, "glassiccutter._nametail")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.GLASSCUTTER.DAMAGE)
    inst.components.weapon:SetOnAttack(onattack_none)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("glassiccutter")
    inst.components.container.canbeopened = false

    inst:ListenForEvent("itemget", OnAmmoLoaded)
    inst:ListenForEvent("itemlose", OnAmmoUnloaded)

    -------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inspectable.descriptionfn = descriptionfn

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1

    MakeHauntableLaunch(inst)

    inst.GetItemType = GetItemType
    inst.OnChangeImage = OnChangeImage

    return inst
end

return Prefab("glassiccutter", fn, assets, prefabs)
