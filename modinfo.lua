version = "2.5"
name = "Glassic API"
author = "Civi, Tony, LSSSS"
description = locale == "zh" and
"[版本: "..version..[[]

更新内容:
- 添加 exclusive_char 方便处理角色专属皮肤.
- 角色专属皮肤适配初始道具选择.

包含了皮肤组件和一套玻璃工具.
]]
or
"[Version: "..version..[[]

Changelog: 
- Added "exclusive_char" for exclusive item skins.
- Update for starting item skins.

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
