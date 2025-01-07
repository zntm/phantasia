if (!surface_exists(surface))
{
	surface = surface_create(max(1, room_width), max(1, room_height));
}

surface_set_target(surface);
draw_clear_alpha(c_white, 0);

var _data = global.biome_data[$ global.menu_bg_index];

var _colour = _data.sky_colour.base[1];

draw_rectangle_colour(0, 0, room_width, room_height, _colour, _colour, _colour, _colour, false);

var _background = global.background_data[$ _data.background];

global.menu_bg_position += global.delta_time * 0.6;

var _menu_bg_position = global.menu_bg_position;

var _length = array_length(_background);

for (var i = 0; i < _length; ++i)
{
	var _sprite = _background[i];
	var _sprite_width = sprite_get_width(_sprite);
	
	var _x = (_menu_bg_position * (1 + (i / 10))) % _sprite_width;

	for (var j = -1; j <= 1; ++j)
	{
		draw_sprite(_sprite, 0, _x + (_sprite_width * j), room_height);
	}
}

surface_reset_target();

var _blur = global.menu_bg_blur_value;

if (_blur <= 0)
{
	draw_surface(surface, 0, 0);
	
	exit;
}

var _blur_strength = global.settings_value.blur_strength;

if (_blur_strength <= 0)
{
    draw_surface(surface, 0, 0);
    
    exit;
}

shader_set(shd_Blur);

var _texel_width  = 1 / surface_get_height(surface);
var _texel_height = 1 / surface_get_width(surface);

shader_set_uniform_f(global.shader_blur, _texel_width, _texel_height, _blur_strength * 0.000016 * animcurve_channel_evaluate(global.menu_animcurve, _blur));

draw_surface(surface, 0, 0);

shader_reset();