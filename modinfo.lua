version = "1.5.6"
name = "[API] Glassic API"
author = locale == "zh" and "丁香女子学校" or "Civi, Tony, LSSSS"
description = locale == "zh" and
"[版本: "..version..[[]

更新内容:
- 优化了物品读取信息

包含了皮肤组件和一套玻璃工具.
]]
or
"[Version: "..version..[[]

Changelog: 
- Optimized item assets loading.

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
