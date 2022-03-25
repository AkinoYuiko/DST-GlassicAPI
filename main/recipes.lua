local AddRecipe2 = AddRecipe2
GLOBAL.setfenv(1, GLOBAL)

-- 月镐和月锤 --
AddRecipe2("moonglasspickaxe",
    {Ingredient("twigs", 2), Ingredient("moonglass", 3)},
    TECH.CELESTIAL_THREE,
    {nounlock = true},
    {"MODS"}
)

AddRecipe2("moonglasshammer",
    {Ingredient("twigs", 3), Ingredient("cutgrass", 6), Ingredient("moonglass", 3)},
    TECH.CELESTIAL_THREE,
    {nounlock = true},
    {"MODS"}
)
-- AllRecipes["moonglasspickaxe"].sortkey = AllRecipes["moonglassaxe"].sortkey + 0.1
-- AllRecipes["moonglasshammer"].sortkey = AllRecipes["moonglasspickaxe"].sortkey + 0.1
