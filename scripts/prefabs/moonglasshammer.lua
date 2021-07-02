local assets =
{
    Asset("ANIM", "anim/glasshammer.zip"),
    -- Asset("ANIM", "anim/swap_glasshammer.zip"),

    Asset("ANIM", "anim/floating_items.zip"),
}
local function onattack_moonglass(inst, attacker, target)
    inst.components.weapon.attackwear = target ~= nil and target:IsValid() 
        and (target:HasTag("shadow") or target:HasTag("shadowminion") or target:HasTag("shadowchesspiece") or target:HasTag("stalker") or target:HasTag("stalkerminion"))
        and TUNING.MOONGLASSAXE.SHADOW_WEAR
        or TUNING.MOONGLASSAXE.ATTACKWEAR
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "glasshammer", "swap_glasshammer")
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
    -- inst.components.floater:SetBankSwapOnFloat(true, -13, swap_data)

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.AXE_DAMAGE)
    inst.components.weapon:SetOnAttack(onattack_moonglass)

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem.imagename = "moonglasshammer"
    -- inst.components.inventoryitem.atlasname = resolvefilepath("images/inventoryimages/moonglasstools.xml")
    -----
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.HAMMER, 2)
    -------
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(60)
    inst.components.finiteuses:SetUses(60)

    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 1)
    -------

    MakeHauntableLaunch(inst)

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    return inst
end

return Prefab("moonglasshammer", fn, assets)
