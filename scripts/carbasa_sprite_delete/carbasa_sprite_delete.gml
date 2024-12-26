function carbasa_sprite_delete(_page, _sprite_name)
{
	var _sheet = global.carbasa_page[$ _page];
	
	if (_sheet == undefined)
	{
		show_debug_message($"[CARBASA] - Page '{_page}' does not exist!");
		
		exit;
	}
	
	var _data = _sheet[$ _sprite_name];
	
	if (_data == undefined)
	{
		show_debug_message($"[CARBASA] - Data for '{_sprite_name}' in page '{_page}' does not exist!");
		
		exit;
	}
	
	var _sprites = _data.sprite;
	var _width  = _data.width;
	var _height = _data.height;
	var _number = _data.number;
	
	var _blendmode = gpu_get_blendmode();
	
	surface_set_target(global.carbasa_surface[$ _page]);
	gpu_set_blendmode(bm_subtract);
	
	for (var i = 0; i < _number; ++i)
	{
		var _sprite = _sprites[i];
		var _index = _sprite.index;
		
		var _position = global.carbasa_page_position[$ _page][_index];
		
		draw_rectangle(_position[0], _position[1], _position[2], _position[3], false);
		
		global.carbasa_page_position[$ _page][@ _index][@ 0] = -1;
	}
	
	surface_reset_target();
	gpu_set_blendmode(_blendmode);
	
	delete global.carbasa_page[$ _page][$ _sprite_name];
}