version = "2.12"
name = "Glassic API"
author = "Civi, Tony, LSSSS"
description = locale == "zh" and
"[版本: "..version..[[]

更新内容:
- 新年小更新，纪念tuni玻璃剑五连碎。

"包含了皮肤组件和一套玻璃工具。"
]] or
"[Version: "..version..[[]

Changelog:
- In memory of Tony's luck when playing FTK.

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
