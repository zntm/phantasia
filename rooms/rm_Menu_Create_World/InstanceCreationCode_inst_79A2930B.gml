placeholder = loca_translate("menu.create_world.enter_seed");
text = global.world.seed;

text_length = 32;

on_update = function(_x, _y, _id, _before, _after)
{
    try
    {
        var _ = real(_after);
        
        text_length = 32 + string_starts_with(_after, "-");
    }
    catch (_error)
    {
        text_length = 32;
    }
    
    global.world.seed = _after;
}