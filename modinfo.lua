version = "2.3"
name = "Glassic API"
author = "丁香女子学校"
description = locale == "zh" and
"[版本: "..version..[[]

更新内容:
- 更新 UpvalueHacker.

- 皮肤组件现在可以自动判断基础实体名是否是人物.

包含了皮肤组件和一套玻璃工具.
]]
or
"[Version: "..version..[[]

Changelog: 
- Update UpvalueHacker.

- Update SkinHandler. Characters no longer need "is_char = true".

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
