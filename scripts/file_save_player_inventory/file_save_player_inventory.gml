function file_save_player_inventory(_id)
{
	var _item_data = global.item_data;
	
	var _uuid = _id.uuid;
	
	var _inventory = global.inventory;
	
	var _names  = struct_get_names(_inventory);
	var _length = array_length(_names);
	
	for (var i = 0; i < _length; ++i)
	{
		var _name = _names[i];
		
		if (_name == "container") || (_name == "craftable") continue;
		
		var _v = _inventory[$ _name];
		
		var _l = array_length(_v);
		
		var _buffer = buffer_create(0xff * _l, buffer_grow, 1);
		
		buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
		buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
		buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
		buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
		
		for (var j = 0; j < _l; ++j)
		{
			var _item = _v[j];
			
			if (_item == INVENTORY_EMPTY)
			{
				buffer_write(_buffer, buffer_string, "");
				
				continue;
			}
			
			var _item_id = _item.item_id;
			
			buffer_write(_buffer, buffer_string, _item_id);
			
			var _next2 = buffer_tell(_buffer);
			buffer_write(_buffer, buffer_u32, 0);
			
			buffer_write(_buffer, buffer_u16, _item.amount);
			buffer_write(_buffer, buffer_s8, _item.index);
			buffer_write(_buffer, buffer_s8, _item.index_offset);
			buffer_write(_buffer, buffer_u16, _item.state);
			
			if (_item_data[$ _item_id].type & (ITEM_TYPE_BIT.SWORD | ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER | ITEM_TYPE_BIT.WHIP | ITEM_TYPE_BIT.BOW | ITEM_TYPE_BIT.FISHING_POLE))
			{
				buffer_write(_buffer, buffer_u16, _item.durability);
			}
			
			buffer_poke(_buffer, _next2, buffer_u32, buffer_tell(_buffer));
		}
		
		var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
		
		buffer_save(_buffer2, $"{DIRECTORY_PLAYERS}/{_uuid}/Inventory/{_name}.dat");
	
		buffer_delete(_buffer);
		buffer_delete(_buffer2);
	}
}