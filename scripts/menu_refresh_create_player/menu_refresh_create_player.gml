function menu_refresh_create_player(_inst = inst_5122C1FF_1, _a = inst_91D38C3, _b = inst_6DBB3E2D)
{
	var _attire = global.attire_elements[global.menu_index_attire];
	
	_inst.text = loca_translate($"menu.create_player.attire.{_attire}");
	
	_a.page = 0;
	_b.page = 0;
}