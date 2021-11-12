local ENV = env
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
        if ent ~= nil then
            -- _G.SpawnPrefab("halloween_moonpuff").Transform:SetPosition(_e:GetPosition():Get())
                local _fx = SpawnPrefab("explode_reskin")
                _fx.Transform:SetPosition(ent.Transform:GetWorldPosition())
                _fx.scale_override = 1.7 * ent:GetPhysicsRadius(0.5)
        end

        -- do mutate
        if item.prefab == "alterguardianhatshard" and target.prefab == "glasscutter" then
            if target.components.halloweenmoonmutable ~= nil then
                target.components.halloweenmoonmutable:Mutate("glassiccutter")
            end
        end

        item:Remove()
        return true
    end
end

ENV.AddAction(GLASSCUTTEREX)
ENV.AddComponentAction("USEITEM", "glasssocket", function(inst, doer, target, actions, right)
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

ENV.AddStategraphState("wilson", glassic_state)
ENV.AddStategraphState("wilson_client", glassic_state)

ENV.AddStategraphActionHandler("wilson", ActionHandler(GLASSCUTTEREX, "doglassicbuild"))
ENV.AddStategraphActionHandler("wilson_client", ActionHandler(GLASSCUTTEREX, "doglassicbuild"))

ENV.AddPrefabPostInit("glasscutter", function(inst)
    if not TheWorld.ismastersim then return inst end
    inst:AddComponent("halloweenmoonmutable")
end)

ENV.AddPrefabPostInit("alterguardianhatshard", function(inst)
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
    ENV.AddPrefabPostInit(v, function(inst)
        inst:AddTag("reloaditem_ammo")
        inst:AddComponent("glassiccutter_ammo")
    end)
end

ENV.AddPrefabPostInitAny(function(inst)
    if inst:HasTag("spore") then
        inst:AddComponent("glassiccutter_ammo")
    end
end)

ENV.AddComponentAction("INVENTORY", "glassiccutter_ammo", function(inst, doer, actions, right)
    if doer.replica.inventory ~= nil and not doer.replica.inventory:IsHeavyLifting() then
        local cutter = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if cutter and cutter.prefab == "glassiccutter"
            and cutter.replica.container ~= nil and cutter.replica.container:IsOpenedBy(doer)
            and cutter.replica.container:CanTakeItemInSlot(inst) then

            table.insert(actions, ACTIONS.CHANGE_TACKLE)
        end
    end
end)
