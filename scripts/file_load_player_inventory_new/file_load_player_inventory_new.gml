function file_load_player_inventory_new(_uuid, _buffer2, _name)
{
	if (!directory_exists($"{DIRECTORY_PLAYERS}/{_uuid}/Inventory")) exit;
	
	var _length = array_length(global.inventory[$ _name]);
	
    global.inventory[$ _name] = file_load_snippet_inventory(_buffer2, _length, global.item_data, global.datafixer.item);
}