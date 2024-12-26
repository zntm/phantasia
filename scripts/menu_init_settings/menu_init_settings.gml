#macro MENU_SETTINGS_OPTION_CENTER 752

#macro MENU_SETTINGS_OPTION_SLIDER_OFFSET (16 * 8)
#macro MENU_SETTINGS_OPTION_SLIDER_MIN (MENU_SETTINGS_OPTION_CENTER - MENU_SETTINGS_OPTION_SLIDER_OFFSET)
#macro MENU_SETTINGS_OPTION_SLIDER_MAX (MENU_SETTINGS_OPTION_CENTER + MENU_SETTINGS_OPTION_SLIDER_OFFSET)

function menu_init_button_depth_settings()
{
	var _settings_data = global.settings_data;
	
	static __text = function(_x, _y, _id, _xmultiplier, _ymultiplier)
	{
		var _halign = draw_get_halign();
		var _valign = draw_get_valign();
		
		draw_set_align(fa_left, fa_middle);
		
		var _text = _id.text;
		
		var _name = loca_translate($"{_text}.name");
		
		_x *= _xmultiplier;
		_y *= _ymultiplier;
		
		draw_text_transformed_color(_x, _y + _ymultiplier, _name, _xmultiplier, _ymultiplier, 0, c_black, c_black, c_black, c_black, 0.25);
		draw_text_transformed_color(_x, _y, _name, _xmultiplier, _ymultiplier, 0, c_white, c_white, c_white, c_white, 1);
	
		var _y2 = _y + (16 * _ymultiplier);
	
		var _xscale = _xmultiplier * 0.8;
		var _yscale = _ymultiplier * 0.8;
		
		var _description  = $"{_text}.description";
		var _description2 = loca_translate(_description);
	
		if (_description != _description2)
		{
			draw_text_transformed_color(_x, _y2 + _ymultiplier, _description2, _xscale, _yscale, 0, c_black, c_black, c_black, c_black, 0.25 * 0.925);
			draw_text_transformed_color(_x, _y2, _description2, _xscale, _yscale, 0, c_white, c_white, c_white, c_white, 0.925);
		}
		
		draw_set_align(_halign, _valign);
	}
	
	var _settings_value = global.settings_value;
	var _settings_names = global.settings_names;
	var _settings_category = global.settings_category;
	
	for (var i = 0; i < array_length(_settings_names); ++i)
	{
		var _settings_name = _settings_names[i];
		
		var _ = _settings_category[$ _settings_name];
		var _length = array_length(_);
		
		for (var j = 0; j < _length; ++j)
		{
			var _name = _[j];
			var _data = _settings_data[$ _name];
		
			var _y = 256 + (j * 64);
		
			with (instance_create_layer(16, _y, "Instances", obj_Menu_Anchor))
			{
				list = true;
				
				setting = _name;
				setting_index = i;
			
				text = $"settings.{_settings_name}.{_name}";
				on_draw = __text;
			
				surface_index = 1;
			}
		
			with (instance_create_layer(256, _y, "Instances", obj_Menu_Button))
			{
				list = true;
				
				setting = _name;
				setting_index = i;
			
				surface_index = 1;
			
				var _type = _data.type;
			
				if (_type == SETTINGS_TYPE.ARROW)
				{
					image_yscale = 2;
					
					x = lerp(MENU_SETTINGS_OPTION_SLIDER_MIN, MENU_SETTINGS_OPTION_SLIDER_MAX, _settings_value[$ _name] / (array_length(global.settings_data[$ setting].values) - 1));
					
					static __settings_arrow_hold = function()
					{
						var _data = global.settings_data[$ setting];
						var _length = array_length(_data.values) - 1;
						
						var _ = round(normalize(mouse_x, MENU_SETTINGS_OPTION_SLIDER_MIN, MENU_SETTINGS_OPTION_SLIDER_MAX) * _length);
						
						if (global.settings_value[$ setting] == _) exit;
						
						x = lerp(MENU_SETTINGS_OPTION_SLIDER_MIN, MENU_SETTINGS_OPTION_SLIDER_MAX, _ / _length);
						
						global.settings_value[$ setting] = _;

						var _on_update = _data.on_update;
						
						if (_on_update != undefined)
						{
							_on_update(setting, _);
						}
					}
					
					static __settings_arrow_draw = function(_x, _y, _id, _xmultiplier, _ymultiplier)
					{
						draw_text_transformed(_x * _xmultiplier, _y * _ymultiplier, global.settings_data[$ setting].values[global.settings_value[$ setting]], _xmultiplier, _ymultiplier, 0);
					}
					
					static __settings_arrow_draw_behind = function(_x, _y, _id, _xmultiplier, _ymultiplier)
					{
						draw_sprite_ext(spr_Menu_Indent, 0, MENU_SETTINGS_OPTION_CENTER * _xmultiplier, _y * _ymultiplier, 32 * _xmultiplier, _ymultiplier, 0, c_white, 1);
					}
					
					on_hold = method(id, __settings_arrow_hold);
					on_draw = method(id, __settings_arrow_draw);
					on_draw_behind = method(id, __settings_arrow_draw_behind);
				}
				else if (_type == SETTINGS_TYPE.HOTKEY)
				{
					image_xscale = 8;
					image_yscale = 2;
					
					x = 832;
					
					static __settings_hotkey_press = function()
					{
						global.menu_settings_name = setting;
						
						menu_goto_blur(rm_Menu_Settings_Keybind, true);
					}
					
					static __settings_hotkey_draw = function(_x, _y, _id, _xmultiplier, _ymultiplier)
					{
						var _char = global.settings_value[$ setting];
						
						var _char2 = string_upper(chr(_char));
						
						var _keys = global.menu_settings_keys;
						var _length = array_length(_keys) / 2;
						
						for (var i = 0; i < _length; ++i)
						{
							var _index = i * 2;
							
							if (_char == _keys[_index])
							{
								_char2 = _keys[_index + 1];
							}
						}
						
						draw_text_transformed(_x * _xmultiplier, _y * _ymultiplier, _char2, 2 * _xmultiplier, 2 * _ymultiplier, 0);
					}
					
					on_draw = method(id, __settings_hotkey_draw);
					on_press = method(id, __settings_hotkey_press);
				}
				else if (_type == SETTINGS_TYPE.SLIDER)
				{
					image_yscale = 2;
					
					x = lerp(MENU_SETTINGS_OPTION_SLIDER_MIN, MENU_SETTINGS_OPTION_SLIDER_MAX, _settings_value[$ _name]);
					
					static __settings_slider_hold = function()
					{
						var _ = normalize(mouse_x, MENU_SETTINGS_OPTION_SLIDER_MIN, MENU_SETTINGS_OPTION_SLIDER_MAX);
						
						if (global.settings_value[$ setting] == _) exit;
						
						x = clamp(mouse_x, MENU_SETTINGS_OPTION_SLIDER_MIN, MENU_SETTINGS_OPTION_SLIDER_MAX);
						
						global.settings_value[$ setting] = _;

						var _on_update = global.settings_data[$ setting].on_update;
						
						if (_on_update != undefined)
						{
							_on_update(setting, _);
						}
					}
				
					static __settings_slider_draw = function(_x, _y, _id, _xmultiplier, _ymultiplier)
					{
						draw_sprite_ext(spr_Menu_Indent, 0, MENU_SETTINGS_OPTION_CENTER * _xmultiplier, _y * _ymultiplier, 32 * _xmultiplier, _ymultiplier, 0, c_white, 1);
					}
				
					on_hold = method(id, __settings_slider_hold);
					on_draw_behind = method(id, __settings_slider_draw);
				}
				else if (_type == SETTINGS_TYPE.SWITCH)
				{
					image_yscale = 2;
					
					x = 832 + (_settings_value[$ _name] * 16);
					
					static __settings_switch_press = function()
					{
						var _ = !global.settings_value[$ setting];
						
						x = 832 + (_ * 16);
						
						global.settings_value[$ setting] = _;
						
						var _on_press = global.settings_data[$ setting].on_press;
						
						if (_on_press != undefined)
						{
							_on_press(setting, _);
						}
					}
					
					static __settings_switch_draw = function(_x, _y, _id, _xmultiplier, _ymultiplier)
					{
						draw_sprite_ext(spr_Menu_Indent, 0, 840 * _xmultiplier, _y * _ymultiplier, 4 * _xmultiplier, _ymultiplier, 0, c_white, 1);
					}
					
					on_press = method(id, __settings_switch_press);
					on_draw_behind = method(id, __settings_switch_draw);
				}
			}
		}
	}
}