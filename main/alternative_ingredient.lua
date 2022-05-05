local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddComponentPostInit("playercontroller", function(self)
    self.alternative_recipe_data = {}
end)

local Builder = require("components/builder")
local make_recipe_from_menu = Builder.MakeRecipeFromMenu
function Builder:MakeRecipeFromMenu(recipe, ...)
    local original_ingredients = {}
    local playercontroller = self.inst.components.playercontroller
    local recipe_data = playercontroller and playercontroller.alternative_recipe_data[recipe.name]
    if recipe_data then
        for _, alter_id in ipairs(recipe_data) do
            local alter = recipe.alter_ingredients_lookup and recipe.alter_ingredients_lookup[alter_id]
            if alter then
                local index = alter.ingredient_index
                local ingredient = recipe.ingredients[index]
                if ingredient then
                    table.insert(original_ingredients, {
                        index = index,
                        type = ingredient.type,
                    })
                end
            end
        end
    end

    make_recipe_from_menu(self, recipe, ...)

    for _, v in ipairs(original_ingredients) do
        recipe.ingredients[v.index].type = v.type
    end
end

local RPC_NAMESPCE = "GIngredients"

local function printinvalid(rpcname, player)
    print(string.format("Invalid %s RPC from (%s) %s", rpcname, player.userid or "", player.name or ""))

    --This event is for MODs that want to handle players sending invalid rpcs
    TheWorld:PushEvent("invalidrpc", { player = player, rpcname = rpcname })

    if BRANCH == "dev" then
        --Internal testing
        assert(false, string.format("Invalid %s RPC from (%s) %s", rpcname, player.userid or "", player.name or ""))
    end
end

local function get_recipe_from_rec_id(rec_id)
    for k, v in pairs(AllRecipes) do
        if v.rpc_id == rec_id then
            return v
        end
    end
end

AddModRPCHandler(RPC_NAMESPCE, "MakeRecipeFromMenu", function(player, rec_id, skin_index, ...)
    if not (checknumber(rec_id) and optnumber(skin_index)) then
        printinvalid("MakeRecipeFromMenu", player)
        return
    end

    local builder = player.components.builder
    if builder then
        local recipe = get_recipe_from_rec_id(rec_id)
        if recipe then
            local playercontroller = self.inst.components.playercontroller
            if not playercontroller then
                return
            end
            playercontroller.alternative_recipe_data[recipe.name] = {...}
            builder:MakeRecipeFromMenu(recipe, skin_index and PREFAB_SKINS[recipe.product] and PREFAB_SKINS[recipe.product][skin_index])
            playercontroller.alternative_recipe_data[recipe.name] = nil
        end
    end
end)

-- AddModRPCHandler(RPC_NAMESPCE, "MakeRecipeFromMenu", function(player, rec_id, skin_index, ...)
--     if not (checknumber(rec_id) and optnumber(skin_index)) then
--         printinvalid("MakeRecipeFromMenu", player)
--         return
--     end

--     local builder = player.components.builder
--     if builder then
--         local recipe = get_recipe_from_rec_id(rec_id)
--         if recipe then
--             local playercontroller = self.inst.components.playercontroller
--             if not playercontroller then
--                 return
--             end
--             playercontroller.alternative_recipe_data[recipe.name] = {...}
--             builder:MakeRecipeFromMenu(recipe, skin_index and PREFAB_SKINS[recipe.product] and PREFAB_SKINS[recipe.product][skin_index])
--             playercontroller.alternative_recipe_data[recipe.name] = nil
--         end
--     end
-- end)
