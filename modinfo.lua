version = "2.11.5"
name = "Glassic API"
author = "Civi, Tony, LSSSS"
description = locale == "zh" and
"[版本: "..version..[[]

更新内容:
- 调整了月灵刀消耗月亮碎片的概率。

- 优化代码提升性能。
- 调整了月灵刀消耗月亮碎片的概率。
- 移除部分物品的 drawnameoverride，现由纯净辅助自行兼容。
- 新增 ShellComponent。

"包含了皮肤组件和一套玻璃工具。"
]] or
"[Version: "..version..[[]

Changelog:
- Tweak moonglass consume rate with Gestalt Cutter.

- Improve code performance.
- Tweak moonglass consume rate with Gestalt Cutter.
- Remove default drawnameoverride from items.
- Add ShellComponent.

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
