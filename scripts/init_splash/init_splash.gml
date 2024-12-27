function init_splash()
{
	global.splash_text = array_filter(string_split(string_replace_all(buffer_load_text($"{DATAFILES_RESOURCES}\\splash.txt"), "\r", ""), "\n"), function(_value)
	{
		return (string_length(_value) > 0);
	});
}