local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local UIAnim = require("widgets/uianim")

local function refresh_glassic_ammo_bg(self, invitem)
    local percent = invitem._ammopercent:value() / 63
    if percent == 0 then
        self.glassic_ammo_bg:Hide()
    else
        self.glassic_ammo_bg:Show()
    end
    self.glassic_ammo_bg:GetAnimState():SetPercent("anim", 1 - percent)
end

ENV.AddClassPostConstruct("widgets/itemtile", function(self)
    if self.item.prefab == "glassiccutter" then
        self.glassic_ammo_bg = self:AddChild(UIAnim())
        self.glassic_ammo_bg:GetAnimState():SetBank("spoiled_meter")
        self.glassic_ammo_bg:GetAnimState():SetBuild("spoiled_meter")
        self.glassic_ammo_bg:SetClickable(false)
        self.glassic_ammo_bg:MoveToBack()

        self.inst:ListenForEvent("glassicammochange", function(invitem)
            refresh_glassic_ammo_bg(self, invitem)
    	end, self.item)
        refresh_glassic_ammo_bg(self, self.item)
    end
end)
