function player_mine(_x, _y, _holding, _world_height, _delta_time)
{
    var _xtile = round(_x / TILE_SIZE);
    var _ytile = round(_y / TILE_SIZE);
    
	var _tile = TILE_EMPTY;
	var _zcurrent = 0;
	
	if (!is_mining)
	{
		for (var _z = CHUNK_SIZE_Z - 1; _z >= 0; --_z)
		{
			_tile = tile_get(_xtile, _ytile, _z, -1, _world_height);
			
			if (_tile == TILE_EMPTY) continue;
			
			_zcurrent = _z;
			
			player_mine_value(true, _xtile, _ytile, _z);
			
			break;
		}
	}
	else
	{
		_zcurrent = mine_position_z;
		
		_tile = tile_get(mine_position_x, mine_position_y, mine_position_z, -1, _world_height);
	}
	
	if (!is_mining) || (_tile == TILE_EMPTY) || (_xtile != mine_position_x) || (_ytile != mine_position_y)
	{
		return true;
	}
	
	var _item_data = global.item_data;
	
	var _item_id = _tile.item_id;
	
	var _data = _item_data[$ _item_id];
	
	var _mining_hardness = _data.get_mining_hardness();
	
	if (_mining_hardness < 0)
	{
		return true;
	}
	
	var _mining_type = _data.mining_type;
	
	var _mining_speed;
	
	if (_holding == INVENTORY_EMPTY)
	{
		if (_mining_type) || (_data.get_mining_power() != TOOL_POWER.ALL)
		{
			return true;
		}
		
		_mining_speed = 1 / 4;
	}
	else
	{
		var _holding_data = _item_data[$ _holding.item_id];
		var _holding_type = _holding_data.type;
		
		if (_holding_type & (ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER))
		{
			if ((_mining_type) && ((_holding_type & _mining_type) == 0)) || (_holding_data.get_mining_power() < _data.get_mining_power())
			{
				return true;
			}
		
			_mining_speed = _holding_data.get_mining_speed() / 4;
		}
		else
		{
			if (_mining_type) || (_holding_data.get_mining_power() != TOOL_POWER.ALL)
			{
				return true;
			}
			
			_mining_speed = 1 / 4;
		}
	}
	
	mining_current += _mining_speed * _delta_time;
	
	var _sprite = _data.sprite;
		
	var _sprite_width  = sprite_get_width(_sprite);
	var _sprite_height = sprite_get_height(_sprite);
		
	var _xoffset = _sprite_width  / 2;
	var _yoffset = _sprite_height / 2;
	
	var _xinst = _xtile * TILE_SIZE;
	var _yinst = _ytile * TILE_SIZE;
	
	var _sfx = $"{_data.get_sfx()}.~";
    
	if (round(mining_current_fixed++) % 8 == 0)
	{
		sfx_diagetic_play(obj_Player.x, obj_Player.y, _xinst, _yinst, string_replace(_sfx, "~", "mine"), undefined, global.settings_value.blocks);
		
		// spawn_particle(_tile_x + random_range(-_xoffset, _xoffset), _tile_y + irandom_range(-_yoffset, _yoffset), CHUNK_SIZE_Z - 1, PARTICLE.TILE, irandom_range(8, 12), undefined, undefined, undefined, _sprite, [ irandom_range(8, _sprite_width - 8), irandom_range(8, _sprite_height - 8) ]);
	}
		
	if (mining_current < _mining_hardness)
	{
		return false;
	}
	
	if (_data.type & ITEM_TYPE_BIT.CONTAINER)
	{
		var _inventory = _tile.inventory;
		
		if (is_string(_inventory))
		{
			_inventory = _tile.set_loot_inventory(_inventory).inventory;
		}
		
		var _container_size = _data.get_container_size();
		
		for (var i = 0; i < _container_size; ++i)
		{
			var _item = _inventory[i];
			
			if (_item == INVENTORY_EMPTY) continue;
			
			spawn_drop(_tile_x, _tile_y, _item.item_id, _item.amount, random_range(-INVENTORY_DROP_XVELOCITY, INVENTORY_DROP_XVELOCITY), choose(-1, 1), -random(INVENTORY_DROP_YVELOCITY), GAME_FPS * 6, undefined, _item.index, _item.index_offset, _item[$ "durability"], _item.state);
		}
	}
	
	var _drops = _data.get_drops();
	
	if (_drops != undefined)
	{
		if (is_array(_drops))
		{
			_drops = choose_weighted(_drops);
			
			if (_drops != INVENTORY_EMPTY)
			{
				spawn_drop(_xinst, _yinst, _drops, 1, 0, 0);
			}
		}
		else
		{
			spawn_drop(_xinst, _yinst, _drops, 1, 0, 0);
		}
	}
	
	sfx_diagetic_play(obj_Player.x, obj_Player.y, _xinst, _yinst, string_replace(_sfx, "~", "destroy"), undefined, global.settings_value.blocks);
	
	// spawn_particle(_tile_x + random_range(-_xoffset, _xoffset), _tile_y + irandom_range(-_yoffset, _yoffset), CHUNK_SIZE_Z - 1, PARTICLE.TILE, irandom_range(8, 12), undefined, undefined, undefined, _sprite, [ irandom_range(8, _sprite_width - 8), irandom_range(8, _sprite_height - 8) ]);
	
	var _inst = tile_place(_xtile, _ytile, _zcurrent, TILE_EMPTY, _world_height);
	var _chunk = _inst.chunk;
	
	tile_update_chunk_condition(_inst, _item_id, _zcurrent);
	
	// chunk_refresh(mouse_x, mouse_y, 1, true, true);
    chunk_update_near_light();
	instance_cull(true);
    
	var _on_destroy = _data.on_destroy;
	
	if (_on_destroy != undefined)
	{  
		_on_destroy(_x, _y, mine_position_z);
    }
    
	mining_current = 0;
	mining_current_fixed = 0;
    
	if (_holding != INVENTORY_EMPTY)
	{
		var _holding_data = _item_data[$ _holding.item_id];
		
		if (_holding_data.type & (ITEM_TYPE_BIT.SWORD | ITEM_TYPE_BIT.PICKAXE | ITEM_TYPE_BIT.AXE | ITEM_TYPE_BIT.SHOVEL | ITEM_TYPE_BIT.HAMMER | ITEM_TYPE_BIT.WHIP | ITEM_TYPE_BIT.BOW))
		{
			obj_Control.surface_refresh_inventory = true;
            
			var _inventory_selected_hotbar = global.inventory_selected_hotbar;
            
			if (--global.inventory.base[_inventory_selected_hotbar].durability <= 0)
			{
				global.inventory.base[@ _inventory_selected_hotbar] = INVENTORY_EMPTY;
			}
		}
	}
	
	tile_update_neighbor(_xtile, _ytile, undefined, undefined, _world_height);
	chunk_refresh_fast(_xinst - CHUNK_SIZE_WIDTH_H, _yinst - CHUNK_SIZE_HEIGHT_H, _xinst + CHUNK_SIZE_WIDTH_H, _yinst + CHUNK_SIZE_HEIGHT_H);
	
	if (!position_meeting(_xinst, _yinst - TILE_SIZE, obj_Parent_Light)) exit;
	
	obj_Control.refresh_sun_ray = true;
	
	global.camera.shake = 1;
	
	var _camera = global.camera;
	
	#region Adjust Sun Ray
	
	var _string_x = string(_xtile);
	
	var i = global.sun_rays_y[$ _string_x] + 1;
	
	if (i == _yinst) && (_mining_type & ITEM_TYPE_BIT.SOLID)
	{
		var _cx = tile_inst_x(_x);
		
		while (true)
		{
			if (!instance_exists(instance_position(_cx, tile_inst_y(i), obj_Chunk)))
			{
				global.sun_rays_y[$ _string_x] = _world_height;
                
				return true;
			}
            
			var _tile2 = tile_get(_x, i, CHUNK_DEPTH_DEFAULT, -1);
            
			if (_tile2 != TILE_EMPTY) && (_item_data[$ _tile2.item_id].type & ITEM_TYPE_BIT.SOLID)
			{
				global.sun_rays_y[$ _string_x] = i;
                
				return true;
			}
            
			++i;
		}
	}
	
	#endregion
}