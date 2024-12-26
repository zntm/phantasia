obj_Menu_Control.on_draw = function(_xmultiplier, _ymultiplier, _display_width, _display_height, _xoffset, _yoffset)
{
	draw_set_align(fa_center, fa_middle);
	
	draw_text_transformed(((room_width / 2) + _xoffset) * _xmultiplier, (80 + _yoffset) * _ymultiplier, "Press any key to update keybind.", _xmultiplier, _ymultiplier, 0);
	
	if (obj_Menu_Control.goto != -1) || (!keyboard_check_pressed(vk_anykey)) exit;
	
	save_settings();
	menu_goto_blur(rm_Menu_Settings, true);
	
	var _keys = global.menu_settings_keys;
	var _length = array_length(_keys) / 2;
	
	var i = 0;
	
	repeat (_length)
	{
		var _key = _keys[i];
			
		if (keyboard_check_pressed(_key))
		{
			global.settings_value[$ global.menu_settings_name] = _key;
				
			exit;
		}
		
		i += 2;
	}
	
	global.settings_value[$ global.menu_settings_name] = keyboard_lastkey;
}