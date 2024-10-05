local function zheng(zh, en)
	local LOC = {
		zh = zh,
		zht = zh,
	}
	return LOC[locale] or en
end

version = "4.2.3"
name = "Glassic API"
author = zheng("鸭子乐园", "Ducklantis")
changelog = zheng([[
- 为GlassicAPI.AddTech增加了一个传入参数.

最近更新：
- 官方皮肤不会被视为模组皮肤了。
- 调整了reskin_tool的can_cast_fn的后处理写法。
]], [[
- Add 2rd param for GlassicAPI.AddTech.

Recent Changes:
- Official skins are now ignored by "AddModSkin" fn.
- Rewrite "can_cast_fn" in "main/reskin_tool".
]])
description = zheng("版本: ", "Version: ") .. version ..
	zheng("\n\n更新内容:\n", "\n\nChanges:\n") .. changelog .. "\n" ..
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
