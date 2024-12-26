function menu_on_press_player_colour(_x, _y, _id)
{
	for (var i = 0; i < 6; ++i)
	{
		global.create_player_colour_on_press_inst.options[@ i].sprite_index = spr_Menu_Button_Main;
	}
	
	_id.sprite_index = spr_Menu_Button_Secondary;
	
	global.player.attire[$ _id.name].colour = _id.index;
}