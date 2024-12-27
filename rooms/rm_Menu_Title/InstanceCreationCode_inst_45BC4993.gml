image_index = (irandom(9999) == 0);

randomize();

var _splash_text = global.splash_text;
var _splash_text_date = _splash_text[$ $"{current_month}_{current_day}"];

text = array_choose((chance(0.5)) && (_splash_text_date != undefined) ? _splash_text_date : _splash_text[$ "default"]);

on_draw = function(_x, _y, _id, _xmultiplier, _ymultiplier)
{
	_x *= _xmultiplier;
	_y *= _ymultiplier;
	
	var _xscale = 2 * _xmultiplier;
	var _yscale = 2 * _ymultiplier;
	
	draw_sprite_ext(spr_Phantasia, image_index, _x, _y + _yscale, _xscale, _yscale, 0, c_black, 0.25);
	draw_sprite_ext(spr_Phantasia, image_index, _x, _y, _xscale, _yscale, 0, c_white, 1);
	
	var _cos = dcos(global.timer_delta) * 0.25;
	
	var _xscale2 = _xmultiplier + _cos;
	var _yscale2 = _ymultiplier + _cos;
	
	var _x2 = 656 * _xmultiplier;
	var _y2 = 192 * _ymultiplier;
	
	draw_text_transformed_colour(_x2, _y2 + _yscale, text, _xscale2, _yscale2, 24, c_black, c_black, c_black, c_black, 0.25);
	draw_text_transformed_colour(_x2, _y2, text, _xscale2, _yscale2, 24, #FFB818, #FFB818, #FFB818, #FFB818, 1);
}