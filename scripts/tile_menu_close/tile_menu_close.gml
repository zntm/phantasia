function tile_menu_close()
{
	tile_menu_save();
	
	obj_Control.is_opened_menu = false;
	
	with (obj_Menu_Anchor)
	{
		instance_destroy();
	}
	
	with (obj_Menu_Button)
	{
		instance_destroy();
	}
	
	with (obj_Menu_Textbox)
	{
		instance_destroy();
	}
}