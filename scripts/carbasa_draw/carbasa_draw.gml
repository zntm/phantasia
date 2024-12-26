function carbasa_draw(_page, _name, _index, _x, _y, _xscale, _yscale, _rotation, _colour, _alpha)
{
	var _carbasa_page = global.carbasa_page[$ _page];
	
	if (_carbasa_page == undefined)
	{
		show_debug_message($"[CARBASA] - Page '{_page}' does not exist!");
		
		exit;
	}
	
	var _data = _carbasa_page[$ _name];
	
	if (_data == undefined)
	{
		show_debug_message($"[CARBASA] - Data for '{_name}' in page '{_page}' does not exist!");
		
		exit;
	}
	
	var _surface = global.carbasa_surface[$ _page];
	
	if (!surface_exists(_surface))
	{
		show_debug_message($"[CARBASA] - Surface '{_page}' does not exist!");
		
		var _size = global.carbasa_surface_size[$ _name];
		
		global.carbasa_surface[$ _page] = surface_create(_size, _size);
		
		buffer_set_surface(global.carbasa_surface_buffer[$ _page], global.carbasa_surface[$ _page], 0);
		
		_surface = global.carbasa_surface[$ _page];
	}
	
	var _sprite = _data.sprite;
	var _sprite_position = _sprite[_index % array_length(_sprite)];
	
	var _xoffset = _data.xoffset * _xscale;
	var _yoffset = _data.yoffset * _yscale;
	
    var _cos =  dcos(_rotation);
    var _sin = -dsin(_rotation);
    
	draw_surface_general(
		_surface,
		_sprite_position[0],
		_sprite_position[1],
		_data.width,
		_data.height,
		_x - (_xoffset * _cos) + (_yoffset * _sin),
		_y - (_xoffset * _sin) - (_yoffset * _cos),
		_xscale,
		_yscale,
		_rotation,
		_colour,
		_colour,
		_colour,
		_colour,
		_alpha
	);
}