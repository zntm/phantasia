function menu_on_draw_error(_x, _y, _id, _xmultiplier, _ymultiplier)
{
	if (timer <= 0) exit;
	
	_x *= _xmultiplier;
	_y *= _ymultiplier;
	
	var _xscale = _xmultiplier;
	var _yscale = _ymultiplier;
	
	var _text = _id.text;
	
	draw_text_transformed_color(_x, _y + _yscale, _text, _xscale, _yscale, 0, c_black, c_black, c_black, c_black, 0.25);
	draw_text_transformed_color(_x, _y, _text, _xscale, _yscale, 0, c_white, c_white, c_white, c_white, 1);
	
	timer += global.delta_time;
	
	if (timer >= 60 * 5)
	{
		timer = 0;
	}
}