function menu_on_draw_anchor(_x, _y, _id, _xmultiplier, _ymultiplier)
{
	_x *= _xmultiplier;
	_y *= _ymultiplier;
	
	var _xscale = _id.xscale * _xmultiplier;
	var _yscale = _id.yscale * _ymultiplier;
	
	var _text = _id.text;
	
	draw_text_transformed_color(_x, _y + _yscale, _text, _xscale, _yscale, 0, c_black, c_black, c_black, c_black, 0.25);
	draw_text_transformed_color(_x, _y, _text, _xscale, _yscale, 0, c_white, c_white, c_white, c_white, 1);
}