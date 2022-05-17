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

version = "3.0.1"
name = "Glassic API"
author = "Civi, Tony, U.N. Owen, LSSSS"
changelog = zh_en([[
- 调整了SkinHandler和UpvalueUtil的文件位置。

- 重新优化皮肤组件逻辑。
- 新增skin_id支持。
- 新增SetOnequipSkinItem。
- 移除OnReskinFn。
- 移除BasicOnequipFn。
]], [[
- Tweak file location of SkinHandler and UpvalueUtil.

- Tweak Skinhandler logic and skin fns.
- Add skin_id support.
- Add SetOnequipSkinItem.
- Remove OnReskinFn.
- Remove BasicOnequipFn.
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
