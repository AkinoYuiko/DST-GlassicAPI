local assets =
{
    Asset("ANIM", "anim/glasshammer.zip"),
}

local function onattack_moonglass(inst, attacker, target)
    inst.components.weapon.attackwear = target and target:IsValid()
        and (target:HasTag("shadow") or target:HasTag("shadowminion") or target:HasTag("shadowchesspiece") or target:HasTag("stalker") or target:HasTag("stalkerminion"))
        and TUNING.MOONGLASSHAMMER.SHADOW_WEAR
        or TUNING.MOONGLASSHAMMER.ATTACKWEAR
end

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_glasshammer", inst.GUID, "swap_glasshammer")
    else
        owner.AnimState:OverrideSymbol("swap_object", "glasshammer", "swap_glasshammer")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("glasshammer")
    inst.AnimState:SetBuild("glasshammer")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hammer")

    MakeInventoryFloatable(inst, "med", 0.05, {0.7, 0.4, 0.7}, true, -13, {sym_build = "glasshammer", sym_name = "swap_glasshammer",bank = "glasshammer"})

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.MOONGLASSHAMMER.DAMAGE)
    inst.components.weapon:SetOnAttack(onattack_moonglass)

    inst:AddComponent("inventoryitem")

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.HAMMER, TUNING.MOONGLASSHAMMER.EFFECTIVENESS)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.MOONGLASSHAMMER.USES)
    inst.components.finiteuses:SetUses(TUNING.MOONGLASSHAMMER.USES)

    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, TUNING.MOONGLASSHAMMER.CONSUMPTION)

    MakeHauntableLaunch(inst)

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    return inst
end

return Prefab("moonglasshammer", fn, assets)
