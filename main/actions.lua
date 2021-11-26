local AddAction = AddAction
local AddComponentAction = AddComponentAction
local AddPrefabPostInit = AddPrefabPostInit
local AddPrefabPostInitAny = AddPrefabPostInitAny
local AddStategraphState = AddStategraphState
local AddStategraphActionHandler = AddStategraphActionHandler
GLOBAL.setfenv(1, GLOBAL)

local GLASSCUTTEREX = Action({mount_valid=true})

GLASSCUTTEREX.id = "GLASSCUTTEREX"
GLASSCUTTEREX.str = STRINGS.ACTIONS.GIVE.SOCKET
GLASSCUTTEREX.fn = function(act)
    local doer = act.doer
    local target = act.target
    if doer.components.inventory then
        local item = doer.components.inventory:RemoveItem(act.invobject)

        -- add efx
        local ent = target.components.inventoryitem and target.components.inventoryitem.owner or target
        if ent then
            local _fx = SpawnPrefab("explode_reskin")
            _fx.Transform:SetPosition(ent.Transform:GetWorldPosition())
            _fx.scale_override = 1.7 * ent:GetPhysicsRadius(0.5)
        end

        -- do mutate
        if item.prefab == "alterguardianhatshard" and target.prefab == "glasscutter" then
            if target.components.halloweenmoonmutable then
                target.components.halloweenmoonmutable:Mutate("glassiccutter")
            end
        end

        item:Remove()
        return true
    end
end

AddAction(GLASSCUTTEREX)
AddComponentAction("USEITEM", "glasssocket", function(inst, doer, target, actions, right)
    if target.prefab == "glasscutter" then
        table.insert(actions, ACTIONS.GLASSCUTTEREX)
    end
end)

local glassic_state = State({
    name = "doglassicbuild",

    onenter = function(inst)
        inst.sg:GoToState("dolongaction", 2)
    end
})

for _, v in ipairs({"wilson", "wilson_client"}) do
    AddStategraphState(v, glassic_state)
    AddStategraphActionHandler(v, ActionHandler(GLASSCUTTEREX, "doglassicbuild"))   
end

AddPrefabPostInit("glasscutter", function(inst)
    if not TheWorld.ismastersim then return inst end
    inst:AddComponent("halloweenmoonmutable")
end)

AddPrefabPostInit("alterguardianhatshard", function(inst)
    if not TheWorld.ismastersim then return inst end
    inst:AddComponent("glasssocket")
end)

-- right click to set ammo --
local allowed_items = {
    "moonglass",
    "thulecite",
    "moonrocknugget",
}

for _, v in ipairs(allowed_items) do
    AddPrefabPostInit(v, function(inst)
        inst:AddTag("reloaditem_ammo")
        inst:AddComponent("glassiccutter_ammo")
    end)
end

AddPrefabPostInitAny(function(inst)
    if inst:HasTag("spore") then
        inst:AddComponent("glassiccutter_ammo")
    end
end)

AddComponentAction("INVENTORY", "glassiccutter_ammo", function(inst, doer, actions, right)
    if doer.replica.inventory and not doer.replica.inventory:IsHeavyLifting() then
        local cutter = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if cutter and cutter.prefab == "glassiccutter"
            and cutter.replica.container and cutter.replica.container:IsOpenedBy(doer)
            and cutter.replica.container:CanTakeItemInSlot(inst)
            then

            table.insert(actions, ACTIONS.CHANGE_TACKLE)
        end
    end
end)
