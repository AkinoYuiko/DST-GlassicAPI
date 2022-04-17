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

version = "2.17.1"
name = "Glassic API"
author = "Civi, Tony, U.N. Owen, LSSSS"
description = zh_en(
    -- zh
"[版本: "..version..[[]

更新内容:
- 更新了MergeTranslationFromPO。
- 启用新的模组图标。

"包含了皮肤组件和一套玻璃工具。"]],
    -- en
"[Version: "..version..[[]

Changelog:
- Update MergeTranslationFromPO.
- New modicon.

"Included Skin Handler API and Moon Glass Tools & Weapons."]]
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
