require "prefabutil"

local assets = {
    -- Asset("ANIM", "anim/brightmare_gestalt.zip"),
    Asset("ANIM", "anim/glassic_gestalt_flash_fx.zip"),

}

local prefabs = {
    "gestalt_flash_fx",
    "electrichitsparks",
}

local function doattack(inst, target)
    if inst.components.combat:CanTarget(target) then
        inst.components.combat:DoAttack(target)

        return true
    end

end

local function onattackother(inst, data)
    local target = data.target
    local owner = inst.entity:GetParent()
    if target and target:IsValid() and inst:IsValid() then
        if inst.components.electricattacks then
            SpawnPrefab("electrichitsparks"):AlignToTarget(target, inst, true)
        end

        local atk_fx = SpawnPrefab("gestalt_flash_fx")
        

        local x, y, z = target.Transform:GetWorldPosition()
        local radius = target:GetPhysicsRadius(.5)
        local angle = ((owner or inst).Transform:GetRotation() - 90) * DEGREES
        atk_fx.Transform:SetPosition(x + math.sin(angle) * radius, 0, z + math.cos(angle) * radius)

    end
end

local props = {"externaldamagemultipliers", "damagebonus"}
local function SetTarget(inst, owner, target)
    if owner then
        for _, v in ipairs(props) do
            inst.components.combat[v] = owner.components.combat[v]
        end
        inst.components.combat.damagemultiplier = math.max(1, (owner.components.combat.damagemultiplier or 1))
        if owner.components.electricattacks then
            inst:AddComponent("electricattacks")
        end

        inst:ListenForEvent("onattackother", onattackother)

        inst.entity:SetParent(owner.entity)

        inst:DoTaskInTime( 0 , doattack, target)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    
    if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.ALTERGUARDIANHAT_GESTALT_DAMAGE)
    inst.components.combat:SetRange(TUNING.GESTALTGUARD_ATTACK_RANGE * 10)

    inst.SetTarget = SetTarget

    inst:DoTaskInTime( 0.5 , function(inst) inst:Remove() end)

    return inst
end


local function PlaySound(inst, sound)
    inst.SoundEmitter:PlaySound(sound)
end

local function MakeFx(t)

    local function startfx(proxy, name)

        local inst = CreateEntity(t.name)

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        
        inst:AddTag("FX")

        --[[Non-networked entity]]
        inst.entity:SetCanSleep(false)
        inst.persists = false

        inst.Transform:SetFromProxy(proxy.GUID)

        if t.sound ~= nil then
            inst.entity:AddSoundEmitter()
            inst:DoTaskInTime(t.sounddelay or 0, PlaySound, t.sound)
        end

        local anim_state = inst.AnimState
        anim_state:SetBank(t.bank)
        anim_state:SetBuild(t.build)
        anim_state:PlayAnimation(FunctionOrValue(t.anim)) -- THIS IS A CLIENT SIDE FUNCTION
        anim_state:SetMultColour(0.85, 0.85, 0.85, 0.85)
        anim_state:SetBloomEffectHandle("shaders/anim.ksh")
        anim_state:SetSortOrder(3)

        if t.transform ~= nil then
            inst.AnimState:SetScale(t.transform:Get())
        end

        if t.fn ~= nil then
            if t.fntime ~= nil then
                inst:DoTaskInTime(t.fntime, t.fn)
            else
                t.fn(inst)
            end
        end

        inst:ListenForEvent("animover", inst.Remove)
    end

    local function fx_fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddNetwork()

        if not TheNet:IsDedicated() then
            inst:DoTaskInTime(0, startfx, inst)
        end

        inst:AddTag("FX")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst:DoTaskInTime(1, inst.Remove)

        return inst

    end

    return Prefab(t.name, fx_fn)
end

local gestalt_flash_fx =
{
    name = "gestalt_flash_fx",
    bank = "gestalt_flash_fx",
    build = "glassic_gestalt_flash_fx",
    anim = function() return "idle_med_"..math.random(3) end,
    sound = "wanda2/characters/wanda/watch/weapon/nightmare_FX",
    fn = function(inst) inst.AnimState:SetFinalOffset(1) end,
}

return Prefab("glassic_gestalt_flash", fn, assets, prefabs),
        MakeFx(gestalt_flash_fx)
