function menu_call_init_list()
{
	if (room != rm_Menu_List_Players) && (room != rm_Menu_List_Worlds) exit;
	
	var _length = array_length(obj_Menu_Control.list);
	
	obj_Menu_Control.list_max = floor((_length - (_length % 4 ? 4 : 8)) / 4) * 160;
	
	static __sort = function(_e1, _e2)
	{
		return _e2.data.last_played - _e1.data.last_played;
	}
	
	array_sort(obj_Menu_Control.list, __sort);
	
	var _list = obj_Menu_Control.list;
	
	for (var i = 0; i < _length; ++i)
	{
		with (_list[i])
		{
			x = 144 + ((i % 4) * 224);
			y = 172 + (floor(i / 4) * 160);
			
			xstart = x;
			ystart = y;
			
			var _y2 = y + 64;
			
			button_edit.x = x - 48;
			button_edit.y = _y2;
			
			button_edit.xstart = button_edit.x;
			button_edit.ystart = _y2;
			
			button_delete.x = x + 48;
			button_delete.y = y + 64;
			
			button_delete.xstart = button_delete.x;
			button_delete.ystart = _y2;
		}
	}
}