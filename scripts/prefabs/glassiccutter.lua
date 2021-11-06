local assets =
{
    Asset("ANIM", "anim/glassiccutter.zip"),
}

local prefabs = {
    "alterguardianhat_projectile",
    "lanternlight",
	"electrichitsparks"
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

local function get_item_type(inst, noprefix)
    return inst.components.container and (
        (inst.components.container:Has("moonglass",1) and (noprefix and "moonglass" or "_moonglass")) or
        (inst.components.container:Has("thulecite",1) and (noprefix and "thulecite" or "_thulecite")) or
        (inst.components.container:Has("moonrocknugget",1) and (noprefix and "moonrock" or "_moonrock"))) or
		(noprefix and "none" or "")
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "glassiccutter", "swap_glassiccutter"..get_item_type(inst))

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

local function onattack_moonglass(inst, attacker, target)
    if attacker ~= nil and (attacker.components.health == nil or not attacker.components.health:IsDead()) then
        if target and target ~= attacker and target:IsValid() then
            if (target.components.health == nil or not target.components.health:IsDead()) and
                (target:HasTag("spiderden") or not target:HasTag("structure")) and
                not target:HasTag("wall")
                then

				SpawnPrefab("glassic_gestalt_flash"):SetTarget(attacker, target)
            end

            if not (target:HasTag("shadowcreature") or target:HasTag("nightmarecreature")) then
                try_consume(inst, 0.25, "moonglass")
            end
            auto_refill(inst, attacker, "moonglass")
        end
    end
end

local function onattack_thulecite(inst, attacker, target)
    if attacker ~= nil and (attacker.components.health == nil or not attacker.components.health:IsDead()) then
        if target ~= nil and target:IsValid() then
            try_consume(inst, 0.032, "thulecite")
            auto_refill(inst, attacker, "thulecite")
        end
    end
end
local function onattack_moonrock(inst, attacker, target)
    if attacker ~= nil and (attacker.components.health == nil or not attacker.components.health:IsDead()) then
        if target ~= nil and target:IsValid() then
            local debuffkey = inst.prefab
            if target.components.locomotor ~= nil then
                if target._glassiccutter_speedmulttask ~= nil then
                    target._glassiccutter_speedmulttask:Cancel()
                end
                target._glassiccutter_speedmulttask = target:DoTaskInTime(TUNING.SLINGSHOT_AMMO_MOVESPEED_DURATION, function(i) i.components.locomotor:RemoveExternalSpeedMultiplier(i, debuffkey) i._glassiccutter_speedmulttask = nil end)

                target.components.locomotor:SetExternalSpeedMultiplier(target, debuffkey, TUNING.SLINGSHOT_AMMO_MOVESPEED_MULT)
            end
            try_consume(inst, 0.32, "moonrocknugget")
            auto_refill(inst, attacker, "moonrocknugget")
        end
    end
end
local function onattack_none(inst, attacker, target)
    if attacker ~= nil and (attacker.components.health == nil or not attacker.components.health:IsDead()) then
        if target ~= nil and target:IsValid() and math.random() < 0.0233 then
            if inst.components.inventoryitem.owner ~= nil then
                inst.components.inventoryitem.owner:PushEvent("toolbroke", { tool = inst })
            end
            inst.components.container:Close()
            inst.components.container:DropEverything()
            inst:Remove()
        end
    end
end

local GLASSIC_NAMES = {
    "_moonglass",
    "_moonrock",
    "_thulecite"
}
local GLASSIC_IDS = table.invert(GLASSIC_NAMES)

local function OnChangeImage(inst)
	local tail = get_item_type(inst)
	local anim = get_item_type(inst, true)
    -- AnimState --
    inst.AnimState:PlayAnimation(anim)
    -- Image --
    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName("glassiccutter"..tail)
    end
    -- float swap data --
    if inst.components.floater then
        inst.components.floater.swap_data = { sym_build = "glassiccutter", sym_name = "swap_glassiccutter"..tail, anim = anim}
    end
    -- Equipped --
    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
        owner.AnimState:OverrideSymbol("swap_object", "glassiccutter", "swap_glassiccutter"..tail)
    end
    inst._nametail:set(GLASSIC_IDS[tail] or 0)
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
        inst.components.weapon:SetDamage(TUNING.RUINS_BAT_DAMAGE)
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
    return STRINGS.NAMES[string.upper("glassiccutter"..(GLASSIC_NAMES[inst._nametail:value()] or ""))]
end

local function OnLoad(inst)
    inst._nametail:set(GLASSIC_IDS[get_item_type(inst)] or 0)
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

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1

    MakeHauntableLaunch(inst)

    inst.OnLoad = OnLoad

    return inst
end

return Prefab("glassiccutter", fn, assets, prefabs)
