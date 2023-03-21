local function zheng(zh, en)
    local LOC = {
        zh = zh,
        zht = zh,
    }
    return LOC[locale] or en
end

version = "4.2"
name = "Glassic API"
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 更新GlassicAPI.InitCharacterAssets，现在强制要求crafting_menu_avatars
]], [[
- Update GlassicAPI.InitCharacterAssets. Now crafting menu avatar is required.
]])
description = zheng("版本: ", "Version: ") .. version ..
    zheng("\n\n更新内容:\n", "\n\nChangelog:\n") .. changelog .. "\n" ..
    zheng("“帮助你快速创建一个模组以及制作皮肤。”", "\"helps create mod and mod skins quickly.\"")

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
