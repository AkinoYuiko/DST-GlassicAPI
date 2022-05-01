GLOBAL.setfenv(1, GLOBAL)
local params = require("containers").params

params.glassiccutter =
{
    widget =
    {
        slotpos = {
            Vector3(-2, 25, 0),
        },
        animbank = "ui_alterguardianhat_1x1",
        animbuild = "ui_alterguardianhat_1x1",
        pos = Vector3(0, 20, 0),
    },
    usespecificslotsforitems = true,
    type = "hand_inv",
}

local allowed_items = TUNING.GLASSICCUTTER.ACCEPTING_PREFABS

function params.glassiccutter.itemtestfn(container, item, slot)
    return allowed_items[item.prefab]
end
