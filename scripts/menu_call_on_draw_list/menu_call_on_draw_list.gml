function menu_call_on_draw_list()
{
	if (room != rm_Menu_List_Players) && (room != rm_Menu_List_Worlds) exit;
	
	static __function = function()
	{
		var _speed = (mouse_wheel_up() - mouse_wheel_down()) * 16 * global.delta_time;
		
		if (_speed == 0) exit;
		
		var _list = obj_Menu_Control.list;
		var _list_max = obj_Menu_Control.list_max;
		
		obj_Menu_Control.list_offset = clamp(obj_Menu_Control.list_offset - _speed, 0, _list_max);
		
		var _offset = obj_Menu_Control.list_offset;
		
		var _length = array_length(_list);
		
		for (var i = 0; i < _length; ++i)
		{
			var _inst = _list[i];
			
			_inst.y = ystart - _offset;
				
			_inst.button_edit.y   = button_edit.ystart   - _offset;
			_inst.button_delete.y = button_delete.ystart - _offset;
		}
		
		obj_Menu_Control.scroll.y = lerp(inst_3449C5F9_1.bbox_top, inst_3449C5F9_1.bbox_bottom, _offset / _list_max);
	}
	
	obj_Menu_Control.on_draw = __function;
}