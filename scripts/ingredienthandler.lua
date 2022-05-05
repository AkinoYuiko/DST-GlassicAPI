local function get_alter_ingredient(recname, ingredienttype)
    local recipe = AllRecipes[recname]
    if recipe then
        for i, v in ipairs(recipe.ingredients) do
            if v.type == ingredienttype then
                return recipe.alter_ingredients and recipe.alter_ingredients[i]
            end
        end
    end
end

local function add_alter_ingredient(recname, ingredienttype, alternative)
    local recipe = AllRecipes[recname]
    if recipe then
        if not recipe.alter_ingredients then
            recipe.alter_ingredients = {}
        end
        if not recipe.alter_ingredients_lookup then
            recipe.alter_ingredients_lookup = {}
        end
        for i, v in ipairs(recipe.ingredients) do
            if v.type == ingredienttype then
                if not recipe.alter_ingredients[i] then
                    recipe.alter_ingredients[i] = {}
                end
                table.insert(recipe.alter_ingredients_lookup, {
                    ingredient_index = i,
                    alternative = alternative,
                })
                table.insert(recipe.alter_ingredients[i], {
                    alternative = alternative,
                    id = #recipe.alter_ingredients_lookup,
                })
            end
        end
    end
end

local function remove_alter_ingredient(recname, ingredienttype, alternative)
end

return {
    -- GetAlterIngredient = get_alter_ingredient,
    -- AddAlterIngredient = add_alter_ingredient,
    -- RemoveAlterIngredient = remove_alter_ingredient,
}
