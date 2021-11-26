GLOBAL.setfenv(1, GLOBAL)

-- Glassic rarity EXAMPLE
GlassicAPI.SkinHandler.SetRarity("Glassic", 0.1, { 40 / 255, 150 / 255, 128 / 255, 1 }, "glassic", "glassic_rarities")
-- STRINGS.UI.RARITY.Glassic = "Glassic" -- Display Name

-- Here is official rarity and colour
-- SKIN_RARITY_COLORS =
-- {
-- 	Common			= { 0.718, 0.824, 0.851, 1 }, -- B7D2D9 - a common item (eg t-shirt, plain gloves)
-- 	Classy			= { 0.255, 0.314, 0.471, 1 }, -- 415078 - an uncommon item (eg dress shoes, checkered trousers)
-- 	Spiffy			= { 0.408, 0.271, 0.486, 1 }, -- 68457C - a rare item (eg Trenchcoat)
-- 	Distinguished	= { 0.729, 0.455, 0.647, 1 }, -- BA74A5 - a very rare item (eg Tuxedo)
-- 	Elegant			= { 0.741, 0.275, 0.275, 1 }, -- BD4646 - an extremely rare item (eg rabbit pack, GoH base skins)

-- 	HeirloomElegant	= { 0.933, 0.365, 0.251, 1 }, -- EE5D40
-- 	Character		= { 0.718, 0.824, 0.851, 1 }, -- B7D2D9 - a character
-- 	Timeless		= { 0.424, 0.757, 0.482, 1 }, -- 6CC17B - not used
-- 	Loyal			= { 0.635, 0.769, 0.435, 1 }, -- A2C46F - a one-time giveaway (eg mini monument)
-- 	ProofOfPurchase = { 0.000, 0.478, 0.302, 1 }, -- 007A4D
-- 	Reward			= { 0.910, 0.592, 0.118, 1 }, -- E8971E - a set bonus reward
-- 	Event			= { 0.957, 0.769, 0.188, 1 }, -- F4C430 - an event item

-- 	Lustrous		= { 1.000, 1.000, 0.298, 1 }, -- FFFF4C - rarity modifier
-- 	-- #40E0D0 reserved skin colour
-- }

local function refresh_floater(inst)
    if inst.components.floater then
        if inst.components.floater:IsFloating() then
            inst.components.floater:SwitchToDefaultAnim(true)
            inst.components.floater:SwitchToFloatAnim()
        end
    end
end

-- [[ Glassic Item Skins ]] --
-- Golden Axe Victorian
local vanilla_goldenaxe_clear_fn = goldenaxe_clear_fn
goldenaxe_clear_fn = function(inst, ...)
    GlassicAPI.SetFloatData(inst, {sym_build = "swap_goldenaxe"})
    return vanilla_goldenaxe_clear_fn(inst, ...)
end

-- Moon Glass Axe
if not rawget(_G, "moonglassaxe_clear_fn") then
    moonglassaxe_clear_fn = function(inst)
        inst.AnimState:SetBank("glassaxe")
        GlassicAPI.SetFloatData(inst, { sym_build = "swap_glassaxe" })
        basic_clear_fn(inst, "glassaxe")
    end
end
ga_moonglassaxe_init_fn = function(inst, skinname, override_build)
    GlassicAPI.BasicInitFn(inst, skinname, override_build or skinname, override_build or skinname)
    GlassicAPI.BasicOnequipFn(inst, "hand", override_build or skinname, "swap_glassaxe")
end

-- Moon Glass Hammer
moonglasshammer_init_fn = function(inst, skinname, override_build)
    GlassicAPI.BasicInitFn(inst, skinname, override_build or skinname, override_build or skinname)
    GlassicAPI.BasicOnequipFn(inst, "hand", override_build or skinname, "swap_glasshammer")
end
moonglasshammer_clear_fn = function(inst)
    GlassicAPI.SetFloatData(inst, {sym_build = "glasshammer", sym_name = "swap_glasshammer", bank = "glasshammer"})
    basic_clear_fn(inst, "glasshammer")
end

-- Moon Glass Pickaxe
moonglasspickaxe_init_fn = function(inst, skinname, override_build)
    GlassicAPI.BasicInitFn(inst, skinname, override_build or skinname, override_build or skinname)
    GlassicAPI.BasicOnequipFn(inst, "hand", override_build or skinname, "swap_glasspickaxe")
end
moonglasspickaxe_clear_fn = function(inst)
    GlassicAPI.SetFloatData(inst, {sym_build = "glasspickaxe", sym_name = "swap_glasspickaxe", bank = "glasspickaxe"})
    basic_clear_fn(inst, "glasspickaxe")
end

glassiccutter_init_fn = function(inst, skinname, override_build)
    if not TheWorld.ismastersim then return end
    inst.skinname = skinname
    inst.AnimState:SetBuild(override_build or skinname)
    inst:OnChangeImage()
    refresh_floater(inst)
end
glassiccutter_clear_fn = function(inst)
    inst.AnimState:SetBuild("glassiccutter")
    inst:OnChangeImage()
    refresh_floater(inst)
end

-- [[ Set Skins ]] --
GlassicAPI.SkinHandler.AddModSkins({
    glassiccutter = { "glassiccutter_dream" },
    goldenaxe = { "goldenaxe_victorian" },
    moonglassaxe = { "moonglassaxe_northern", "moonglassaxe_victorian" },
    moonglasspickaxe = { "moonglasspickaxe_northern" },
    moonglasshammer = { "moonglasshammer_forge" },
})
