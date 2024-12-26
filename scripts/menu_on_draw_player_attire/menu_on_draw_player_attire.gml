function menu_on_draw_player_attire(_x, _y, _id, _xmultiplier, _ymultiplier, _colour)
{
	var _name = _id.name;
	
	var _attire_data = global.attire_data[$ _name];
	
	if (_attire_data == undefined) exit;
	
	_attire_data = _attire_data[_id.index];
	
	if (_attire_data == undefined)
	{
		draw_sprite_ext(spr_Attire_Empty, 0, _x * _xmultiplier, _y * _ymultiplier, _xmultiplier * 2, _ymultiplier * 2, 0, c_white, 1);
		
		exit;
	}
	
	var _colour_data = global.colour_data;
	
	shader_set(shd_Colour_Replace);
	
	shader_set_uniform_i_array(global.shader_colour_replace_match, _colour_data[8]);
	shader_set_uniform_i_array(global.shader_colour_replace_replace, _colour_data[global.player.attire[$ _name].colour]);
	
	shader_set_uniform_i(global.shader_colour_replace_amount, PLAYER_COLOUR_BASE_AMOUNT + PLAYER_COLOUR_OUTLINE_AMOUNT);
	
	carbasa_draw("attire", _attire_data.icon, 0, _x * _xmultiplier, _y * _ymultiplier, _xmultiplier * 2, _ymultiplier * 2, 0, c_white, 1);
	
	shader_reset();
}