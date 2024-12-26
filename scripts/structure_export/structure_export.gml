function structure_export(_file_name, _xstart, _ystart, _xend, _yend)
{
	var _item_data = global.item_data;
	
	var _buffer = buffer_create(0xffff, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
	buffer_write(_buffer, buffer_s32, (_xend - _xstart) + 1);
	buffer_write(_buffer, buffer_s32, (_yend - _ystart) + 1);
	
	var _surface_display = 0;
	
	for (var j = _ystart; j <= _yend; ++j)
	{
		for (var i = _xstart; i <= _xend; ++i)
		{
			var _ = tile_get(i, j, CHUNK_DEPTH_DEFAULT, -1);
			
			if (_ != TILE_EMPTY) && (_.item_id == "phantasia:structure_void")
			{
				buffer_write(_buffer, buffer_bool, true);
				
				continue;
			}
			
			buffer_write(_buffer, buffer_bool, false);
			
			for (var l = CHUNK_SIZE_Z - 1; l >= 0; --l)
			{
				var _tile = (l == CHUNK_DEPTH_DEFAULT ? _ : tile_get(i, j, l, -1));
				
				if (_tile == TILE_EMPTY)
				{
					buffer_write(_buffer, buffer_string, "");
					
					continue;
				}
				
				var _item_id = _tile.item_id;
				
				buffer_write(_buffer, buffer_string, _item_id);
				buffer_write(_buffer, buffer_u32, _tile.state_id);
				buffer_write(_buffer, buffer_u64, _tile.scale_rotation_index);
				
				var _data = _item_data[$ _item_id];
		
				if (_data.type & ITEM_TYPE_BIT.CONTAINER)
				{
					var _inventory = _tile.inventory;
					
					var _is_loot = is_string(_inventory);
					
					buffer_write(_buffer, buffer_bool, _is_loot);
					
					if (_is_loot)
					{
						buffer_write(_buffer, buffer_string, _inventory);
					}
					else
					{
						var _inventory_length = array_length(_inventory);
			
						buffer_write(_buffer, buffer_u8, _inventory_length);
			
						for (var m = 0; m < _inventory_length; ++m)
						{
							var _item = _inventory[m];
				
							if (_item == INVENTORY_EMPTY)
							{
								buffer_write(_buffer, buffer_string, "");
				
								continue;
							}
				
							var _item_id2 = _item.item_id;
							
							buffer_write(_buffer, buffer_string, _item_id2);
							buffer_write(_buffer, buffer_u16, _item.amount);
							buffer_write(_buffer, buffer_s8, _item.index);
							buffer_write(_buffer, buffer_s8, _item.index_offset);
							buffer_write(_buffer, buffer_u16, _item.state);
			
							if (_item_data[$ _item_id2].type & (ITEM_TYPE_BIT.SWORD | ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER | ITEM_TYPE_BIT.WHIP | ITEM_TYPE_BIT.BOW | ITEM_TYPE_BIT.FISHING_POLE))
							{
								buffer_write(_buffer, buffer_u16, _item.durability);
							}
						}
					}
				}
				
				var _variable_names = _data.variable_names;
					
				if (_variable_names != undefined)
				{
					var _variable = _data.variable;
					var _length = array_length(_variable_names);
						
					buffer_write(_buffer, buffer_u8, _length);
					
					for (var n = 0; n < _length; ++n)
					{
						var _name = _variable_names[n];
							
						buffer_write(_buffer, buffer_string, _name);
						buffer_write(_buffer, (is_string(_variable[$ _name]) ? buffer_string : buffer_f32), _tile[$ $"variable.{_name}"]);
					}
				}
			}
		}
	}
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	buffer_save(_buffer2, $"{DIRECTORY_STRUCTURES}/{_file_name}.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}