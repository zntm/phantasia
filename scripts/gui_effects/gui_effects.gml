#macro GUI_EFFECT_XOFFSET 4
#macro GUI_EFFECT_YOFFSET 12
#macro GUI_EFFECT_SCALE 2
#macro GUI_EFFECT_ROW 10
#macro GUI_EFFECT_HOVER_OFFSET (8 * GUI_EFFECT_SCALE)

#macro GUI_EFFECT_TEXT_XOFFSET 0
#macro GUI_EFFECT_TEXT_YOFFSET 2
#macro GUI_EFFECT_TEXT_SCALE 0.8

function gui_effects()
{
	var _effect_data = global.effect_data;
	
	var _effect_names  = global.effect_data_names;
	var _effect_length = array_length(_effect_names);
    
	var _effect_width  = sprite_get_width(gui_Effect_Border);
	var _effect_height = sprite_get_height(gui_Effect_Border);
	
	draw_set_align(fa_center, fa_top);
	
	var _effects = obj_Player.effects;
	
	var _mouse_x = global.gui_mouse_x;
	var _mouse_y = global.gui_mouse_y;
	
	var _tick = global.world_settings.tick_speed;
	
	var _offset = 0;

	for (var i = 0; i < _effect_length; ++i)
	{
		var _name = _effect_names[i];
		
		var _effect = _effects[$ _name];
        
		if (_effect == undefined) continue;
		
		var _x = GUI_SAFE_ZONE_X + (INVENTORY_LENGTH.ROW * INVENTORY_SLOT_WIDTH * INVENTORY_SLOT_SCALE) + ((_effect_width + GUI_EFFECT_XOFFSET) * GUI_EFFECT_SCALE * (_offset %  GUI_EFFECT_ROW)) + (GUI_EFFECT_XOFFSET * GUI_EFFECT_SCALE) + (_effect_width * GUI_EFFECT_SCALE / 2);
		var _y = GUI_SAFE_ZONE_Y + (INVENTORY_SLOT_HEIGHT * INVENTORY_SLOT_SCALE / 2) + ((_effect_height + GUI_EFFECT_YOFFSET) * GUI_EFFECT_SCALE * floor(_offset / GUI_EFFECT_ROW));
		
		++_offset;
		
		var _data = _effect_data[$ _name];
		
		draw_sprite_ext(gui_Effect_Border, _data.get_is_negative(), _x, _y, GUI_EFFECT_SCALE, GUI_EFFECT_SCALE, 0, c_white, 1);
		
		carbasa_draw("effects", _name, 0, _x, _y, GUI_EFFECT_SCALE, GUI_EFFECT_SCALE, 0, c_white, 1);
		
		draw_set_halign(fa_center);
		
		var _time;
		var _timer = _effect.timer;
		
		if (_timer == -1)
		{
			_time = $"{loca_translate("gui.infinite")}";
		}
		else
		{
			var _seconds = _timer / _tick;
			var _minutes = floor(_seconds / 60);
			
			_time = ((_minutes >= 60) ? $"{floor(_minutes / 60)}:{string_pad_start(_minutes % 60, "0", 2)}:{string_pad_start(ceil(_seconds % 60), "0", 2)}" : $"{string_pad_start(_minutes % 60, "0", 2)}:{string_pad_start(ceil(_seconds % 60), "0", 2)}");
		}
		
		draw_text_transformed(_x + GUI_EFFECT_TEXT_XOFFSET, _y + GUI_EFFECT_TEXT_YOFFSET + (_effect_height * GUI_EFFECT_SCALE / 2), _time, GUI_EFFECT_TEXT_SCALE, GUI_EFFECT_TEXT_SCALE, 0);
		
		if (point_in_rectangle(_mouse_x, _mouse_y, _x - GUI_EFFECT_HOVER_OFFSET, _y - GUI_EFFECT_HOVER_OFFSET, _x + GUI_EFFECT_HOVER_OFFSET, _y + GUI_EFFECT_HOVER_OFFSET))
		{
			draw_set_halign(fa_left);
			
			var _loca = loca_translate($"effect.{_name}.name");
			
			draw_text(_mouse_x, _mouse_y, $"{_loca} {_effect.level} ({_time})");
		}
	}
}