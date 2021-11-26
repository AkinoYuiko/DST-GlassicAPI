version = "2.9"
name = "Glassic API"
author = "Civi, Tony, LSSSS"
description = locale == "zh" and
"[版本: "..version..[[]

更新内容:
- 调整代码结构.
- 修改了部分示例皮肤的初始化逻辑.
- 参数统一在tuning处理.

包含了皮肤组件和一套玻璃工具.
]]
or
"[Version: "..version..[[]

Changelog:
- Tweak code format.
- Improve init logic for some example skins.
- Add Tuning.

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
