version = "2.8.3"
name = "Glassic API"
author = "Civi, Tony, LSSSS"
description = locale == "zh" and
"[版本: "..version..[[]

更新内容:
- 修复一个崩溃问题.

- 尝试调整霜灵刀的冰冻效率计算方法.
- 重做霜灵刀的效果为冰冻敌人.

包含了皮肤组件和一套玻璃工具.
]]
or
"[Version: "..version..[[]

Changelog:
- Fix crash on attacking non-freeze-extraresistance mobs with Frost Cutter.

- Adjust the efficiency of freezing of Frost Cutter.
- Reworked Frost Cutter's effect to freeze enemy

Included Skin Handler API and Moon Glass Tools / Weapon.
]]

icon_atlas = "modicon.xml"
icon = "modicon.tex"

priority = 32767

api_version = 10
dst_compatible = true
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {}

folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
    name = name .. " - DEV"
end
