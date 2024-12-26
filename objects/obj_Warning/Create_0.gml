game_set_speed(settings_get_refresh_rate(), gamespeed_fps);

transition = 600;

flares = [];

var _x = room_width  / 2;
var _y = room_height / 2;

var _hue = irandom_range(30,  225);
var _sat = irandom_range(210, 245);
var _val = irandom_range(8,   14);

repeat (irandom_range(4, 8))
{
	array_push(flares, {
		x: _x + random_range(-112, 112),
		y: _y + random_range(-112, 112),
		xvelocity: random_range(-2, 2),
		yvelocity: random_range(-2, 2),
		scale: random_range(3, 8),
		colour: make_colour_hsv(
			_hue + irandom_range(-32, 32),
			_sat + irandom_range(-14, 14),
			_val + irandom_range(-6,  6)
		)
	});
}