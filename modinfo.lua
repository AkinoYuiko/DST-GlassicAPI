local function loc(t)
    t.zhr = t.zh
    t.zht = t.zht or t.zh
    t.ch = t.ch or t.zh
    return t[locale] or t.en
end

local function zh_en(a, b)
    return loc({
        zh = a,
        en = b
    })
end

version = "2.18.3"
name = "Glassic API"
author = "Civi, Tony, U.N. Owen, LSSSS"
description = zh_en(
    -- zh
"[版本: "..version..[[]

更新内容:
- 完善了部分特效文件，重命名压缩包。

- GlassicAPI.AddRecipe现已支持config.hidden，等效于GlassicAPI.RecipeNoSearch.
- 重命名GlassicAPI.RecipeSortAfter/RecipeSortBefore/RecipeNoSearch.
- 新增GlassicAPI.AddTech和GlassicAPI.NoSearch。

"包含了皮肤组件和一套玻璃工具。"]],
    -- en
"[Version: "..version..[[]

Changelog:
- Rename Fx glassic_flash_fx to glash_fx.
- Add Fx glash_big_fx.

- GlassicAPI.AddRecipe now supports config.hidden, same as GlassicAPI.RecipeNoSearch.
- Rename GlassicAPI.RecipeSortAfter/RecipeSortBefore/RecipeNoSearch.
- Add GlassicAPI.AddTech and GlassicAPI.NoSearch.

"Included Skin Handler API and Moon Glass Tools & Weapons."]]
)

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
