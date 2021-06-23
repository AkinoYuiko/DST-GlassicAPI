local assets =
{
    Asset( "ANIM", "anim/glasspickaxe.zip"),
    Asset("ANIM", "anim/swap_glasspickaxe.zip"),
}

local function onattack_moonglass(inst, attacker, target)
    inst.components.weapon.attackwear = target ~= nil and target:IsValid() 
        and (target:HasTag("shadow") or target:HasTag("shadowminion") or target:HasTag("shadowchesspiece") or target:HasTag("stalker") or target:HasTag("stalkerminion"))
        and TUNING.MOONGLASSAXE.SHADOW_WEAR
        or TUNING.MOONGLASSAXE.ATTACKWEAR
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_glasspickaxe", "swap_glasspickaxe")
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
    inst.AnimState:SetManualBB(20,-70,210,170)

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

    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.MINE,3)

    -------
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(40)
    inst.components.finiteuses:SetUses(40)
    inst.components.finiteuses:SetOnFinished(inst.Remove) 
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 1)

    -------
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(34)
    inst.components.weapon:SetOnAttack(onattack_moonglass)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem.imagename = "moonglasspickaxe"
    -- inst.components.inventoryitem.atlasname = resolvefilepath("images/inventoryimages/moonglasstools.xml")

    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    inst.components.floater:SetBankSwapOnFloat(true, -11, {sym_build = "swap_glasspickaxe", sym_name = "swap_glasspickaxe", bank = "glasspickaxe"})

    return inst
end

return Prefab("moonglasspickaxe", fn, assets)