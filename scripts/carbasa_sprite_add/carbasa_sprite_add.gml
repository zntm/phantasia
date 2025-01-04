global.carbasa_page          = {}
global.carbasa_page_position = {}

global.carbasa_surface        = {}
global.carbasa_surface_size   = {}
global.carbasa_surface_buffer = {}

function carbasa_sprite_add(_page, _sprite, _name)
{
	static __highest_y = function(_x, _width, _position, _position_length)
	{
		var _x2 = _x + _width;
		
		for (var m = _position_length - 1; m >= 0; --m)
		{
			var _ = _position[m];
			
			if (_[0] >= _x) && (_[2] < _x2)
			{
				return _[3];
			}
		}
		
		return 0;
	}
	
	static __condition = function(_page, _x, _y, _width, _height, _size, _position, _position_length)
	{
		var _xmax = _x + _width;
		var _ymax = _y + _height;
		
		if (_xmax >= _size) || (_ymax >= _size)
		{
			return true;
		}
		
		for (var i = 0; i < _position_length; ++i)
		{
			var _pos = _position[i];
			
			var _x1 = _pos[0];
			
			if (_x1 == -1) || (_xmax <= _x1) || (_ymax <= _pos[1]) || (_x > _pos[2]) || (_y > _pos[3]) continue;
			
			return true;
		}
		
		return false;
	}
	
	if (global.carbasa_page[$ _page] == undefined)
	{
		global.carbasa_page[$ _page] = {}
		
		global.carbasa_surface[$ _page] = surface_create(64, 64);
		global.carbasa_surface_buffer[$ _page] = buffer_create(0xffff, buffer_grow, 1);
		global.carbasa_page_position[$ _page] = [];
	}
	else if (global.carbasa_page[$ _page][$ _name] != undefined) exit;
	
	var _xoffset = sprite_get_xoffset(_sprite);
	var _yoffset = sprite_get_yoffset(_sprite);
	
	var _width  = sprite_get_width(_sprite);
	var _height = sprite_get_height(_sprite);
	var _number = sprite_get_number(_sprite);
	
	global.carbasa_page[$ _page][$ _name] = {
		sprite: array_create(_number),
		width: _width,
		height: _height,
		number: _number,
		xoffset: _xoffset,
		yoffset: _yoffset
	}
	
	var _position = global.carbasa_page_position[$ _page];
	var _position_length = array_length(_position);
	
	var _current_x = 0;
	var _current_y = __highest_y(0, _width, _position, _position_length);
	
	surface_set_target(global.carbasa_surface[$ _page]);
	
	var _size = surface_get_width(global.carbasa_surface[$ _page]);
	
	for (var i = 0; i < _number; ++i)
	{
		var _break = false;
		
		var _drawn = false;
		
		while (!_drawn)
		{
			for (var j = _current_x; j < _size; ++j)
			{
				if (j >= _size) break;
                    
				for (var l = _current_y; l < _size; ++l)
				{
					if (l + _height >= _size)
					{
						_current_y = __highest_y(j + 1, _width, _position, _position_length);
						
						break;
					}
					
					if (__condition(_page, j, l, _width, _height, _size, _position, _position_length)) continue;
					
					_current_x = j;
					_current_y = l;
					
					draw_sprite(_sprite, i, j + _xoffset, l + _yoffset);
					
					var _index = 0;
					
					while (_index < _position_length) && (_position[_index][0] != -1)
					{
						++_index;
					}
					
					global.carbasa_page[$ _page][$ _name].sprite[@ i] = [
						j,
						l,
						_index
					];
					
					global.carbasa_page_position[$ _page][@ _index] = [
						j,
						l,
						j + _width  - 1,
						l + _height - 1
					];
					
					++_position_length;
					
					_break = true;
					_drawn = true;
					
					break;
				}
				
				if (_break) break;
			}
			
			if (!_drawn)
			{
				_size *= 2;
				
				surface_reset_target();
				
				var _temp = surface_create(_size, _size);
				
				surface_set_target(_temp);
				draw_clear_alpha(c_black, 0);
				
				draw_surface(global.carbasa_surface[$ _page], 0, 0);
				
				surface_reset_target();
				
				surface_free(global.carbasa_surface[$ _page]);
				
				global.carbasa_surface[$ _page] = _temp;
				
				_current_x = 0;
				_current_y = __highest_y(0, _width, _position, _position_length);
				
				surface_set_target(global.carbasa_surface[$ _page]);
			}
		}
	}
	
	global.carbasa_surface_size[$ _page] = _size;
	
	surface_reset_target();
}