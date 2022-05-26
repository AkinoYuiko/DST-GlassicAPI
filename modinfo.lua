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

version = "3.3"
name = "Glassic API"
author = "Civi, Tony, U.N. Owen, LSSSS"
changelog = zh_en([[
- 完善对 Mods In Menu 的支持，现在物品皮肤也会显示在收藏了。
- 补全了缺失的文本。
- 修复月神锤缺少 SWAP_ICON 的问题。
]], [[
- Add compatibility for prefab skins with Mods In Menu.
- Add missing strings.
- Fix missing SWAP_ICON for skin: Moon Forging Hammer.
]])
description = zh_en("版本: ", "Version: ") .. version ..
    zh_en("\n\n更新内容:\n", "\n\nChangelog:\n") .. changelog .. "\n" ..
    zh_en("“帮助你快速创建一个模组以及制作皮肤，同时还包含了一套玻璃工具和武器。”", "\"helps create mod and mod skins quickly, and includes extra Moon Glass tools and weapons.\"")

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
