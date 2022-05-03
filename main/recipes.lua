local AddRecipe = GlassicAPI.AddRecipe
local SortAfter = GlassicAPI.RecipeSortAfter
local AddDeconstructRecipe = AddDeconstructRecipe
GLOBAL.setfenv(1, GLOBAL)

-- 月镐和月锤 --
AddRecipe("moonglasspickaxe", {Ingredient("twigs", 2), Ingredient("moonglass", 3)}, TECH.CELESTIAL_THREE, {nomods = true, nounlock = true})
SortAfter("moonglasspickaxe", "moonglassaxe")

AddRecipe("moonglasshammer", {Ingredient("twigs", 3), Ingredient("cutgrass", 6), Ingredient("moonglass", 3)}, TECH.CELESTIAL_THREE, {nomods = true, nounlock = true})
SortAfter("moonglasshammer", "moonglasspickaxe")

AddDeconstructRecipe("glassiccutter", {Ingredient("glasscutter", 1)})
