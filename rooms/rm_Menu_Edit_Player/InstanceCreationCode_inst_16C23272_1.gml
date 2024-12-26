text = loca_translate("menu.edit_player.save");

on_press = function()
{
	var _name = inst_77C1206B_1.text;
	
	if (string_length(_name) <= 0)
	{
		inst_3E99E608_1.timer = global.delta_time;
		
		exit;
	}
	
	save_player(global.edit_player_directory, _name, global.player.hp, global.player.hp_max, global.player.hotbar, global.player.attire, false);
	
	menu_goto_blur(rm_Menu_List_Players, true);
}