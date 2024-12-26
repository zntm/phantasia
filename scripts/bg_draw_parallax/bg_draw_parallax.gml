function bg_draw_parallax(_sprites, _index, _type, _x, _y, _player_x, _player_y, _camera_width, _camera_height, _colour, _alpha)
{
	var _sprite = _sprites[_index];
	
	if (!sprite_exists(_sprite)) exit;
	
	var _sprite_width = sprite_get_width(_sprite);
	
	if (_type == BIOME_TYPE.CAVE)
	{
		var _sprite_height = sprite_get_height(_sprite);
			
		var _xamount = ceil(((_camera_width  / _sprite_width)  + 1) / 2);
		var _yamount = ceil(((_camera_height / _sprite_height) + 1) / 2);
		
		var _multiplier = (_index + 1) * 0.05;
		
		var _xoffset = _x + (_camera_width  / 2) - ((_player_x * _multiplier) % _sprite_width);
		var _yoffset = (_camera_height / 2) - ((_player_y * _multiplier) % _sprite_height);
		
		for (var j = -_xamount; j <= _xamount; ++j)
		{
			var _bg_x = _x + (j * _sprite_width) + _xoffset;
				
			for (var l = -_yamount; l <= _yamount; ++l)
			{
				draw_sprite_ext(_sprite, 0, _bg_x, (l * _sprite_width) + _yoffset, 1, 1, 0, _colour, _alpha);
			}
		}
		
		exit;
	}
	
	var _xoffset = _x + ((_player_x * (_index + 1) * 0.05) % _sprite_width);
	
	for (var j = -2; j <= 2; ++j)
	{
		draw_sprite_ext(_sprite, 0, (j * _sprite_width) + _xoffset, _y, 1, 1, 0, _colour, _alpha);
	}
}