function save_grimoire(_directory, _data)
{
	var _buffer = buffer_create(0xff, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
	var _length = array_length(_data);
	
	buffer_write(_buffer, buffer_u32, _length);
	
	for (var i = 0; i < _length; ++i)
	{
		buffer_write(_buffer, buffer_string, _data[i]);
	}
	
	buffer_save_compressed(_buffer, $"{DIRECTORY_PLAYERS}/{_directory}/grimoire.dat");
	
	buffer_delete(_buffer);
}