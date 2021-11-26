local ENV = env
GLOBAL.setfenv(1, GLOBAL)

-- 月镐和月锤 --
ENV.AddRecipe("moonglasspickaxe",
{Ingredient("twigs", 2), Ingredient("moonglass", 3)},
RECIPETABS.CELESTIAL, TECH.CELESTIAL_THREE, nil, nil, true)

ENV.AddRecipe("moonglasshammer",
{Ingredient("twigs", 3), Ingredient("cutgrass", 6), Ingredient("moonglass", 3)},
RECIPETABS.CELESTIAL, TECH.CELESTIAL_THREE, nil, nil, true)

AllRecipes["moonglasspickaxe"].sortkey = AllRecipes["moonglassaxe"].sortkey + 0.1
AllRecipes["moonglasshammer"].sortkey = AllRecipes["moonglasspickaxe"].sortkey + 0.1