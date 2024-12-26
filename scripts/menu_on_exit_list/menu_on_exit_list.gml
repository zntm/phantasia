function menu_on_exit_list()
{
	var _list = obj_Menu_Control.list;
	var _length = array_length(_list);
	
	for (var i = 0; i < _length; ++i)
	{
		delete _list[i].data;
	}
}