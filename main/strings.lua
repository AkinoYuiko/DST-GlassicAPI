local env = env
GLOBAL.setfenv(1, GLOBAL)

local strings =
{
    ANNOUNCE_GLASSICCUTTER_BROKE = "WEAPON BREAK!",
    ACTIONS =
    {
        CHANGE_TACKLE =
        {
            FRAG = "Set Fragment",
        },
    },
    UI =
    {
        RARITY =
        {
            Glassic = "Glassic",
        },
    },
    NAMES =
    {
        GLASSICCUTTER = "Glassic Cutter",
        GLASSICCUTTER_MOONGLASS = "Gestalt Cutter",
        GLASSICCUTTER_MOONROCK = "Frost Cutter",
        GLASSICCUTTER_DREAM = "Musou Isshin",
        GLASSICCUTTER_FROST = "Frost Mourning",
        MOONGLASSHAMMER = "Moon Glass Hammer",
        MOONGLASSPICKAXE = "Moon Glass Pickaxe",
    },
    CHARACTERS =
    {
        GENERIC =
        {
            DESCRIBE =
            {
                GLASSICCUTTER =
                {
                    GENERIC = "Sharp but probably get broken.",
                    MOONGLASS = "Sword with gestalt flash.",
                    MOONROCK = "Sword with frost energy.",
                    DREAM = "Inazuma shines eternal!",
                    FROST = "ao?",
                },
                MOONGLASSHAMMER = STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOONGLASSAXE,
                MOONGLASSPICKAXE = STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOONGLASSAXE,
            },
        },
    },
    RECIPE_DESC =
    {
        MOONGLASSHAMMER = STRINGS.RECIPE_DESC.MOONGLASSAXE,
        MOONGLASSPICKAXE = STRINGS.RECIPE_DESC.MOONGLASSAXE,
    },
    SKIN_NAMES =
    {
        glassiccutter_dream = "Musou Isshin",
        goldenaxe_victorian = "Ornate Fanciful Axe",
        moonglassaxe_northern = "Moon Nordic Axe",
        moonglassaxe_victorian = "Moon Fanciful Axe",
        moonglasshammer_forge = "Moon Forging Hammer",
        moonglasspickaxe_northern = "Moon Nordic Pickaxe",
    },
}

GlassicAPI.MergeStringsToGLOBAL(strings)
GlassicAPI.MergeTranslationFromPO(env.MODROOT.."languages")

function UpdateGlassicStrings()
    local file, errormsg = io.open(env.MODROOT .. "languages/strings.pot", "w")
    if not file then
        print("Can't generate " .. env.MODROOT .. "languages/strings.pot" .. "\n" .. tostring(errormsg))
        return
    end
    GlassicAPI.MakePOTFromStrings(file, strings)
end
