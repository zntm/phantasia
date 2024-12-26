function menu_shader_function_list(_x, _y, _id, _xmultiplier, _ymultiplier)
{
	var _shader_menu_list = shader_get_uniform(shd_Menu_List, "area");
	
	_ymultiplier /= display_get_height();
	
	shader_set_uniform_f(_shader_menu_list, _ymultiplier * bbox_top, _ymultiplier * bbox_bottom);
}