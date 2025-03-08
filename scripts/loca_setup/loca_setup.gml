global.language = {}
global.font_current = fnt_Main;

function loca_setup(_namespace, _langauge)
{
	if (global.font_current != fnt_Main)
	{
		font_delete(global.font_current);
	}
	
	delete global.language;
	
	var _directory = $"{DATAFILES_RESOURCES}\\languages\\{_langauge}";
	
	if (file_exists($"{_directory}\\font.ttf"))
	{
        var _data = json_parse(buffer_load_text($"{_directory}\\font.json"));
        
		global.font_current = font_add($"{_directory}\\font.ttf", _data.size, false, false, _data.first, _data.last);
		 
		font_enable_sdf(global.font_current, true);
	}
	else if (file_exists($"{_directory}\\font.otf"))
	{
        var _data = json_parse(buffer_load_text($"{_directory}\\font.json"));
        
		global.font_current = font_add($"{_directory}\\font.otf", _data.size, false, false, _data.first, _data.last);
		
		font_enable_sdf(global.font_current, true);
	}
	else
	{
		global.font_current = fnt_Main;
	}
	
	loca_effect();
    
    global.language = {}
    
    var _json = json_parse(buffer_load_text($"{_directory}\\loca.json"));
    
    var _names = struct_get_names(_json);
    var _length = array_length(_names);
    
    for (var i = 0; i < _length; ++i)
    {
        var _name = _names[i];
        
        if (string_starts_with(_name, "*"))
        {
            global.language[$ string_delete(_name, 1, 1)] = _json[$ _name];
            
            continue;
        }
        
        global.language[$ $"{_namespace}:{_name}"] = _json[$ _name];
    }
    
    delete _json;
    
	debug_log($"[Init] Loading Language: '{string_split(_langauge, " ")[1]}'");
}