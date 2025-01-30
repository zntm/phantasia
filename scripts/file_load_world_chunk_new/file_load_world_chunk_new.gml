function file_load_world_chunk_new(_inst, _buffer2)
{
	var _datafixer = global.datafixer;
	
	var _datafixer_item = _datafixer.item;
	
	var _item_data = global.item_data;
	
	_inst.is_generated = true;
	
	var _sun_rays_y = global.sun_rays_y;
	
	var _surface_display = buffer_read(_buffer2, buffer_u16);
	
	if (_surface_display)
	{
		for (var i = 0; i < CHUNK_SIZE_Z; ++i)
		{
			if ((_surface_display & (1 << i)) == 0) continue;
		
			var j = i << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT);
	
			repeat (CHUNK_SIZE_X * CHUNK_SIZE_Y)
			{
				var _item_id = buffer_read(_buffer2, buffer_string);
		
				if (_item_id == "")
				{
					++j;
			
					continue;
				}
				
				var _next = buffer_read(_buffer2, buffer_u32);
		
				var _data = _item_data[$ _item_id];
		
				if (_data == undefined)
				{
					_item_id = _datafixer_item[$ _item_id];
					_data = _item_data[$ _item_id];
					
					if (_data == undefined)
					{
						buffer_seek(_buffer2, buffer_seek_start, _next);
						
						++j;
						
						continue;
					}
				}
		
				var _tile = new Tile(_item_id, _item_data);
		
				_tile.state_id = buffer_read(_buffer2, buffer_u32);
				_tile.scale_rotation_index = buffer_read(_buffer2, buffer_u64);
		
				var _xtile = _inst.chunk_xstart + (j & (CHUNK_SIZE_X - 1));
				var _ytile = _inst.chunk_ystart + ((j >> CHUNK_SIZE_X_BIT) & (CHUNK_SIZE_Y - 1));
		
				tile_instance_create(_xtile, _ytile, i, _tile);
				
				if (_data.type & ITEM_TYPE_BIT.CONTAINER)
				{
					var _is_loot = buffer_read(_buffer2, buffer_bool);
					
					if (_is_loot)
					{
						_tile.set_loot(buffer_read(_buffer2, buffer_string));
					}
					else
					{
						var _length = buffer_read(_buffer2, buffer_u8);
						
                        _tile.inventory = file_load_snippet_inventory(_buffer2, _length, _item_data, _datafixer);
					}
				}
				
				var _variable_names = _data.variable_names;
				
				if (_variable_names != undefined)
				{
					var _variable = _data.variable;
					var _length = buffer_read(_buffer2, buffer_u8);
					
					repeat (_length)
					{
						var _name = buffer_read(_buffer2, buffer_string);
						
						var _v = _variable[$ _name];
						
						if (_v != undefined)
						{
							_tile[$ $"variable.{_name}"] = buffer_read(_buffer2, (is_string(_v) ? buffer_string : buffer_f32));
						}
					}
				}
				
				chunk[@ j++] = _tile;
			}
		}
	}
	
	#region Item Drops
	
	var _length_item = buffer_read(_buffer2, buffer_u32);
	
	repeat (_length_item)
	{
		var _next = buffer_read(_buffer2, buffer_u32);
		var _item_id = buffer_read(_buffer2, buffer_string);
		
		var _data = _item_data[$ _item_id];
		
		if (_data == undefined)
		{
			_item_id = _datafixer_item[$ _item_id];
			_data = _item_data[$ _item_id];
					
			if (_data == undefined)
			{
				buffer_seek(_buffer2, buffer_seek_start, _next);
				
				continue;
			}
		}
		
		var _timestamp = buffer_read(_buffer2, buffer_f32);
		
		var _x = buffer_read(_buffer2, buffer_f64);
		var _y = buffer_read(_buffer2, buffer_f64);
		
		var _xvelocity = buffer_read(_buffer2, buffer_f16);
		var _yvelocity = buffer_read(_buffer2, buffer_f16);
		
		var _value   = buffer_read(_buffer2, buffer_u64);
		
		var _index        = ((_value & (1 << 33)) ? (((_value >> 44) & 0xff) - 0x80) : undefined);
		var _index_offset = ((_value & (1 << 32)) ? (((_value >> 36) & 0xff) - 0x80) : undefined);
		
		var _durability;
		
		if (_data.type & (ITEM_TYPE_BIT.SWORD | ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER | ITEM_TYPE_BIT.WHIP | ITEM_TYPE_BIT.BOW | ITEM_TYPE_BIT.FISHING_POLE))
		{
			_durability = buffer_read(_buffer2, buffer_u16);
		}
		else
		{
			_durability = undefined;
		}
		
		var _timer = buffer_read(_buffer2, buffer_f16);
		
		if (_timer >= ITEM_DESPAWN_SECONDS)
		{
			spawn_drop(
				_x,
				_y,
				_item_id,
				_value & 0xffff,
				_xvelocity,
				(_value >> 35) - 1,
				_yvelocity,
				_timer,
				(_value >> 34) & 1,
				_index,
				_index_offset,
				_durability,
				(_value >> 16) & 0xffff,
				_timestamp,
				_item_data
			);
		}
	}
	
	#endregion
	
	#region Creatures
	
	static __damage_unable = [ obj_Creature ];
	
	var _datafixer_creature = _datafixer.creature;
	var _creature_data = global.creature_data;
	
	var _length_creature = buffer_read(_buffer2, buffer_u32);
	
	repeat (_length_creature)
	{
		var _next = buffer_read(_buffer2, buffer_u32);
		var _creature_id = buffer_read(_buffer2, buffer_string);
		
		var _data = _creature_data[$ _creature_id];
		
		if (_data == undefined)
		{
			_creature_id = _datafixer_creature[$ _creature_id];
			_data = _creature_data[$ _creature_id];
					
			if (_data == undefined)
			{
				buffer_seek(_buffer2, buffer_seek_start, _next);
				
				continue;
			}
		}
		
		var _x = buffer_read(_buffer2, buffer_f64);
		var _y = buffer_read(_buffer2, buffer_f64);
		
		var _xvelocity = buffer_read(_buffer2, buffer_f16);
		var _yvelocity = buffer_read(_buffer2, buffer_f16);
		
		var _value = buffer_read(_buffer2, buffer_u64);
		
		var _ylast = buffer_read(_buffer2, buffer_f64);
		
		var _index = (_value >> 16) & 0xff;
		
		with (instance_create_layer(_x, _y, "Instances", obj_Creature))
		{
			if (_index == 0)
			{
				index = undefined;
				sprite_index = _data.sprite_idle;
			}
			else
			{
				index = _index - 1;
				sprite_index = _data.sprite_idle[index];
			}
			
			image_alpha = 0;
			
			entity_init(id, _value & 0xffff, round(_data.hp * global.difficulty_multiplier_hp[global.world_settings.difficulty]), _data.colour_offset, _data.effect_immune);
			
			creature_id = _creature_id;
			
			xdirection = ((_value >> 24) & 0b11) - 1;
			ydirection = ((_value >> 26) & 0b11) - 1;
			
			ylast = buffer_read(_buffer2, buffer_f64);
			
			sfx_time = buffer_read(_buffer2, buffer_f16);
			coyote_time = buffer_read(_buffer2, buffer_f16);
			
			if ((_data.type >> 4) & CREATURE_HOSTILITY_TYPE.PASSIVE)
			{
				panic_time = buffer_read(_buffer2, buffer_f16);
			}
			else
			{
				searching = noone;
			}
			
			immunity_frame = buffer_read(_buffer2, buffer_f16);
			
			var _length = buffer_read(_buffer2, buffer_u8);
			
			effects = {}
			
			repeat (_length)
			{
				var _name = buffer_read(_buffer2, buffer_string);
				var _level = buffer_read(_buffer2, buffer_u16);
		
				effects[$ _name] = (_level == 0 ? undefined : {
					level: real(_level & 0xff),
					timer: buffer_read(_buffer2, buffer_f64),
					particle: _level >> 8
				});
			}
			
			damage_unable = __damage_unable;
		}
	}
	
	#endregion
	
	debug_log($"Chunk loaded at ({_inst.chunk_xstart / CHUNK_SIZE_X}, {_inst.chunk_ystart / CHUNK_SIZE_Y})");
	
	if (_surface_display)
	{
		_inst.surface_display |= _surface_display;
		_inst.chunk_z_refresh |= _surface_display;
	}
}