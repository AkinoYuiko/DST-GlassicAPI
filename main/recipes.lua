local AddRecipe = GlassicAPI.AddRecipe
local SortAfter = GlassicAPI.SortAfter
GLOBAL.setfenv(1, GLOBAL)

-- 月镐和月锤 --
AddRecipe("moonglasspickaxe", {Ingredient("twigs", 2), Ingredient("moonglass", 3)}, TECH.CELESTIAL_THREE, {nounlock = true})
SortAfter("moonglasspickaxe", "moonglassaxe", "CRAFTING_STATION")

AddRecipe("moonglasshammer", {Ingredient("twigs", 3), Ingredient("cutgrass", 6), Ingredient("moonglass", 3)}, TECH.CELESTIAL_THREE, {nounlock = true})
SortAfter("moonglasshammer", "moonglasspickaxe", "CRAFTING_STATION")
