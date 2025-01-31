function file_load_player_inventory(_uuid)
{
	if (!directory_exists($"{DIRECTORY_PLAYERS}/{_uuid}/Inventory")) exit;
	
	var _datafixer = global.datafixer.item;
	
	var _item_data = global.item_data;
	var _inventory = global.inventory;
	
	var _files = file_read_directory($"{DIRECTORY_PLAYERS}/{_uuid}/Inventory/");
	var _files_length = array_length(_files);
	
	for (var i = 0; i < _files_length; ++i)
	{
		var _file = _files[i];
		
		var _name = string_replace(_file, ".dat", "");
		
		var _buffer = buffer_load_decompressed($"{DIRECTORY_PLAYERS}/{_uuid}/inventory/{_file}");
		
		var _version_major = buffer_read(_buffer, buffer_u8);
		var _version_minor = buffer_read(_buffer, buffer_u8);
		var _version_patch = buffer_read(_buffer, buffer_u8);
		var _version_type  = buffer_read(_buffer, buffer_u8);
		
		if (global.version_game[$ $"{VERSION_TYPE.BETA}_{VERSION_NUMBER.MAJOR}.{VERSION_NUMBER.MINOR}.{VERSION_NUMBER.PATCH}"] >= global.version_game[$ "1_1.2.0"])
		{
			file_load_player_inventory_new(_uuid, _buffer, _name);
		}
		else
		{
			file_load_player_inventory_old(_uuid, _buffer, _name);
		}
		
		buffer_delete(_buffer);
	}
}