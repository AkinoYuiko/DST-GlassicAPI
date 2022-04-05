local AddRecipe2 = AddRecipe2
GLOBAL.setfenv(1, GLOBAL)

-- 月镐和月锤 --
AddRecipe2("moonglasspickaxe", {Ingredient("twigs", 2), Ingredient("moonglass", 3)}, TECH.CELESTIAL_THREE, {nounlock = true}, {"MODS"})
GlassicAPI.SortAfter("moonglasspickaxe", "moonglassaxe", "CRAFTING_STATION")

AddRecipe2("moonglasshammer", {Ingredient("twigs", 3), Ingredient("cutgrass", 6), Ingredient("moonglass", 3)}, TECH.CELESTIAL_THREE, {nounlock = true}, {"MODS"})
GlassicAPI.SortAfter("moonglasshammer", "moonglasspickaxe", "CRAFTING_STATION")
