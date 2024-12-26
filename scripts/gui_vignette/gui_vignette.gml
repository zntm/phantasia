function gui_vignette(_gui_width, _gui_height)
{
	var _data = global.world_data[$ global.world.realm];
	
	var _vignette = _data.vignette;
	
	var _ystart = (_vignette >> 0)  & 0xffff;
	var _yend   = (_vignette >> 16) & 0xffff;
	
	if (_ystart < 0) exit;
	
	var _alpha = normalize((obj_Player.y / TILE_SIZE), _ystart, _yend);
	
	if (_alpha > 0)
	{
		draw_sprite_stretched_ext(spr_Vignette, 0, 0, 0, _gui_width, _gui_height, (_vignette >> 32) & 0xffffff, _alpha);
	}
}