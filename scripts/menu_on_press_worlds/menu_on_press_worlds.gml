function menu_on_press_worlds(_x, _y, _id)
{
	var _directory = _id.directory;
	
	if (!directory_exists($"{DIRECTORY_WORLDS}/{_directory}/"))
	{
		room_goto(rm_Menu_List_Worlds);
		
		exit;
	}
	
	delete global.world;
	
	global.world = _id.data;
	global.world.directory = _directory;
	
	global.world.realm = "phantasia:playground";
	
	room_goto(rm_World);
}