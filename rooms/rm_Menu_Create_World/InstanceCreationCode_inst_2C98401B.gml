enum DIFFICULTY_TYPE {
    PEACEFUL,
    EASY,
    NORMAL,
    HARD
}

if (!DEVELOPER_MODE)
{
    y += 1000;
}

text = loca_translate("menu.create_world.difficulty.normal");

on_press = function()
{
    var _v = global.world_settings.difficulty;
    
    if (_v = DIFFICULTY_TYPE.PEACEFUL)
    {
        text = loca_translate("menu.create_world.difficulty.easy");
        global.world_settings.difficulty = DIFFICULTY_TYPE.EASY;
    }
    else if (_v == DIFFICULTY_TYPE.EASY)
    {
        text = loca_translate("menu.create_world.difficulty.normal");
        global.world_settings.difficulty = DIFFICULTY_TYPE.NORMAL;
    }
    else if (_v == DIFFICULTY_TYPE.NORMAL)
    {
        text = loca_translate("menu.create_world.difficulty.hard");
        global.world_settings.difficulty = DIFFICULTY_TYPE.HARD;
    }
    else if (_v == DIFFICULTY_TYPE.HARD)
    {
        text = loca_translate("menu.create_world.difficulty.peaceful");
        global.world_settings.difficulty = DIFFICULTY_TYPE.PEACEFUL;
    }
}