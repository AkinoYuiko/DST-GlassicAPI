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

version = "2.19.6"
name = "Glassic API"
author = "Civi, Tony, U.N. Owen, LSSSS"
description = zh_en(
    -- zh
"[版本: "..version..[[]

更新内容:
- 优化了GlassicAPI.BasicInitFn的代码。

- 优化了merge_internal的异常处理。
- 优化了语言字符串模板以供参考。
...
- 玻璃剑现在只能插入月亮碎片和月岩了。
- modmain中新增了许多注释，解释各种函数的用法。

"可以帮助你快速创建一个模组以及制作皮肤，同时还包含了一套玻璃工具和武器。"]],
    -- en
"[Version: "..version..[[]

Changelog:
- Improve code performance for GlassicAPI.BasicInitFn.

- Tweak code logic for merge_internal.
- Update strings format for reference.
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
