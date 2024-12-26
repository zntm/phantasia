function menu_refresh_settings()
{
	var _index = global.menu_settings_index;
	
	with (all)
	{
		var _index2 = id[$ "setting_index"];
		
		if (_index2 == undefined) continue;
		
		if (_index2 == _index)
		{
			if (x > room_width)
			{
				x -= room_width;
			}
		}
		else if (x < room_width)
		{
			x += room_width;
		}
		
		y = ystart;
	}
	
	var _length = array_length(global.settings_category[$ global.settings_names[_index]]);
	
	if (_length <= 5)
	{
		inst_25019C63.x = -64;
	}
	else
	{
		obj_Menu_Control.list_offset = 0;
		
		obj_Menu_Control.list_length = _length;
		obj_Menu_Control.list_size = max(0, (_length - 5) * 64);
		
		inst_25019C63.x = inst_25019C63.xstart;
		inst_25019C63.y = inst_25019C63.ystart;
	}
}