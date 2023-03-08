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

version = "3.4.5"
name = "Glassic API"
author = "Civi, Tony, U.N. Owen, LSSSS"
changelog = zh_en([[
- 调整了AddRecipe示例中的代码。

- 优化了一处代码逻辑。
- 为玻璃魔杖皮肤新增特殊文本。
- 新增懒人魔杖皮肤：玻璃魔杖。
- 升级了 GlassicAPI.BasicInitFn。
]], [[
- Tweak code logic for example recipe description.

- Tweak code logic for hidden recipes in searching.
- Add special text string for skin: Rod of Glass.
- Add skin: Rod Of Glass (Lazy Explorer).
- Make GlassicAPI.BasicInitFn better for use.
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
