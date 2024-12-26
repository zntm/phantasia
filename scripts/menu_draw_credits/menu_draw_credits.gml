function menu_draw_credits(_xmultiplier, _ymultiplier, _display_width, _display_height)
{
	static __social = function(_x, _y, _xmultiplier, _ymultiplier, _contributor, _type)
	{
		var _value = _contributor[$ _type];
		
		static __array = [ false, 0 ];
		
		if (_value == undefined)
		{
			__array[@ 0] = false;
			__array[@ 1] = false;
			
			return __array;
		}
		
		static __sprite = {
			"bluesky": ico_Bluesky,
			"twitter": ico_Twitter,
			"youtube": ico_YouTube
		}
		
		static __site = {
			"bluesky": "https://bsky.app/profile/{0}",
			"twitter": "https://x.com/{0}",
			"youtube": "https://youtube.com/@{0}"
		}
		
		var _offset = 12 * _xmultiplier;
		
		_x += _offset;
		
		var _sprite = __sprite[$ _type];
		
		var _sprite_width  = sprite_get_width(_sprite);
		var _sprite_height = sprite_get_height(_sprite);
		
		var _colour = c_white;
		
		var _x1 = (_x / _xmultiplier) - (_sprite_width  / 2);
		var _y1 = (_y / _ymultiplier) - (_sprite_height / 2);
		var _x2 = _x1 + _sprite_width;
		var _y2 = _y1 + _sprite_height;
		
		if (point_in_rectangle(mouse_x, mouse_y, _x1, _y1, _x2, _y2))
		{
			__array[@ 0] = true;
			
			_colour = c_ltgray;
			
			if (mouse_check_button_pressed(mb_left))
			{
				_colour = c_dkgray;
				
				sfx_play("phantasia:menu.button.press", global.settings_value.master * global.settings_value.sfx);
			}
			else if (mouse_check_button(mb_left))
			{
				_colour = c_dkgray;
			}
			else if (mouse_check_button_released(mb_left))
			{
				url_open(string(__site[$ _type], _value));
			}
		}
		else
		{
			__array[@ 0] = false;
		}
		
		draw_sprite_ext(_sprite, 0, _x, _y, _xmultiplier, _ymultiplier, 0, _colour, 1);
		
		__array[@ 1] = _offset + ((_sprite_width / 2) * _xmultiplier);
		
		return __array;
	}
	
	draw_set_align(fa_center, fa_middle);
	
	var _credits_data = global.credits_data;
	var _length = array_length(_credits_data);
	
	var _x = (room_width * _xmultiplier) / 2;
	var _y = (room_height + obj_Menu_Control.list_offset) * _ymultiplier;
	
	var _offset = 0;
	var _height = (font_get_size(draw_get_font()) + 8) * _ymultiplier;
	
	var _glow_colour = false;
	
	var _ystart = (room_height * 0.25) * _ymultiplier;
	var _yend   = (room_height * 0.75) * _ymultiplier;
	
	var _is_on_social_media = false;
	
	for (var i = 0; i < _length; ++i)
	{
		var _credits = _credits_data[i];
		
		var _colour = _credits.colour;
		
		var _header = loca_translate($"menu.credits.header.{_credits.header}");
		var _header_width = ((string_width(_header) / 2) + 12) * _xmultiplier;
		
		var _y2 = _y + _offset;
		
		draw_text_transformed_colour(_x, _y2, _header, _xmultiplier, _ymultiplier, 0, _colour, _colour, _colour, _colour, 1);
		
		draw_sprite_ext(spr_Credits_Header, 0, _x - _header_width, _y2, -_xmultiplier, _ymultiplier, 0, _colour, 1);
		draw_sprite_ext(spr_Credits_Header, 0, _x + _header_width, _y2,  _xmultiplier, _ymultiplier, 0, _colour, 1);
		
		if (obj_Menu_Credits_Glow.hue == -1)
		{
			obj_Menu_Credits_Glow.hue = colour_get_hue(_colour);
		}
		else if (!_glow_colour) && (_y2 > _ystart) && (_y2 < _yend)
		{
			_glow_colour = true;
			
			obj_Menu_Credits_Glow.hue = lerp_delta(obj_Menu_Credits_Glow.hue, colour_get_hue(_colour), 0.02);
		}
		
		_offset += _height;
		
		var _xscale = _xmultiplier * MENU_CREDITS_CONTRIBUTORS_SCALE;
		var _yscale = _ymultiplier * MENU_CREDITS_CONTRIBUTORS_SCALE;
		
		var _contributors = _credits.contributors;
		var _contributors_length = _credits.contributors_length;
		
		for (var j = 0; j < _contributors_length; ++j)
		{
			var _contributor = _contributors[j];
			
			var _name = _contributor.name;
			var _name_width = string_width(_name) * _xscale / 2;
			
			var _x2 = _x + _name_width;
			var _y3 = _y + _offset;
			
			var _colour2 = _contributor[$ "colour"] ?? c_white;
			
			draw_text_transformed_colour(_x, _y3, _name, _xscale, _yscale, 0, _colour2, _colour2, _colour2, _colour2, 1);
			
			var _b = __social(_x2, _y3, _xmultiplier, _ymultiplier, _contributor, "bluesky");
			
			if (_b[0])
			{
				_is_on_social_media = true;
			}
			
			_x2 += _b[1];
			
			var _t = __social(_x2, _y3, _xmultiplier, _ymultiplier, _contributor, "twitter");
			
			if (_t[0])
			{
				_is_on_social_media = true;
			}
			
			_x2 += _t[1];
			
			var _yt = __social(_x2, _y3, _xmultiplier, _ymultiplier, _contributor, "youtube");
			
			if (_yt[0])
			{
				_is_on_social_media = true;
			}
			
			_offset += _height;
		}
		
		_offset += _height;
	}
	
	draw_sprite_stretched_ext(spr_Vignette, 0, 0, 0, _display_width, _display_height, c_black, 0.5);
	
	if (_y + _offset <= 0)
	{
		if (!obj_Menu_Control.on_escape_activated)
		{
			obj_Menu_Control.on_escape();
		}
		
		obj_Menu_Control.on_escape_activated = true;
	}
	else if (!_is_on_social_media)
	{
		var _wheel = ((mouse_wheel_up()) || (keyboard_check(vk_up))) - ((mouse_wheel_down()) || (keyboard_check(vk_down)));
		
		if (_wheel != 0)
		{
			scroll_speed = _wheel * 8;
		}
		else
		{
			obj_Menu_Control.list_offset -= global.delta_time * 0.3;
		}
		
		scroll_speed = lerp_delta(scroll_speed, 0, 0.2);
		
		obj_Menu_Control.list_offset += scroll_speed;
	}
	
	obj_Menu_Control.list_offset = min(16, obj_Menu_Control.list_offset);
}