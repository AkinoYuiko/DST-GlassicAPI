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
    USES = 44,
    CONSUMPTION = 1,
    EFFECTIVENESS = 3,
    DAMAGE = wilson_attack,
    ATTACKWEAR = 2,
    SHADOW_WEAR = 0.5,
}


TUNING.GLASSICCUTTER =
{
    ACCEPTING_PREFABS = {
        moonglass       = true,
        moonrocknugget  = true,

        spore_tall      = true,
        spore_medium    = true,
        spore_small     = true,
    },
    CONSUME_RATE = {
        NONE = 0.01,
        MOONGLASS = {
            BASE = 0.1,
            MULT = 2.5,
        },
        MOONROCK = 0.5,
    },
    DAMAGE = {
        SPORE = wilson_attack,
        NONE = wilson_attack * 2,
        MOONGLASS = wilson_attack * 2,
        MOONROCK = wilson_attack * 1.25,
    },
}
