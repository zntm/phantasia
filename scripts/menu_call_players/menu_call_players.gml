function menu_call_players()
{
	static __on_press_edit = function(_x, _y, _id)
	{
		global.edit_player_directory = _id.directory;
		global.player = _id.data;
		
		menu_goto_blur(rm_Menu_Edit_Player, true);
	}
	
	static __on_press_delete = function(_x, _y, _id)
	{
		global.menu_delete_name = _id.name;
		global.menu_delete_directory = _id.directory;
		global.menu_delete_room = rm_Menu_List_Players;
		
		menu_goto_blur(rm_Menu_Delete, true);
	}
	
	if (room != rm_Menu_List_Players) exit;
	
	var _buffer = buffer_load_decompressed($"{DIRECTORY_PLAYERS}/{directory}/Info.dat");
	
	var _version_major = buffer_read(_buffer, buffer_u8);
	var _version_minor = buffer_read(_buffer, buffer_u8);
	var _version_patch = buffer_read(_buffer, buffer_u8);
	var _version_type  = buffer_read(_buffer, buffer_u8);
	
	try
	{
		var _unix = buffer_read(_buffer, buffer_f64);
		var _name = buffer_read(_buffer, buffer_string);
		
		var _hp     = buffer_read(_buffer, buffer_u16);
		var _hp_max = buffer_read(_buffer, buffer_u16);
		
		var _hotbar = buffer_read(_buffer, buffer_u8);
	
		data = {
			uuid: directory,
			last_played: _unix,
			name: _name,
			hp: _hp,
			hp_max: _hp_max,
			hotbar: _hotbar,
			attire: {},
		}
		
		var _length = array_length(global.attire_elements);
		
		repeat (_length)
		{
			var _attire = buffer_read(_buffer, buffer_string);
			
			data.attire[$ _attire] = {
				colour: buffer_read(_buffer, buffer_u16)
			}
			
			if (_attire != "body")
			{
				data.attire[$ _attire].index = buffer_read(_buffer, buffer_u16);
			}
		}
		
		text = $"{_name}\n{date_datetime_string(unix_to_datetime(_unix))}";
	
		on_press = menu_on_press_players;
		
		var _data = data;
		var _directory = directory;
		
		with (button_edit)
		{
			data = _data;
			directory = _directory;
			
			on_press = __on_press_edit;
		}
		
		with (button_delete)
		{
			name = _name;
			on_press = __on_press_delete;
		}
	}
	catch (_error)
	{
		text = "Error";
		
		debug_log($"Error initializing player\n{json_stringify(_error, true)}");
	}
	
	buffer_delete(_buffer);
}