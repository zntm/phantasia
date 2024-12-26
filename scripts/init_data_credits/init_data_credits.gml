function init_data_credits()
{
	debug_log("[Init] Loading Credits...");
	
	var _json = json_parse(buffer_load_text($"{DATAFILES_RESOURCES}\\data\\credits\\data.json"));
	
	array_foreach(_json.data, method(_json, function(_value, _index)
	{
		debug_timer("init_data_credits");
		
		var _colour = _value[$ "colour"];
		
		data[@ _index].colour = (_colour != undefined ? hex_parse(_colour) : c_white);
		
		var _data = data[_index];
		var _contributors = _data.contributors;
		
		var _length = array_length(_contributors);
		
		for (var i = 0; i < _length; ++i)
		{
			var _colour2 = _data.contributors[i][$ "colour"];
			
			if (_colour2 != undefined)
			{
				data[@ _index].contributors[@ i].colour = hex_parse(_colour2);
			}
		}
		
		data[@ _index].contributors_length = _length;
		
		debug_timer("init_data_credits", $"[Init] Loaded Credits: \'{_data.header}\'");
	}));
	
	global.credits_data = _json.data;
}