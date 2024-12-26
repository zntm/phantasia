image_index = (irandom(9999) == 0);

randomize();

text = array_choose(global.splash_text);

on_draw = function(_x, _y, _id, _xmultiplier, _ymultiplier)
{
	_x *= _xmultiplier;
	_y *= _ymultiplier;
	
	var _xscale = 2 * _xmultiplier;
	var _yscale = 2 * _ymultiplier;
	
	draw_sprite_ext(spr_Phantasia, image_index, _x, _y + _yscale, _xscale, _yscale, 0, c_black, 0.25);
	draw_sprite_ext(spr_Phantasia, image_index, _x, _y, _xscale, _yscale, 0, c_white, 1);
	
	var _cos = cos(global.timer_delta * 0.02) * 0.25;
	
	var _xscale2 = _xmultiplier + _cos;
	var _yscale2 = _ymultiplier + _cos;
	
	var _x2 = 656 * _xmultiplier;
	var _y2 = 192 * _ymultiplier;
	
	draw_text_transformed_colour(_x2, _y2 + _yscale, text, _xscale2, _yscale2, 24, c_black, c_black, c_black, c_black, 0.25);
	draw_text_transformed_colour(_x2, _y2, text, _xscale2, _yscale2, 24, #FFB818, #FFB818, #FFB818, #FFB818, 1);
}