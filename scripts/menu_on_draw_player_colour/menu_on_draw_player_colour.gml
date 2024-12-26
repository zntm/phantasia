function menu_on_draw_player_colour(_x, _y, _id, _xmultiplier, _ymultiplier, _colour)
{
	shader_set(shd_Colour_Replace);
	
	shader_set_uniform_i_array(global.shader_colour_replace_match, global.colour_white);
	shader_set_uniform_i_array(global.shader_colour_replace_replace, global.colour_data[_id.index]);
	
	shader_set_uniform_i(global.shader_colour_replace_amount, PLAYER_COLOUR_BASE_AMOUNT + PLAYER_COLOUR_OUTLINE_AMOUNT);
	
	draw_sprite_ext(ico_Player_Colour, 0, _x * _xmultiplier, _y * _ymultiplier, _xmultiplier * 2, _ymultiplier * 2, 0, c_white, 1);
	
	shader_reset();
}