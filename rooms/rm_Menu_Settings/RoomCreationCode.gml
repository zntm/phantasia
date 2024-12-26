obj_Menu_Control.on_escape = function()
{
	save_settings();
	menu_goto_blur(rm_Menu_Title, false);
}

menu_surface(1, shd_Menu_List, method(inst_33CBB49A, menu_shader_function_list));

menu_init_button_depth_settings();
menu_refresh_settings();

obj_Menu_Control.on_draw = function()
{
	if (inst_25019C63.x == -64) exit;
	
	var _speed = (mouse_wheel_up() - mouse_wheel_down()) * 16 * global.delta_time;
	
	if (_speed == 0) exit;
	
	var _ = normalize(inst_25019C63.y - _speed, inst_46A62FFE.bbox_top, inst_46A62FFE.bbox_bottom);
	
	obj_Menu_Control.list_offset = lerp(0, obj_Menu_Control.list_size, _);
	
	var _offset = obj_Menu_Control.list_offset;
	
	with (all)
	{
		if (id[$ "list"] == undefined) continue;
		
		y = ystart - _offset;
	}
	
	inst_25019C63.y = lerp(inst_46A62FFE.bbox_top, inst_46A62FFE.bbox_bottom, _);
}