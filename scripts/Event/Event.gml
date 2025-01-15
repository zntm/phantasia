enum EVENT_TYPE {
    PLAYER_DAMAGE,
    PLAYER_HEAL,
    PLAYER_DEATH,
    PLAYER_RESPAWN,
    CREATURE_DAMAGE,
    CREATURE_HEAL,
    CREATURE_SPAWN,
    ITEM_PICKUP,
    ITEM_DROP,
    ITEM_DESTROY,
    ITEM_EQUIP,
    ITEM_CRAFT,
    ITEM_RECIPE_UNLOCK,
    TILE_PLACE,
    CROP_GROW,
    CROP_WITHER
}

function Event() constructor
{
    static set_type = function(_type)
    {
        ___type = _type;
    }
    
    static get_type = function()
    {
        return self[$ "___type"];
    }
}