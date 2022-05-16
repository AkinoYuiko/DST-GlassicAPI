local assets =
{
    Asset("ANIM", "anim/glasspickaxe.zip"),
}

local function onattack_moonglass(inst, attacker, target)
    inst.components.weapon.attackwear = target and target:IsValid()
        and (target:HasTag("shadow") or target:HasTag("shadowminion") or target:HasTag("shadowchesspiece") or target:HasTag("stalker") or target:HasTag("stalkerminion"))
        and TUNING.MOONGLASSPICKAXE.SHADOW_WEAR
        or TUNING.MOONGLASSPICKAXE.ATTACKWEAR
end

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_glasspickaxe", inst.GUID, "swap_glasspickaxe")
    else
        owner.AnimState:OverrideSymbol("swap_object", "glasspickaxe", "swap_glasspickaxe")
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

    inst.AnimState:SetBank("glasspickaxe")
    inst.AnimState:SetBuild("glasspickaxe")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {0.75, 0.4, 0.75})

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.MINE, TUNING.MOONGLASSPICKAXE.EFFECTIVENESS)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.MOONGLASSPICKAXE.USES)
    inst.components.finiteuses:SetUses(TUNING.MOONGLASSPICKAXE.USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, TUNING.MOONGLASSPICKAXE.CONSUMPTION)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.MOONGLASSPICKAXE.DAMAGE)
    inst.components.weapon:SetOnAttack(onattack_moonglass)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    inst.components.floater:SetBankSwapOnFloat(true, -11, {sym_build = "glasspickaxe", sym_name = "swap_glasspickaxe", bank = "glasspickaxe"})

    return inst
end

return Prefab("moonglasspickaxe", fn, assets)
