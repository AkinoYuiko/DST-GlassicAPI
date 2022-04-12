local wilson_attack = 34

TUNING.MOONGLASSHAMMER =
{
    USES = 75,
    CONSUMPTION = 1.25,
    EFFECTIVENESS = 2,
    DAMAGE = wilson_attack,
    ATTACKWEAR = 2,
    SHADOW_WEAR = 0.5,
}

TUNING.MOONGLASSPICKAXE =
{
    USES = 40,
    CONSUMPTION = 1,
    EFFECTIVENESS = 3,
    DAMAGE = wilson_attack,
    ATTACKWEAR = 2,
    SHADOW_WEAR = 0.5,
}


TUNING.GLASSICCUTTER =
{
    CONSUME_RATE = {
        NONE = 0.01,
        MOONGLASS = {
            BASE = 0.1,
            MULT = 2.5,
        },
        MOONROCK = 0.5,
        THULECITE = 0.032,
        OBSIDIAN = 0.032
    },
    DAMAGE = {
        SPORE = wilson_attack,
        NONE = wilson_attack * 2,
        MOONGLASS = wilson_attack * 2,
        MOONROCK = wilson_attack * 1.25,
        THULECITE = wilson_attack * 1.75,
        OBSIDIAN = wilson_attack * 1.75,
    },
    WALKSPEEDMULT = {
        GENERAL = 1,
        THULECITE = 1.1,
    },
    MAX_OBS_CHARGE = wilson_attack / 2
}
