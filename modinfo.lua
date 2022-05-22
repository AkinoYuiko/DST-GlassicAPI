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

version = "3.1.2"
version_compatible = "3.1.1"
name = "Glassic API"
author = "Civi, Tony, U.N. Owen, LSSSS"
changelog = zh_en([[
- 优化了部分动画和贴图。

- SkinHandler开放GetPlayerFromID
- 皮肤的test_fn传入参数修改为(skin_name, userid)
- 优化初始物品皮肤检验
]], [[
- Tweak some anim and tex.

- Add SkinHandler.GetPlayerFromID.
- test_fn for mod skins now accpets params: skin_name, userid.
- Tweak code logic for starting inventory item skins.
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
