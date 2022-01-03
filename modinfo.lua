version = "2.10.3"
name = "Glassic API"
author = "Civi, Tony, LSSSS"
description = locale == "zh" and
"[版本: "..version..[[]

更新内容:
- POT文件处理部分使用orderedPairs代替pairs。

- 调整了部分局部函数的名字。
- 更新了可支持的语言列表 _languages。
- 调整 modmain 的全局环境。

"包含了皮肤组件和一套玻璃工具。"
]] or
"[Version: "..version..[[]

Changelog:
- Replace pairs with orderedPairs to keep string orders in POT files.

- Rename some local functions.
- Update _languages table.
- Tweak global_env in modmain.

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
