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
    if not TheWorld.ismastersim then return end
    inst:AddComponent("halloweenmoonmutable")
end)

AddPrefabPostInit("alterguardianhatshard", function(inst)
    if not TheWorld.ismastersim then return end
    inst:AddComponent("glasssocket")
end)

-- right click to set ammo --
local function set_reloaditem_fragment(inst)
    inst:AddTag("reloaditem_fragment")
    if not TheWorld.ismastersim then return end
    inst:AddComponent("reloaditem")
end

for prefab in pairs(TUNING.GLASSICCUTTER.ACCEPTING_PREFABS) do
    AddPrefabPostInit(prefab, set_reloaditem_fragment)
end

local change_tackle_strfn = ACTIONS.CHANGE_TACKLE.strfn
ACTIONS.CHANGE_TACKLE.strfn = function(act)
    local item = (act.invobject and act.invobject:IsValid()) and act.invobject
    return change_tackle_strfn(act) or ((item and item:HasTag("reloaditem_fragment")) and "FRAG") or nil
end
