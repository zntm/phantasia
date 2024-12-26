global.language = {}
global.font_current = fnt_Main;

function loca_setup(_langauge)
{
	if (global.font_current != fnt_Main)
	{
		font_delete(global.font_current);
	}
	
	delete global.language;
	
	var _directory = $"{DATAFILES_RESOURCES}\\languages\\{_langauge}";
	var _buffer = buffer_load($"{_directory}\\loca.json");
	
	if (file_exists($"{_directory}\\font.ttf"))
	{
		global.font_current = font_add($"{_directory}\\font.ttf", 9, false, false, 32, 0xffff);
		
		font_enable_sdf(global.font_current, true);
	}
	else if (file_exists($"{_directory}\\font.otf"))
	{
		global.font_current = font_add($"{_directory}\\font.otf", 9, false, false, 32, 0xffff);
		
		font_enable_sdf(global.font_current, true);
	}
	else
	{
		global.font_current = fnt_Main;
	}
	
	loca_effect();
	
	global.language = json_parse(buffer_read(_buffer, buffer_text));
	
	buffer_delete(_buffer);
	
	debug_log($"[Init] Loading Language: '{string_split(_langauge, " ")[1]}'");
}