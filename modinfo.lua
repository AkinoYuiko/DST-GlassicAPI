version = "1.5.1"
name = "[API]Glassic API"
author = locale == "zh" and "丁香女子学校" or "Civi, Tony, LSSSS"
description = locale == "zh" and
"[版本: "..version..[[]

更新内容:
- 修复月灵刀攻击蜘蛛巢不产生月灵的问题

包含了皮肤组件和一套玻璃工具.
]]
or
"[Version: "..version..[[]

Changelog: 
- Fixed issue that Gestalt not be summoned on attacking Spider Dens.

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
