function save_player(_directory, _name, _hp, _hp_max, _hotbar, _parts)
{
	var _buffer = buffer_create(0xff, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
	buffer_write(_buffer, buffer_f64, datetime_to_unix());
	buffer_write(_buffer, buffer_string, _name);
	
	buffer_write(_buffer, buffer_u16, _hp);
	buffer_write(_buffer, buffer_u16, _hp_max);
	
	buffer_write(_buffer, buffer_u8, _hotbar);
	
	var _names = global.attire_elements;
	var _length = array_length(_names);
	
	for (var i = 0; i < _length; ++i)
	{
		var _attire = _names[i];
		
		buffer_write(_buffer, buffer_string, _attire);
		
		var _part = _parts[$ _attire];
		
		buffer_write(_buffer, buffer_u16, _part.colour);
		
		if (_attire != "body")
		{
			buffer_write(_buffer, buffer_u16, _part.index);
		}
	}
	
	buffer_save_compressed(_buffer, $"{DIRECTORY_PLAYERS}/{_directory}/info.dat");
	
	buffer_delete(_buffer);
}