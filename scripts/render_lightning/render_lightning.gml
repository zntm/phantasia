#macro WEATHER_LIGHTING_SPLIT 96
#macro WEATHER_LIGHTNING_OFFSET 10

function render_lightning()
{
    with (obj_Lightning)
    {
        random_set_seed(seed);
        draw_primitive_begin(pr_linestrip);
        
        var _x = xfrom;
        var _y = yfrom;
        
        var _max = min(1, life / 4);
        
        for (var i = 0; i <= _max; i += 1 / WEATHER_LIGHTING_SPLIT)
        {
            draw_vertex(lerp(_x, x, i), lerp(_y, y, i));
            
            _x += random_range(-WEATHER_LIGHTNING_OFFSET, WEATHER_LIGHTNING_OFFSET);
            _y += random_range(-WEATHER_LIGHTNING_OFFSET, WEATHER_LIGHTNING_OFFSET);
        }
        
        draw_primitive_end();
    }
}