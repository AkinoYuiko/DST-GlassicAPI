local Vector3 = GLOBAL.Vector3
local containers = require("containers")
local params = containers.params

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

function params.glassiccutter.itemtestfn(container, item, slot)
    local allowed_items = {
        "moonglass",
        "thulecite",
        "moonrocknugget",
    }
    return item:HasTag("spore") or table.contains(allowed_items, item.prefab)
end
