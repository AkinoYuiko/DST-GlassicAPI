version = "2.6.6"
name = "Glassic API"
author = "Civi, Tony, LSSSS"
description = locale == "zh" and
"[版本: "..version..[[]

更新内容:
- 修复月灵刀对影怪不生效的问题.

- 修复动画位置问题.
- 修复一个主客机不同步的问题.
- 修复新攻击特效在客户端没有自动移除的问题.
- 重做月灵刀的攻击特效.
- 调整了玻璃制刀各个形态消耗碎片的概率.

包含了皮肤组件和一套玻璃工具.
]]
or
"[Version: "..version..[[]

Changelog: 
- Gestalt Cutter fx now works on shadow creatures.

- Fix an issue where fx won't show at right position.
- Fix an issue about syncing between server and client.
- Fix an issue where fx won't remove automatically on client-side.
- Rework Gestalt Cutter FX.
- Adjust chance to consume items in Glassic Cutter.

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
