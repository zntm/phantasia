function file_load_player_effects(_id)
{
	var _directory = $"{DIRECTORY_PLAYERS}/{_id.uuid}/effect.dat";
	
	if (!file_exists(_directory)) exit;
	
	var _buffer = buffer_load_decompressed(_directory);
	
	var _version_major = buffer_read(_buffer, buffer_u8);
	var _version_minor = buffer_read(_buffer, buffer_u8);
	var _version_patch = buffer_read(_buffer, buffer_u8);
	var _version_type  = buffer_read(_buffer, buffer_u8);
	
	file_load_snippet_effects(_buffer, _id, global.effect_data, global.datafixer.effects);
	
	buffer_delete(_buffer);
}