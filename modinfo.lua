local function zheng(zh, en)
    local LOC = {
        zh = zh,
        zht = zh,
    }
    return LOC[locale] or en
end

version = "4.1.1"
name = "Glassic API"
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 优化一处代码逻辑。

- 修复文件缺失的问题。
- 修复一处代码逻辑问题。
- 本API不再包含示例道具和皮肤，如需学习请参考【暗夜故事集】里面的写法
]], [[
- Tweak code logic.

- Fix missing anim.
- Fix a crash with "Mods In Menu" enabled.
- Migrate example items and skins to "Night Stories" mod.
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
