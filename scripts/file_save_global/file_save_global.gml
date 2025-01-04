function file_save_global()
{
	var _buffer = buffer_create(0xff, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_text, json_stringify(global.global_data));
	
	buffer_save(_buffer, "Global.json");
	
	buffer_delete(_buffer);
}