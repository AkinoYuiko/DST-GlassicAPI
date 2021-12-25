version = "2.9.7"
name = "Glassic API"
author = "Civi, Tony, LSSSS"
description = locale == "zh" and
"[版本: "..version..[[]

更新内容:
- 检查文本改用GetStatus.

- 调整SkinHandler中的一些代码格式.
- 修复换皮肤逻辑和漂浮动画的问题.
- 调整Tuning.
- 修复SkinHandler中关于ReskinEntity的一些逻辑问题.
- 修复LanguageTranslator.
- 修复一处拼写错误.
- 调整代码结构.
- 修改了部分示例皮肤的初始化逻辑.
- 参数统一在tuning处理.

包含了皮肤组件和一套玻璃工具.
]]
or
"[Version: "..version..[[]

Changelog:
- Replace descriptionfn with getstatus.

- Tweak code format in SkinHandler.
- Fix issue for reskin logic and floating anim.
- Tweak Tuning.
- Fix logic issue for "ReskinEntity" in SkinHandler.
- Fix LanguageTranslator.
- Fix a spell error.
- Tweak code format.
- Improve init logic for some example skins.
- Add Tuning.

Included Skin Handler API and Moon Glass Tools / Weapon.
]]

icon_atlas = "modicon.xml"
icon = "modicon.tex"

priority = 32767

api_version = 10
dst_compatible = true
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {}

folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
    name = name .. " - DEV"
end
