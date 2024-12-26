#macro CARBASA_SHEET_SIZE_BIT 11
#macro CARBASA_SHEET_SIZE (1 << CARBASA_SHEET_SIZE_BIT)

global.carbasa_page          = {}
global.carbasa_page_position = {}

global.carbasa_surface        = {}
global.carbasa_surface_buffer = {}

function carbasa_sprite_add(_page, _sprite, _name)
{
	static __condition = function(_page, _x, _y, _width, _height)
	{
		var _surface_bit = global.carbasa_page_position[$ _page];
		
		var _xmax = _x + _width;
		var _ymax = _y + _height;
		
		if (_xmax >= CARBASA_SHEET_SIZE) || (_ymax >= CARBASA_SHEET_SIZE)
		{
			return false;
		}
		
		var _length = array_length(_surface_bit);
		
		for (var i = 0; i < _length; ++i)
		{
			var _position = _surface_bit[i];
			
			if (_position[0] == -1) continue;
			
			if (rectangle_in_rectangle(_x, _y, _xmax, _ymax, _position[0], _position[1], _position[2], _position[3]))
			{
				return true;
			}
		}
		
		return false;
	}
	
	if (global.carbasa_page[$ _page] == undefined)
	{
		global.carbasa_page[$ _page] = {}
		
		global.carbasa_surface[$ _page] = surface_create(CARBASA_SHEET_SIZE, CARBASA_SHEET_SIZE);
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
	
	var _current_x = 0;
	var _current_y = 0;
	
	surface_set_target(global.carbasa_surface[$ _page]);
	
	for (var i = 0; i < _number; ++i)
	{
		var _break = false;
		
		for (var j = _current_x; j < CARBASA_SHEET_SIZE; ++j)
		{
			if (j >= CARBASA_SHEET_SIZE) break;
			
			for (var l = _current_y; l < CARBASA_SHEET_SIZE; ++l)
			{
				if (l + _height >= CARBASA_SHEET_SIZE)
				{
					_current_y = 0;
					
					break;
				}
				
				if (__condition(_page, j, l, _width, _height)) continue;
				
				_current_x = j;
				_current_y = l;
				
				draw_sprite(_sprite, i, j + _xoffset, l + _yoffset);
				
				var _carbasa_page_position = global.carbasa_page_position[$ _page];
				
				var _index = 0;
				var _index_length = array_length(_carbasa_page_position);
				
				while (_index < _index_length) && (_carbasa_page_position[_index][0] != -1)
				{
					if (_index >= _index_length) break;
					
					++_index;
				}
				
				global.carbasa_page[$ _page][$ _name].sprite[@ i] = {
					x: j,
					y: l,
					index: _index
				}
					
				global.carbasa_page_position[$ _page][@ _index] = [
					j,
					l,
					j + _width  - 1,
					l + _height - 1
				];
				
				_break = true;
					
				break;
			}
				
			if (_break) break;
		}
	}
	
	surface_reset_target();
	
	buffer_get_surface(global.carbasa_surface_buffer[$ _page], global.carbasa_surface[$ _page], 0);
}