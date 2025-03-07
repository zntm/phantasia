function draw_vignette(_x, _y, _width, _height, _colour, _alpha)
{
    var _xscale = _width  / (2 * 128);
    var _yscale = _height / (2 * 128);
	
	draw_sprite_ext(spr_Vignette_Corner, 0, _x,          _y,            _xscale,  _yscale, 0, _colour, _alpha);
	draw_sprite_ext(spr_Vignette_Corner, 0, _x,          _y + _height,  _xscale, -_yscale, 0, _colour, _alpha);
	draw_sprite_ext(spr_Vignette_Corner, 0, _x + _width, _y + _height, -_xscale, -_yscale, 0, _colour, _alpha);
	draw_sprite_ext(spr_Vignette_Corner, 0, _x + _width, _y,           -_xscale,  _yscale, 0, _colour, _alpha);
}