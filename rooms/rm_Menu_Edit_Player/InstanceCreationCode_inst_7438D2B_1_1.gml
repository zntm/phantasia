icon = ico_Arrow_Right;

icon_xscale = 2;
icon_yscale = 2;

on_press = function()
{
	var _attire_elements = global.attire_elements;
	
	if (++global.menu_index_attire >= array_length(_attire_elements))
	{
		global.menu_index_attire = 0;
	}
	
	menu_refresh_create_player(inst_5122C1FF_1_1, inst_91D38C3_1, inst_6DBB3E2D_1);
	
	inst_91D38C3_1.refresh();
	inst_6DBB3E2D_1.refresh();
}