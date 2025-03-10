function gui_vignette(_gui_width, _gui_height)
{
	var _data = global.world_data[$ global.world.realm];
	
	var _ystart = _data.get_vignette_range_min();
	var _yend   = _data.get_vignette_range_max();
	
	if (_ystart == 0) && (_yend == 0) exit;
	
	var _alpha = normalize((obj_Player.y / TILE_SIZE), _ystart, _yend);
	
	if (_alpha > 0)
	{
        draw_vignette(0, 0, _gui_width, _gui_height, _data.get_vignette_colour(), _alpha);
	}
}