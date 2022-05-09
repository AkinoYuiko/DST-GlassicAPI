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

version = "2.19.9"
name = "Glassic API"
author = "Civi, Tony, U.N. Owen, LSSSS"
description = zh_en(
    -- zh
"版本: "..version.. "\n\n" .. [[更新内容:
- 修复了配方排序中的一个小问题。

- 修复了Skinhandler的一个逻辑问题。
- 优化了GlassicAPI.BasicInitFn的代码。
...
- 玻璃剑现在只能插入月亮碎片和月岩了。
- modmain中新增了许多注释，解释各种函数的用法。

"可以帮助你快速创建一个模组以及制作皮肤，同时还包含了一套玻璃工具和武器。"]],
    -- en
"Version: "..version.. "\n\n" .. [[Changelog:
- Fix an issue with recipe sorting.

- Fix logic issue in SkinHandler.
- Improve code performance for GlassicAPI.BasicInitFn.
...
- Glassic Cutter can only socket Moon Glass and Moon Rock now.
- Add documentation in modmain.

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
