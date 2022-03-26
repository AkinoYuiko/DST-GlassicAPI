version = "2.13.3"
name = "Glassic API"
author = "Civi, Tony, LSSSS"
description = locale == "zh" and
"[版本: "..version..[[]

更新内容:
- 添加 SortRecipeToTarget 方便新版制作栏排序。

- 更新所有配方适配新版合成栏。
- 更新了 InitCharacterAssets 适配新版本。

"包含了皮肤组件和一套玻璃工具。"
]] or
"[Version: "..version..[[]

Changelog:
- Add SortRecipeToTarget for recipe sorting.

- Update recipes with AddRecipe2.
- Update InitCharacterAssets for the new version of DST.

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
