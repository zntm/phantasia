#macro BACKGROUND_CLOUD_DEPTH 4
#macro BACKGROUND_CLOUD_AMOUNT 40

function world_init_bg_clouds(_xmax, _ymax)
{
    randomize();
    
    var _sprite = spr_Cloud;
    /*
    if (global.world.seed == string_get_seed("nhj"))
    {
        _sprite = spr_Cloud_NHJ;
    }
    */
    
    clouds = array_create(BACKGROUND_CLOUD_AMOUNT);
    
    for (var i = 0; i < BACKGROUND_CLOUD_AMOUNT; ++i)
    {
        clouds[@ i] = {
            x: random_range(0, _xmax),
            y: random_range(0, _ymax),
            xvelocity: random_range(0.4, 1),
            xvelocity_offset: random_range(-0.1, 0.1),
            sprite: _sprite,
            index: irandom_range(0, 2),
            is_flipped: false,
            depth: irandom(BACKGROUND_CLOUD_DEPTH - 1),
            scale: random_range(0.8, 1),
            alpha: random_range(0.2, 0.8)
        }
    }
}