function file_save_world_chunk(_inst)
{
	var _item_data = global.item_data;
	
	var _buffer = buffer_create(0xffff, buffer_grow, 1);
	
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MAJOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.MINOR);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.PATCH);
	buffer_write(_buffer, buffer_u8, VERSION_NUMBER.TYPE);
	
	buffer_write(_buffer, buffer_u16, surface_display);
	
	if (surface_display)
	{
		var _chunk = _inst.chunk;
	
		for (var i = 0; i < CHUNK_SIZE_Z; ++i)
		{
			if ((surface_display & (1 << i)) == 0) continue;
                
			var j = i << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT);
            
			repeat (CHUNK_SIZE_X * CHUNK_SIZE_Y)
			{
				var _tile = _chunk[j++];
                
				if (_tile == TILE_EMPTY)
				{
					buffer_write(_buffer, buffer_string, "");
                    
					continue;
				}
                
				var _item_id = _tile.item_id;
                
				buffer_write(_buffer, buffer_string, _item_id);
				
				var _next = buffer_tell(_buffer);
                
				buffer_write(_buffer, buffer_u32, 0);
				
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
						
						for (var l = 0; l < _inventory_length; ++l)
						{
							var _item = _inventory[l];
                            
							if (_item == INVENTORY_EMPTY)
							{
								buffer_write(_buffer, buffer_string, "");
                                
								continue;
							}
							
							var _item_id2 = _item.item_id;
							
							buffer_write(_buffer, buffer_string, _item_id2);
							
							var _next2 = buffer_tell(_buffer);
							buffer_write(_buffer, buffer_u32, 0);
							
							buffer_write(_buffer, buffer_u16, _item.amount);
							buffer_write(_buffer, buffer_s8, _item.index);
							buffer_write(_buffer, buffer_s8, _item.index_offset);
							buffer_write(_buffer, buffer_u16, _item.state);
                            
							if (_item_data[$ _item_id2].type & (ITEM_TYPE_BIT.SWORD | ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER | ITEM_TYPE_BIT.WHIP | ITEM_TYPE_BIT.BOW | ITEM_TYPE_BIT.FISHING_POLE))
							{
								buffer_write(_buffer, buffer_u16, _item.durability);
							}
							
							buffer_poke(_buffer, _next2, buffer_u32, buffer_tell(_buffer));
						}
					}
				}
				
				var _variable_names = _data.variable_names;
				
				if (_variable_names != undefined)
				{
					var _variable = _data.variable;
					var _length = array_length(_variable_names);
					
					buffer_write(_buffer, buffer_u8, _length);
					
					for (var l = 0; l < _length; ++l)
					{
						var _name = _variable_names[l];
						
						buffer_write(_buffer, buffer_string, _name);
						buffer_write(_buffer, (is_string(_variable[$ _name]) ? buffer_string : buffer_f32), _tile[$ $"variable.{_name}"]);
					}
				}
				
				buffer_poke(_buffer, _next, buffer_u32, buffer_tell(_buffer));
                
                delete _tile;
			}
		}
	}
	
	var _bbox_l = xcenter - CHUNK_SIZE_WIDTH_H;
	var _bbox_t = ycenter - CHUNK_SIZE_HEIGHT_H;
	
	var _bbox_r = xcenter + CHUNK_SIZE_WIDTH_H;
	var _bbox_b = ycenter + CHUNK_SIZE_HEIGHT_H;
	
	#region Item Drops
	
	static __inst_item = [];
	
	var _length_item = 0;
	
	with (obj_Item_Drop)
	{
		if (rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, _bbox_l, _bbox_t, _bbox_r, _bbox_b))
		{
			__inst_item[@ _length_item++] = id;
		}
	}
	
	buffer_write(_buffer, buffer_u32, _length_item);
	
	for (var i = 0; i < _length_item; ++i)
	{
		var _ = __inst_item[i];
		
		var _next = buffer_tell(_buffer);
		buffer_write(_buffer, buffer_u32, 0);
		
		var _item_id = _.item_id;
		
		buffer_write(_buffer, buffer_string, _item_id);
		
		buffer_write(_buffer, buffer_f32, _.life);
		
		buffer_write(_buffer, buffer_f64, _.x);
		buffer_write(_buffer, buffer_f64, _.y);
		
		buffer_write(_buffer, buffer_f16, _.xvelocity);
		buffer_write(_buffer, buffer_f16, _.yvelocity);
		
		var _index = _[$ "index"];
		var _index_offset = _[$ "index_offset"];
		
		var _value = ((_.xdirection + 1) << 35) | (_.show_text << 34) | (_.state << 16) | _.amount;
		
		if (_index != undefined)
		{
			_value |= ((_index + 0x80) << 44) | (1 << 33);
		}
		
		if (_index_offset != undefined)
		{
			_value |= ((_index_offset + 0x80) << 36) | (1 << 32);
		}
		
		buffer_write(_buffer, buffer_u64, _value);
		
		if (_item_data[$ _item_id].type & (ITEM_TYPE_BIT.SWORD | ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER | ITEM_TYPE_BIT.WHIP | ITEM_TYPE_BIT.BOW | ITEM_TYPE_BIT.FISHING_POLE))
		{
			buffer_write(_buffer, buffer_u16, _.durability);
		}
		
		buffer_write(_buffer, buffer_f16, _.life);
		buffer_poke(_buffer, _next, buffer_u32, buffer_tell(_buffer));
		
		instance_destroy(_);
	}
	
	#endregion
	
	#region Creatures
	
	var _creature_data = global.creature_data;
	
	var _effect_data = global.effect_data;
	
	var _effect_names  = global.effect_data_names;
	var _effect_length = array_length(_effect_names);
	
	static __inst_creature = [];
	
	var _length_creature = 0;
	
	with (obj_Creature)
	{
		if (rectangle_in_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, _bbox_l, _bbox_t, _bbox_r, _bbox_b))
		{
			__inst_creature[@ _length_creature++] = id;
		}
	}
	
	buffer_write(_buffer, buffer_u32, _length_creature);
	
	for (var i = 0; i < _length_creature; ++i)
	{
		var _next = buffer_tell(_buffer);
		buffer_write(_buffer, buffer_u32, 0);
		
		var _ = __inst_creature[i];
		
		var _creature_id = _.creature_id;
		var _data = _creature_data[$ _creature_id];
		
		buffer_write(_buffer, buffer_f64, _.x);
		buffer_write(_buffer, buffer_f64, _.y);
		
		buffer_write(_buffer, buffer_f16, _.xvelocity);
		buffer_write(_buffer, buffer_f16, _.yvelocity);
		
		buffer_write(_buffer, buffer_string, _creature_id);
		
		var _index = _.index;
		
		buffer_write(_buffer, buffer_u64, ((_.ydirection + 1) << 26) | ((_.xdirection + 1) << 24) | ((_index == undefined ? 0 : _index + 1) << 16) | _.hp);
		
		buffer_write(_buffer, buffer_f64, _.ylast);
		
		buffer_write(_buffer, buffer_f16, _.sfx_time);
		buffer_write(_buffer, buffer_f16, _.coyote_time);
		
		if ((_data.type >> 4) & CREATURE_HOSTILITY_TYPE.PASSIVE)
		{
			buffer_write(_buffer, buffer_f16, _.panic_time);
		}
		
		buffer_write(_buffer, buffer_f16, _.immunity_frame);
		
		var _effects = _.effects;
		
		buffer_write(_buffer, buffer_u8, _effect_length);
		
		for (var j = 0; j < _effect_length; ++j)
		{
			var _effect_name = _effect_names[j];
			
			buffer_write(_buffer, buffer_string, _effect_name);
			
			var _effect = _effects[$ _effect_name];
			
			if (_effect == undefined)
			{
				buffer_write(_buffer, buffer_u16, 0);
				
				continue;
			}
			
			buffer_write(_buffer, buffer_u16, (_effect.particle << 8) | _effect.level);
			buffer_write(_buffer, buffer_f64, _effect.timer);
		}
		
		buffer_poke(_buffer, _next, buffer_u32, buffer_tell(_buffer));
		
		instance_destroy(_);
	}
	
	#endregion
	
	var _buffer2 = buffer_compress(_buffer, 0, buffer_tell(_buffer));
	
	var _x = _inst.chunk_xstart / CHUNK_SIZE_X;
	var _y = _inst.chunk_ystart / CHUNK_SIZE_Y;
	
	debug_log($"Chunk saved at ({_x}, {_y})");
	
	buffer_save(_buffer2, $"{global.world_directory}/Realms/{string_replace_all(global.world.realm, ":", "/")}/{_x} {_y}.dat");
	
	buffer_delete(_buffer);
	buffer_delete(_buffer2);
}