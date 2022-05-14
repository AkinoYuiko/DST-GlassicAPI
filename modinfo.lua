local function loc(t)
    t.zht = t.zht or t.zh
    return t[locale] or t.en
end

local function zh_en(a, b)
    return loc({
        zh = a,
        en = b
    })
end

version = "2.19.10"
name = "Glassic API"
author = "Civi, Tony, U.N. Owen, LSSSS"
changelog = zh_en([[
- 优化了actions的排版逻辑以便阅读。

- 修复了配方排序中的一个小问题。
...
- 玻璃剑现在只能插入月亮碎片和月岩了。
- modmain中新增了许多注释用于解释各种函数的用法。
]], [[
- Tweak code logic in main/actions for better reading.

- Fix an issue with recipe sorting.
...
- Glassic Cutter can only socket Moon Glass and Moon Rock now.
- Add documentation in modmain.
]])
description = zh_en("版本: ", "Version: ") .. version ..
    zh_en("\n\n更新内容:\n", "\n\nChangelog:\n") .. changelog ..
    zh_en("\n“帮助你快速创建一个模组以及制作皮肤，同时还包含了一套玻璃工具和武器。”", "\n\"helps create mod and mod skins quickly, and includes extra Moon Glass tools and weapons.\"")

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
