function menu_init_button_depth()
{
	var _depth = 0;

	with (obj_Menu_Button)
	{
		if (depth == _depth)
		{
			++_depth;
			
			continue;
		}
		
		if (depth == -1)
		{
			depth = _depth++;
		}
	}
}