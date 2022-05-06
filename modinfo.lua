local function loc(t)
    t.zhr = t.zh
    t.zht = t.zht or t.zh
    t.ch = t.ch or t.zh
    return t[locale] or t.en
end

local function zh_en(a, b)
    return loc({
        zh = a,
        en = b
    })
end

version = "3.0"
name = "Glassic API"
author = "Civi, Tony, U.N. Owen, LSSSS"
description = zh_en(
    -- zh
"[版本: "..version..[[]

更新内容:
- 新增模块：配方可选多种材料。

"可以帮助你快速创建一个模组以及制作皮肤，同时还包含了一套玻璃工具和武器。"]],
    -- en
"[Version: "..version..[[]

Changelog:
- New Module: Alternative Ingredients for Recipes.

"helps create mod and mod skins quickly, and includes extra Moon Glass tools and weapons."]]
)

priority = 2147483647

api_version = 10
dst_compatible = true
all_clients_require_mod = true

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
    name = name .. " - DEV"
end
