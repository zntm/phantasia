global.credits_data = {}

function init_data_credits()
{
    delete global.credits_data;
    
	debug_log("[Init] Loading Credits...");
	
	var _json = json_parse(buffer_load_text($"{DATAFILES_RESOURCES}\\data\\credit\\data.json"));
	
	array_foreach(_json.data, method(_json, function(_value, _index)
	{
		debug_timer("init_data_credits");
		
		var _colour = _value[$ "colour"];
		
		data[@ _index].colour = (_colour != undefined ? hex_parse(_colour) : c_white);
		
		var _data = data[_index];
		var _entries = _data.entries;
		
		var _length = array_length(_entries);
		
		for (var i = 0; i < _length; ++i)
		{
            var _ = _entries[i];
            
            if (typeof(_) == "string")
            {
                data[@ _index].entries[@ i] = {
                    name: _
                }
                
                continue;
            }
            
			var _colour2 = _[$ "colour"];
			
			if (_colour2 != undefined)
			{
				data[@ _index].entries[@ i].colour = hex_parse(_colour2);
			}
		}
		
		data[@ _index].entries_length = _length;
		
		debug_timer("init_data_credits", $"[Init] Loaded Credits: \'{_data.header}\'");
	}));
	
	global.credits_data = _json.data;
}