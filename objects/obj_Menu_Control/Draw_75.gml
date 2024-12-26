if (room == rm_World) && (obj_Control.is_exiting) exit;

var _gui_width  = display_get_gui_width();
var _gui_height = display_get_gui_height();

var _display_width  = max(1, display_get_width());
var _display_height = max(1, display_get_height());

var _xoffset = xoffset;
var _yoffset = yoffset;

display_set_gui_size(_display_width, _display_height);

var _texel_width =  1 / _display_width;
var _texel_height = 1 / _display_height;

var _xmultiplier = _display_width  / room_width;
var _ymultiplier = _display_height / room_height;

if (mouse_check_button_released(mb_left))
{
	with (obj_Menu_Button)
	{
		if (!selected) continue;
		
		if (on_press != -1)
		{
			on_press(x, y, id);
		}
		
		selected = false;
		mouse_in_bbox = true;
		
		break;
	}
}

with (obj_Menu_Button)
{
	if (!selected) continue;
	
	if (on_hold != -1)
	{
		on_hold(x, y, id);
	}
}

var _goto;
var _surface_offset;

if (room == rm_World)
{
	_surface_offset = 0;
	_goto = false;
}
else
{
	var _menu_bg_fade = global.menu_bg_fade;
	
	_goto = (goto != -1);
	
	if (_menu_bg_fade == 0)
	{
		if (_goto)
		{
			offset += global.delta_time * MENU_TRANSITION_SPEED_SWIPE;
	
			if (global.menu_bg_blur) && (global.menu_bg_blur_value < offset)
			{
				global.menu_bg_blur_value = offset;
			}
	
			if (offset >= 1)
			{
				if (on_exit != -1)
				{
					on_exit();
				}
				
				room_goto(goto);
			}
	
			_surface_offset = -animcurve_channel_evaluate(global.menu_animcurve, offset) * _display_width;
		}
		else
		{
			if (offset > 0)
			{
				offset = max(0, offset - global.delta_time * MENU_TRANSITION_SPEED_SWIPE);
			}
	
			if (!global.menu_bg_blur) && (global.menu_bg_blur_value > offset)
			{
				global.menu_bg_blur_value = offset;
			}
	
			_surface_offset = animcurve_channel_evaluate(global.menu_animcurve, offset) * _display_width;
		}
	}
	else
	{
		_surface_offset = 0;
	
		var _menu_bg_fade_old = _menu_bg_fade;
		_menu_bg_fade -= global.delta_time * MENU_TRANSITION_SPEED_FADE;
	
		if (_goto) && (_menu_bg_fade <= -1)
		{
			if (on_exit != -1)
			{
				on_exit();
			}
			
			room_goto(goto);
		
			global.menu_bg_fade = 1;
		
			exit;
		}
	
		if (_menu_bg_fade_old > 0) && (_menu_bg_fade <= 0)
		{
			_menu_bg_fade = 0;
			offset = 0;
		}
	
		global.menu_bg_fade = _menu_bg_fade;
	}
}

if (on_draw != -1)
{
	on_draw(_xmultiplier, _ymultiplier, _display_width, _display_height, xoffset + _surface_offset, yoffset);
}

draw_set_align(fa_center, fa_middle);
draw_set_font(fnt_Main);
gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);

menu_control_textbox();

if (mouse_check_button_pressed(mb_left))
{
	with (obj_Menu_Textbox)
	{
		selected = false;
	}
}

var _length = array_length(surface);

for (var i = 0; i < _length; ++i)
{
	if (!surface_exists(surface[i]))
	{
		surface[@ i] = surface_create(_display_width, _display_height);
	}
	
	surface_set_target(surface[i]);
	draw_clear_alpha(c_white, 0);
	
	var _number = instance_number(obj_Menu_Button);
	
	for (var j = 0; j < _number; ++j)
	{
		with (obj_Menu_Button)
		{
			if (depth != j) continue;
	
			if (surface_index != i) || (!rectangle_in_rectangle(_xoffset + bbox_left, _yoffset + bbox_top, _xoffset + bbox_right, _yoffset + bbox_bottom, -16, -16, room_width + 16, room_height + 16)) break;
	
			var _in_rectangle = (!_goto) && (_surface_offset <= 0) && (point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom));
	
			if (_in_rectangle)
			{
				var _selectable = true;
	
				with (obj_Menu_Button)
				{
					if (!selected) continue;
		
					_selectable = false;
		
					break;
				}
	
				if (_selectable) && (active) && ((area == -1) || (point_in_rectangle(_xoffset + mouse_x, _yoffset + mouse_y, area[0], area[1], area[2], area[3]))) && (mouse_check_button_pressed(mb_left))
				{
					sfx_play("phantasia:menu.button.press", global.settings_value.master * global.settings_value.sfx);
		
					selected = true;
				}
		
				mouse_in_bbox = true;
			}
			else
			{
				mouse_in_bbox = false;
		
				if (on_hold == -1)
				{
					selected = false;
				}
			}
	
			var _colour = (selected ? c_ltgray : c_white);
		
			if (on_draw_behind != -1) && (x >= 0) && (x < room_width)
			{
				on_draw_behind(_xoffset + x, _yoffset + y, id, _xmultiplier, _ymultiplier, _colour);
			}
	
			var _x = (_xoffset + x) * _xmultiplier;
			var _y = (_yoffset + y) * _ymultiplier;
	
			var _xscale = image_xscale * _xmultiplier;
			var _yscale = image_yscale * _ymultiplier;
		
			var _edge_offset = 0;
		
			if (visible_button)
			{
				var _edge;
				var _edge_exists = false;
		
				if (!selected)
				{
					_edge = asset_get_index(sprite_get_name(sprite_index) + "_Edge");
				
					if (_edge > -1)
					{
						_edge_exists = true;
						_edge_offset = -sprite_get_height(_edge);
					}
				}
	
				if (active) && ((_in_rectangle) || (selected))
				{
					var _outline_xoffset = (_xscale * 8) + 1;
					var _outline_yoffset = (_yscale * 8) + 1;
		
					menu_button_outline(
						_x - _outline_xoffset,
						_y - _outline_yoffset + _edge_offset,
						_x + _outline_xoffset,
						_y + _outline_yoffset
					);
				}
			
				_y += _edge_offset;
			
				if (_edge_exists)
				{
					draw_sprite_ext(_edge, 0, _x, _y + (_yscale * 8), _xscale, 1, 0, c_white, 1);
				}
			
				draw_sprite_ext(sprite_index, selected, _x, _y, _xscale, _yscale, 0, c_white, 1);
			}
		
			var _xsize = bbox_right - bbox_left;
			var _scale = min((_xsize - (MENU_BUTTON_INFO_SAFE_ZONE * 2)) / _xsize * MENU_BUTTON_INFO_TEXT_SCALE, MENU_BUTTON_INFO_MIN_SCALE) * _xmultiplier;
	
			if (text != -1)
			{
				if (icon != -1)
				{
					_y += MENU_BUTTON_INFO_ICON_YOFFSET * _ymultiplier;
				
					var _v = _xmultiplier / 2;
			
					draw_sprite_ext(icon, icon_index, _x - (_v * string_width(text) * MENU_BUTTON_INFO_ICON_SCALE), _y, _scale, _scale, 0, _colour, 1);
					draw_text_transformed_colour(_x + (_v * sprite_get_width(icon) * MENU_BUTTON_INFO_TEXT_SCALE), _y, text, _scale, _scale, 0, _colour, _colour, _colour, _colour, 1);
				}
				else
				{
					draw_text_transformed_colour(_x, _y + (MENU_BUTTON_INFO_TEXT_YOFFSET * _ymultiplier), text, _scale, _scale, 0, _colour, _colour, _colour, _colour, 1);
				}
			}
			else if (icon != -1)
			{
				draw_sprite_ext(icon, icon_index, _x, _y + (MENU_BUTTON_INFO_ICON_YOFFSET * _ymultiplier), icon_xscale * _xmultiplier, icon_yscale * _ymultiplier, 0, _colour, 1);
			}
	
			if (on_draw != -1) && (x >= 0) && (x < room_width)
			{
				on_draw(_xoffset + x, _yoffset + y + (_edge_offset / _ymultiplier), id, _xmultiplier, _ymultiplier, _colour);
			}
		}
	}
	
	var _depth = 0;
	
	draw_set_align(fa_center, fa_middle);

	with (obj_Menu_Textbox)
	{
		if (surface_index != i) || (!rectangle_in_rectangle(_xoffset + bbox_left, _yoffset + bbox_top, _xoffset + bbox_right, _yoffset + bbox_bottom, -16, -16, room_width + 16, room_height + 16)) continue;
		
		var _in_rectangle = (!_goto) && (_surface_offset <= 0) && (point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom));
	
		if (_in_rectangle)
		{
			var _selectable = true;
	
			with (obj_Menu_Textbox)
			{
				if (!selected) continue;
		
				_selectable = false;
		
				break;
			}
	
			if (_selectable) && (active) && ((area == -1) || (point_in_rectangle(_xoffset + mouse_x, _yoffset + mouse_y, area[0], area[1], area[2], area[3]))) && (mouse_check_button_pressed(mb_left))
			{
				sfx_play("phantasia:menu.button.press", global.settings_value.master * global.settings_value.sfx);
		
				selected = true;
				keyboard_string = text;
			}
		}
		else if (mouse_check_button_pressed(mb_left))
		{
			selected = false;
		}
	
		if (_in_rectangle) && (active)
		{
			menu_button_outline(
				(_xoffset + bbox_left - 1) * _xmultiplier,
				(_yoffset + bbox_top  - 1) * _ymultiplier,
				(_xoffset + bbox_right  + 1) * _xmultiplier,
				(_yoffset + bbox_bottom + 1) * _ymultiplier,
			);
		}
		
		var _x = (_xoffset + x) * _xmultiplier;
		var _y = (_yoffset + y) * _ymultiplier;
		
		var _xscale = image_xscale * _xmultiplier;
		var _yscale = image_yscale * _ymultiplier;
		
		draw_sprite_ext(spr_Menu_Indent, 0, _x, _y, _xscale, _yscale, 0, c_white, 1);
		
		var _text_length = string_length(text);
		
		var _underscore = ((selected) && (_text_length < text_length) && (round((global.timer_delta % GAME_FPS) / GAME_FPS) == 0) ? "_" : "");
		
		_y += (MENU_BUTTON_INFO_TEXT_YOFFSET * _ymultiplier);
		
		if (_text_length <= 0)
		{
			var _scale = menu_textbox_text_scale(placeholder, _display_width);
			
			draw_text_transformed_colour(_x, _y, placeholder + _underscore, _scale * _xmultiplier, _scale * _ymultiplier, 0, c_white, c_white, c_white, c_white, 0.25);
		}
		else
		{
			var _ = $"{text}{_underscore}";
			
			var _scale = menu_textbox_text_scale(_, _display_width);
		
			_xscale = _scale * _xmultiplier;
			_yscale = _scale * _ymultiplier;
		
			draw_text_transformed_colour(_x, _y, _, _xscale, _yscale, 0, c_white, c_white, c_white, c_white, 0.25);
			draw_text_transformed(_x - ((string_width(_underscore) * _xscale) / 2), _y, text, _xscale, _yscale, 0);
		}
	}
	
	with (obj_Menu_Anchor)
	{
		if (surface_index != i) || (on_draw == -1) continue;
		
		on_draw(_xoffset + x + _surface_offset, _yoffset + y, id, _xmultiplier, _ymultiplier);
	}
	
	surface_reset_target();
	
	var _shader = shader[i];
	
	if (_shader != -1)
	{
		shader_set(_shader);
		
		var _shader_function = shader_function[i];
		
		if (_shader_function != -1)
		{
			_shader_function(_xoffset + x, _yoffset + y, id, _xmultiplier, _ymultiplier);
		}
		
		draw_surface(surface[i], _surface_offset, 0);
		
		shader_reset();
	}
	else
	{
		draw_surface(surface[i], _surface_offset, 0);
	}
}

draw_set_align(fa_left, fa_top);

if (room != rm_World)
{
	draw_sprite_ext(spr_Square, 0, 0, 0, _display_width, _display_height, 0, c_black, abs(global.menu_bg_fade));
}

display_set_gui_size(_gui_width, _gui_height);