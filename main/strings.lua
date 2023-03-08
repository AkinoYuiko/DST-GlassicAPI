local env = env
GLOBAL.setfenv(1, GLOBAL)

local strings =
{
    ANNOUNCE_GLASSIC_BROKE = "WEAPON BREAK!",
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
    SKIN_NAMES =
    {
        cane_glass = "Gane",
        glassiccutter_dream = "Musou Isshin",
        goldenaxe_victorian = "Fanciful Luxury Axe",
        moonglassaxe_northern = "Moon Nordic Axe",
        moonglassaxe_victorian = "Fanciful Moon Glass Axe",
        moonglasshammer_forge = "Moon Forging Hammer",
        moonglasspickaxe_northern = "Moon Nordic Pickaxe",
        orangestaff_glass = "Rod Of Glass",
    },
    SKIN_DESCRIPTIONS =
    {
        cane_glass = "It's a glassic joke, I assume.",
        glassiccutter_dream = "Inazuma shines eternal!",
        goldenaxe_victorian = "An elegantly engraved golden axe.",
        moonglassaxe_northern = "A resplendent moon axe, its design reminiscent of days of yore.",
        moonglassaxe_victorian = "An elegantly engraved moon axe.",
        moonglasshammer_forge = STRINGS.SKIN_DESCRIPTIONS.hammer_forge,
        moonglasspickaxe_northern = "A resplendent moon pickaxe, its design reminiscent of days of yore.",
        orangestaff_glass = "It's a glassic joke, I assume.",
    },
    SKIN_TAG_CATEGORIES =
    {
        COLLECTION =
        {
            GLASSIC = "Glassic Collection",
        }
    },
}

GlassicAPI.MergeStringsToGLOBAL(strings)
GlassicAPI.MergeTranslationFromPO(env.MODROOT.."languages")

-- Wait for DST Fixed
scheduler:ExecuteInTime(0, function()
    local STRCODE_TALKER = rawget(_G, "STRCODE_TALKER")
    if STRCODE_TALKER then
        STRCODE_TALKER[STRINGS.ANNOUNCE_GLASSIC_BROKE] = "ANNOUNCE_GLASSIC_BROKE"
    end
end)

-- if env.is_mim_enabled then return end
function UpdateGlassicStrings()
    local file, errormsg = io.open(env.MODROOT .. "languages/strings.pot", "w")
    if not file then
        print("Can't generate " .. env.MODROOT .. "languages/strings.pot" .. "\n" .. tostring(errormsg))
        return
    end
    GlassicAPI.MakePOTFromStrings(file, strings)
end
