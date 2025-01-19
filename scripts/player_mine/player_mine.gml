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
			if (((_mining_type & ITEM_TYPE_BIT.DEFAULT) == 0) && ((_holding_type & _mining_type) == 0)) || (_holding_data.get_mining_power() < _data.get_mining_power())
			{
				return true;
			}
		
			_mining_speed = _holding_data.get_mining_speed() / 4;
		}
		else
		{
			if ((_mining_type & ITEM_TYPE_BIT.DEFAULT) == 0) || (_holding_data.get_mining_power() != TOOL_POWER.ALL)
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
		sfx_diegetic_play(obj_Player.x, obj_Player.y, _xinst, _yinst, string_replace(_sfx, "~", "mine"), undefined, global.settings_value.blocks);
		
		// spawn_particle(_tile_x + random_range(-_xoffset, _xoffset), _tile_y + irandom_range(-_yoffset, _yoffset), CHUNK_SIZE_Z - 1, PARTICLE.TILE, irandom_range(8, 12), undefined, undefined, undefined, _sprite, [ irandom_range(8, _sprite_width - 8), irandom_range(8, _sprite_height - 8) ]);
	}
		
	if (mining_current < _mining_hardness)
	{
		return false;
	}
	
	tile_destroy_with_drop(_xtile, _ytile, _zcurrent, _tile);
    
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
                inventory_delete("base", _inventory_selected_hotbar);
			}
		}
	}
	
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