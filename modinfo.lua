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

version = "3.2.3"
name = "Glassic API"
author = "Civi, Tony, U.N. Owen, LSSSS"
changelog = zh_en([[
- 纠正了一些文本错误。

- 新增了一个手杖皮肤作为示例。
- 调整了skinname初始化逻辑，现在无需在init_fn中指定了。
- 移除 PostInitFloater.
- 新增 UpdateFloaterAnim.
]], [[
- Fix some text error.

- Add example skin: Gane (Cane).
- Tweak code logic for skinname init. Now it's no need to specify in skin init_fn.
- Remove PostInitFloater.
- Add UpdateFloaterAnim.
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
