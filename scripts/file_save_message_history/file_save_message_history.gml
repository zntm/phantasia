function file_save_message_history()
{
	var _message_history = global.message_history;
	
	var _buffer = buffer_create(0xff, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
	var _length = array_length(_message_history);
	
	buffer_write(_buffer, buffer_u32, _length);
	
	for (var i = 0; i < _length; ++i)
	{
		buffer_write(_buffer, buffer_string, _message_history[i]);
	}
	
	buffer_save_compressed(_buffer, "message_history.dat");
	
	buffer_delete(_buffer);
}