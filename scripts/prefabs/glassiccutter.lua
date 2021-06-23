local assets =
{
    Asset("ANIM", "anim/glassiccutter.zip"),
    Asset("ANIM", "anim/glassiccutter_moonglass.zip"),
    Asset("ANIM", "anim/glassiccutter_thulecite.zip"),
    Asset("ANIM", "anim/glassiccutter_moonrock.zip"),
    -- Asset("ANIM", "anim/swap_glasscutter.zip"),
    Asset("ANIM", "anim/swap_glassiccutter.zip"),
    Asset("ANIM", "anim/swap_glassiccutter_moonglass.zip"),
    Asset("ANIM", "anim/swap_glassiccutter_thulecite.zip"),
    Asset("ANIM", "anim/swap_glassiccutter_moonrock.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
}

local function turn_on(inst, owner)
    if owner == nil then return end
    if not inst.components.container:FindItem(function(inst) return inst:HasTag("spore") end) then return end
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("lanternlight")
        inst._light.Light:SetFalloff(.5)
        inst._light.Light:SetIntensity(.8)
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

local function get_item_type(inst)
    return inst.components.container and (
        (inst.components.container:Has("moonglass",1) and "_moonglass") or
        (inst.components.container:Has("thulecite",1) and "_thulecite") or
        (inst.components.container:Has("moonrocknugget",1) and "_moonrock")) or ""
end

local function onequip(inst, owner)
    -- local skin_build = inst:GetSkinBuild()
    -- if skin_build ~= nil then
    --     owner:PushEvent("equipskinneditem", inst:GetSkinName())
    --     owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_glasscutter", inst.GUID, "swap_glasscutter")
    -- else
    owner.AnimState:OverrideSymbol("swap_object", "swap_glassiccutter"..get_item_type(inst), "swap_glassiccutter")
    -- end
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
    -- if skin_build ~= nil then
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

local function onattack_moonglass(inst, attacker, target)
    if attacker ~= nil and (attacker.components.health == nil or not attacker.components.health:IsDead()) then
        -- local target = data.target
        if target and target ~= attacker and target:IsValid() then
            if target.components.health == nil or not target.components.health:IsDead() and not target:HasTag("structure") and not target:HasTag("wall") then

        --     -- In combat, this is when we're just launching a projectile, so don't spawn a gestalt yet
        --     if data.weapon ~= nil and data.projectile == nil 
        --             and (data.weapon.components.projectile ~= nil
        --                 or data.weapon.components.complexprojectile ~= nil
        --                 or data.weapon.components.weapon:CanRangedAttack()) then
        --         return
        --     end

                local x, y, z = target.Transform:GetWorldPosition()

                local gestalt = SpawnPrefab("alterguardianhat_projectile") -- 这一行改成复制的月灵
                if attacker.components.combat then
                    -- local props = {"damagemultiplier", "externaldamagemultipliers", "damagebonus", "customdamagemultfn"}
                    local props = {"externaldamagemultipliers", "damagebonus"}
                    for _, v in ipairs(props) do
                        gestalt.components.combat[v] = attacker.components.combat[v]
                    end
                    gestalt.components.combat.damagemultiplier = math.max(1,(attacker.components.combat.damagemultiplier or 1))
                    if attacker.components.electricattacks then
                        gestalt:AddComponent("electricattacks")
                        gestalt:ListenForEvent("onattackother", function(_inst, _data)
                            local target = _data.target
                            if _inst:IsValid() and target ~= nil and target:IsValid() then
                                SpawnPrefab("electrichitsparks"):AlignToTarget(target, _inst, true)
                            end
                        end)
                    end
                end
                local r = GetRandomMinMax(1.5, 2.5)
                local delta_angle = GetRandomMinMax(-90, 90)
                local angle = (attacker:GetAngleToPoint(x, y, z) + delta_angle) * DEGREES
                gestalt.Transform:SetPosition(x + r * math.cos(angle), y, z + r * -math.sin(angle))
                gestalt:ForceFacePoint(x, y, z)
                gestalt:SetTargetPosition(Vector3(x, y, z))
                gestalt.components.follower:SetLeader(attacker)
            end

            try_consume(inst, 0.33, "moonglass")
            auto_refill(inst, attacker, "moonglass")
        end
    end
end

local function onattack_thulecite(inst, attacker, target)
    if attacker ~= nil and (attacker.components.health == nil or not attacker.components.health:IsDead()) then
        if target ~= nil and target:IsValid() then
            try_consume(inst, 0.03, "thulecite")
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
            try_consume(inst, 0.5, "moonrocknugget")
            auto_refill(inst, attacker, "moonrocknugget")
        end
    end
end
local function onattack_none(inst, attacker, target)
    if attacker ~= nil and (attacker.components.health == nil or not attacker.components.health:IsDead()) then
        if target ~= nil and target:IsValid() and math.random() < 0.05 then
            if inst.components.inventoryitem.owner ~= nil then
                inst.components.inventoryitem.owner:PushEvent("toolbroke", { tool = inst })
            end
            inst.components.container:Close()
            inst.components.container:DropEverything()
            inst:Remove()
        end
    end
end

local function OnChangeImage(inst)
    -- AnimState --
    inst.AnimState:SetBuild("glassiccutter"..get_item_type(inst))
    -- Image --
    if inst.components.inventoryitem then
        inst.components.inventoryitem:ChangeImageName("glassiccutter"..get_item_type(inst))
    end
    -- float swap data --
    if inst.components.floater then
        inst.components.floater.swap_data = {sym_build = "swap_glassiccutter"..get_item_type(inst), sym_name = "swap_glassiccutter", bank = "glassiccutter",anim="idle"}
    end
    -- If equipped --
    if inst.components.equippable and inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
        owner.AnimState:OverrideSymbol("swap_object", "swap_glassiccutter"..get_item_type(inst), "swap_glassiccutter")
    end
end

-- local tag_table = {
--     "_moonglass",
--     "_thulecite",
--     "_moonrock"
-- }
-- local function OnChangeTag(inst)
--     for _,v in pairs(tag_table) do
--         if inst:HasTag(v) then inst:RemoveTag(v) end
--     end
--     if not inst.components.container:IsEmpty() then
--         inst:AddTag(get_item_type(inst))
--     end
-- end

local function DisplayNameFn(inst)
    -- body
    -- for _,v in pairs(tag_table) do
    --     if inst:HasTag(v) then
    --         return STRINGS.NAMES[string.upper(inst.prefab..v)]
    --     end
    -- end
    local build = inst.AnimState:GetBuild()
    return STRINGS.NAMES[string.upper(build ~= nil and build or inst.prefab)]
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
    -- OnChangeTag(inst)
end

local function OnAmmoUnloaded(inst, data)
    inst.components.weapon:SetDamage(TUNING.GLASSCUTTER.DAMAGE)
    inst.components.weapon:SetOnAttack(onattack_none)
    inst.components.equippable.walkspeedmult = 1
    turn_off(inst)
    -- anim and image --
    OnChangeImage(inst)
    -- OnChangeTag(inst)
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("glassiccutter")
    inst.AnimState:SetBuild("glassiccutter")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    -- local floater_swap_data = {sym_build = "swap_darklotus", sym_name = "swap_machete", bank = "blacklotus", anim="idle_dark"}

    -- MakeInventoryFloatable(inst, "med", 0.05, {1.21, 0.4, 1.21}, true, -22, floater_swap_data)
    local floater_swap_data = {sym_build = "swap_glassiccutter", bank = "glassiccutter", anim="idle"}
    MakeInventoryFloatable(inst, "med", 0.05, {1.0, 0.4, 1.0}, true, -17.5, floater_swap_data)

    inst.entity:SetPristine()
    inst.displaynamefn = DisplayNameFn

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

    return inst
end

return Prefab("glassiccutter", fn, assets)
