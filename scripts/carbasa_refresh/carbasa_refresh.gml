function carbasa_refresh()
{
	var _names = struct_get_names(global.carbasa_surface_buffer);
	var _length = array_length(_names);

	for (var i = 0; i < _length; ++i)
	{
		var _name = _names[i];
		
		if (!surface_exists(global.carbasa_surface[$ _name]))
		{
			var _size = global.carbasa_surface_size[$ _name];
			
			global.carbasa_surface[$ _name] = surface_create(_size, _size);
		}
	
		buffer_set_surface(global.carbasa_surface_buffer[$ _name], global.carbasa_surface[$ _name], 0);
	}
}