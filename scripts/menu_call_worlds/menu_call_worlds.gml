function menu_call_worlds()
{
	static __on_press_edit = function(_x, _y, _id)
	{
		global.edit_world_directory = _id.directory;
		global.world = _id.data;
		
		menu_goto_blur(rm_Menu_Edit_World, true);
	}
	
	static __on_press_delete = function(_x, _y, _id)
	{
		global.menu_delete_name = _id.name;
		global.menu_delete_directory = _id.directory;
		global.menu_delete_room = rm_Menu_List_Worlds;
		
		menu_goto_blur(rm_Menu_Delete, true);
	}
	
	if (room != rm_Menu_List_Worlds) exit;
	
	var _buffer  = buffer_load($"{DIRECTORY_WORLDS}/{directory}/Info.dat");
	var _buffer2 = buffer_decompress(_buffer);
	
	try
	{
		data = {}
		
		var _version_major = buffer_read(_buffer2, buffer_u8);
		var _version_minor = buffer_read(_buffer2, buffer_u8);
		var _version_patch = buffer_read(_buffer2, buffer_u8);
		var _version_type  = buffer_read(_buffer2, buffer_u8);
		
		var _unix = buffer_read(_buffer2, buffer_f64);
		var _name = buffer_read(_buffer2, buffer_string);
		
		data.name = _name;
		data.seed = buffer_read(_buffer2, buffer_f64);
		
		data.time = buffer_read(_buffer2, buffer_f64);
		data.day  = buffer_read(_buffer2, buffer_u64);
		
		data.last_played = _unix;
		
		data.version_major = _version_major;
		data.version_minor = _version_minor;
		data.version_patch = _version_patch;
		data.version_type = _version_type;
		
		text = $"{_name}\n{date_datetime_string(unix_to_datetime(_unix))}";
		
		on_press = menu_on_press_worlds;
		
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
	}
	
	buffer_delete_existing(_buffer);
	buffer_delete_existing(_buffer2);
}