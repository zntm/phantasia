function file_load_player_inventory_old(_uuid, _buffer2, _name)
{
	if (!directory_exists($"{DIRECTORY_PLAYERS}/{_uuid}/inventory")) exit;
	
	var _datafixer = global.datafixer.item;
	
	var _item_data = global.item_data;
	var _inventory = global.inventory;
	
	var _u = array_length(_inventory[$ _name]);
	
	for (var j = 0; j < _u; ++j)
	{
		var _item_id = buffer_read(_buffer2, buffer_string);
		
		if (_item_id == "") continue;
		
		global.inventory[$ _name][@ j] = new Inventory(_item_id, buffer_read(_buffer2, buffer_u16))
			.set_index(buffer_read(_buffer2, buffer_s8))
			.set_index_offset(buffer_read(_buffer2, buffer_s8))
			.set_state(buffer_read(_buffer2, buffer_u16));
		
		if (_item_data[$ _item_id].type & (ITEM_TYPE_BIT.SWORD | ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER | ITEM_TYPE_BIT.WHIP | ITEM_TYPE_BIT.BOW | ITEM_TYPE_BIT.FISHING_POLE))
		{
			global.inventory[$ _name][@ j].set_durability(buffer_read(_buffer2, buffer_u16));
		}
	}
}