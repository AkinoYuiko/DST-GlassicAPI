version = "2.15"
name = "Glassic API"
author = "Civi, Tony, LSSSS"
description = locale == "zh" and
"[版本: "..version..[[]

更新内容:
- 新增了一个彩蛋。

"包含了皮肤组件和一套玻璃工具。"
]] or
"[Version: "..version..[[]

Changelog:
- Add an extra scene.

"Included Skin Handler API and Moon Glass Tools & Weapons."
]]

priority = 32767

api_version = 10
dst_compatible = true
all_clients_require_mod = true

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

server_filter_tags = {}

folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
    name = name .. " - DEV"
end
