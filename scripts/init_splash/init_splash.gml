function init_splash()
{
	var _buffer = buffer_load($"{DATAFILES_RESOURCES}\\splash.txt");

	global.splash_text = array_filter(string_split(string_replace_all(buffer_read(_buffer, buffer_text), "\r", ""), "\n"), function(_value)
	{
		return (string_length(_value) > 0);
	});
	
	buffer_delete(_buffer);
}