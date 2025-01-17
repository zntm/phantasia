text = loca_translate("menu.create_world");

on_press = function()
{
    if (string_length(inst_26877629.text) <= 0)
    {
        inst_6069CEAB.timer = global.delta_time;
        
        exit;
    }
    
    var _seed;
    var _seed_string = inst_79A2930B.text;
    
    if (string_length(_seed_string) > 0)
    {
        try
        {
            _seed = real(_seed_string);
        
            if (_seed != floor(_seed)) || (string_contains(_seed_string, "."))
            {
                _seed = string_get_seed(_seed_string);
            }
        }
        catch (_error)
        {
            _seed = string_get_seed(_seed_string);
        }
    }
    else
    {
        _seed = irandom_range(-2147483647, 2147483647);
    }
    
    var _directory = uuid_create(datetime_to_unix());
        
    while (directory_exists($"{DIRECTORY_WORLDS}/{_directory}"))
    {
        _directory = uuid_create(datetime_to_unix());
    }
    
    global.world.seed = _seed;
    global.world.time = 0;
    global.world.directory = _directory;
    
    room_goto(rm_World);
}