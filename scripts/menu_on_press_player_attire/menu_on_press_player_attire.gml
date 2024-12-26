function menu_on_press_player_attire(_x, _y, _id)
{
	for (var i = 0; i < 6; ++i)
	{
		global.create_player_colour_on_press_inst.options[@ i].sprite_index = spr_Menu_Button_Main;
	}
	
	_id.sprite_index = spr_Menu_Button_Secondary;
	
	var _name = _id.name;
	var _index = _id.index;
	
	global.player.attire[$ _name].index = _index;
}