function file_load_player_inventory_new(_uuid, _buffer2, _name)
{
	if (!directory_exists($"{DIRECTORY_PLAYERS}/{_uuid}/Inventory")) exit;
	
	var _datafixer = global.datafixer.item;
	
	var _item_data = global.item_data;
	var _inventory = global.inventory;
	
	var _u = array_length(_inventory[$ _name]);
	
    global.inventory[$ _name] = file_load_snippet_inventory(_buffer2, _u, _item_data, _datafixer);
}