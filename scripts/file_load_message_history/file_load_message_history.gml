global.message_history = [];

function file_load_message_history()
{
	if (!file_exists("message_history.dat")) exit;
	
	var _buffer = buffer_load_decompressed("message_history.dat");
	
	var _version_major = buffer_read(_buffer, buffer_u8);
	var _version_minor = buffer_read(_buffer, buffer_u8);
	var _version_patch = buffer_read(_buffer, buffer_u8);
	var _version_type  = buffer_read(_buffer, buffer_u8);
	
	var _length = buffer_read(_buffer, buffer_u32);
	
	array_resize(global.message_history, _length);
	
	for (var i = 0; i < _length; ++i)
	{
		global.message_history[@ i] = buffer_read(_buffer, buffer_string);
	}
	
	buffer_delete(_buffer);
}