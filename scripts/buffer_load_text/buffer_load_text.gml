function buffer_load_text(_directory)
{
	var _buffer = buffer_load(_directory);
	
	var _text = buffer_read(_buffer, buffer_text);
	
	buffer_delete(_buffer);
	
	return _text;
}