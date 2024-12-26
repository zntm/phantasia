text = loca_translate("menu.create_player");

on_press = function()
{
	var _name = inst_77C1206B.text;
	
	if (string_length(_name) <= 0)
	{
		inst_3E99E608.timer = global.delta_time;
		
		exit;
	}
	
	var _directory = uuid_create(datetime_to_unix());
		
	while (directory_exists($"{DIRECTORY_PLAYERS}/{_directory}"))
	{
		_directory = uuid_create(datetime_to_unix());
	}
	
	save_player(_directory, _name, 100, 100, 0, global.player.attire, false);
	save_grimoire(_directory, [ "phantasia:hatchet" ]);
	
	menu_goto_blur(rm_Menu_List_Players, true);
}