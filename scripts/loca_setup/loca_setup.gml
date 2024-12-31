global.language = {}
global.font_current = fnt_Main;

function loca_setup(_namespace, _langauge)
{
	if (global.font_current != fnt_Main)
	{
		font_delete(global.font_current);
	}
	
	delete global.language[$ _namespace];
	
	var _directory = $"{DATAFILES_RESOURCES}\\languages\\{_langauge}";
	
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
	
	global.language[$ _namespace] = json_parse(buffer_load_text($"{_directory}\\loca.json"));
	
	debug_log($"[Init] Loading Language: '{string_split(_langauge, " ")[1]}'");
}