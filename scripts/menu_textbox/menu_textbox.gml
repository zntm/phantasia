function menu_control_textbox()
{
	// Used to filter out invalid characters.
	// NOTE: This feels like a quick fix, however it suits the current needs of the game.
	static __filter = function(_character)
	{
		static __string = "qwertyuiopasdfghjklzxcvbnm1234567890-=!@#$%^&*()_+[]\\;',./{}|:\"<>?";
		
		return string_contains(__string, string_lower(_character));
	}
	
	with (obj_Menu_Textbox)
	{
		if (!selected) continue;
		
		if (keyboard_check(vk_control))
		{
			var _text_length = string_length(text);
			var _text_not_empty = (_text_length > 0);
			
			// Copy Text
			if (keyboard_check_pressed(ord("C"))) && (_text_not_empty)
			{
				sfx_play("phantasia:menu.textbox.copy", global.settings_value.sfx);
				
				clipboard_set_text(text);
				
				exit;
			}
			
			// Cut Text
			if (keyboard_check_pressed(ord("X"))) && (_text_not_empty)
			{
				sfx_play("phantasia:menu.textbox.cut", global.settings_value.sfx);
				
				clipboard_set_text(text);
				
				text = "";
				keyboard_string = "";
				
				refresh = true;
				
				exit;
			}
			
			// Paste Text
			if (keyboard_check_pressed(ord("V"))) && (clipboard_has_text())
			{
				var _text = clipboard_get_text();
				
				if (keyboard_check(vk_shift))
				{
					sfx_play("phantasia:menu.textbox.paste_override", global.settings_value.sfx);
					
					text = _text;
					
					if (_text_length > text_length)
					{
						text = string_delete(text, text_length, _text_length - text_length);
					}
				}
				else
				{
					sfx_play("phantasia:menu.textbox.paste", global.settings_value.sfx);
					
					text += _text;
					
					_text_length += string_length(_text);
					
					if (_text_length > text_length)
					{
						text = string_delete(text, text_length, _text_length - text_length);
					}
				}
				
				keyboard_string = string_filter(text, __filter);
				
				exit;
			}
			
			// Clear Text
			if (keyboard_check_pressed(vk_delete) || keyboard_check_pressed(vk_backspace))
			{
				sfx_play("phantasia:menu.textbox.clear", global.settings_value.sfx);
				
				text = "";
				keyboard_string = "";
				
				refresh = true;
				
				exit;
			}
		}
		
		keyboard_string = string_filter(keyboard_string, __filter);
		
		if (text != keyboard_string)
		{
			if (string_length(keyboard_string) > text_length)
			{
				keyboard_string = text;
				
				exit;
			}
			
			if (on_update != -1)
			{
				on_update(x, y, id, text, keyboard_string);
			}
			
			sfx_play("phantasia:menu.textbox.press", global.settings_value.sfx);
			
			text = keyboard_string;
			refresh = true;
		}
		
		exit;
	}
}