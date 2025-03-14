function save_player_data(_id)
{
	file_save_player_access(_id);
	file_save_player_effects(_id);
	file_save_player_position(_id);
	file_save_player_inventory(_id);
}