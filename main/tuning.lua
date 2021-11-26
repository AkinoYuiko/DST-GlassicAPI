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
    USES = 33,
    CONSUMPTION = 0.825,
    EFFECTIVENESS = 2,
    DAMAGE = wilson_attack,
    ATTACKWEAR = 2,
    SHADOW_WEAR = 0.5,
}


TUNING.GLASSICCUTTER =
{
    CONSUME_CHANCE = {
        NONE = 0.01,
        MOONGLASS = 0.25,
        MOONROCK = 0.5,
        THULECITE = 0.032,
    },
    DAMAGE = {
        NONE = wilson_attack * 2,
        SPORE = wilson_attack,
        MOONGLASS = wilson_attack * 2,
        THULECITE = wilson_attack * 1.75,
        MOONROCK = wilson_attack,
    },
    WALKSPEEDMULT = {
        GENERAL = 1,
        THULECITE = 1.1,
    }
}