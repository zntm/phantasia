function chunk_generate(_world, _seed, _world_data)
{
	var _cache_draw_update = global.item_on_draw;
	
	static __array = [];
	static __list = ds_list_create();
	
	static __sort = function(_a, _b)
	{
        return ((_a.x * 0xffff) + _a.y) - ((_b.x * 0xffff) + _b.y);
	}
	
	static __chunk_data = array_create((CHUNK_SIZE_X + 2) + CHUNK_SIZE_X, 0);
	
	var _realm = _world.realm;
	
    var _seed_cave    = _seed + WORLGEN_SALT.CAVE;
    
	var _seed_wall    = _seed + WORLGEN_SALT.WALL;
	var _seed_base    = _seed + WORLGEN_SALT.BASE;
	var _seed_foliage = _seed + WORLGEN_SALT.FOLIAGE;
	
	var _biome_data = global.biome_data;
	var _item_data = global.item_data;
	var _loot_data = global.loot_data;
	var _structure_data = global.structure_data;
	
	var _world_value = _world_data.value;
	var _world_caves = _world_data.caves;
	
	var _ysurface_offset = (_world_value >> 16) & 0xff;
	
	var _max = 0;
	
	for (var i = CHUNK_SIZE_X - 1; i >= 0; --i)
	{
		var _xpos = chunk_xstart + i;
		var _ysurface = worldgen_get_ysurface(_xpos, _seed, _world_data);
		
		_max = max(_max, _ysurface);
		
		__chunk_data[@ i] = _ysurface;
		
		var _index = CHUNK_SIZE_X | i;
		
		__chunk_data[@ _index] = 0;
		
		var _ysurface2 = _ysurface + _ysurface_offset;
		
		for (var j = CHUNK_SIZE_Y; j >= 0; --j)
		{
			var _ypos = chunk_ystart + j;
			
			if (_ypos <= _ysurface2) || (!worldgen_carve_cave(_xpos, _ypos, _seed_cave, _world_value, _world_caves, _ysurface)) continue;
			
			__chunk_data[@ _index] |= 1 << j;
		}
	}
	
    debug_timer("chunk_generation");
    
	var _collision_chunk_y1 = ycenter - CHUNK_SIZE_HEIGHT_H;
	var _collision_chunk_y2 = ycenter + CHUNK_SIZE_HEIGHT_H;
	
	var _structure_inside_chunk_rectangle = instance_exists(collision_rectangle(xcenter - CHUNK_SIZE_WIDTH_H, _collision_chunk_y1, xcenter + CHUNK_SIZE_WIDTH_H, _collision_chunk_y2, obj_Structure, false, true));
	
	if (!_structure_inside_chunk_rectangle) && (_max - 1 < round(_collision_chunk_y1 / TILE_SIZE)) && (_max - 1 > round(_collision_chunk_y2 / TILE_SIZE)) exit;
	
	for (var _x = CHUNK_SIZE_X - 1; _x >= 0; --_x)
	{
		var _xpos = chunk_xstart + _x;
		var _xinst = _xpos * TILE_SIZE;
		
		var _ysurface = __chunk_data[_x];
		
		var _xindex = string(_xpos);
		
		global.sun_rays_y[$ _xindex] ??= _ysurface;
		
		var _sun_rays_y = global.sun_rays_y[$ _xindex];
		
		var _chunk_data = __chunk_data[CHUNK_SIZE_X | _x];
		
		var _structure_inside_chunk_x = (_structure_inside_chunk_rectangle) && (instance_exists(collision_rectangle(_xinst - TILE_SIZE_H, _collision_chunk_y1, _xinst + TILE_SIZE_H, _collision_chunk_y2, obj_Structure, false, true)));
		
		var _connected_x1 = 1 << (_x << 1);
		var _connected_x2 = _connected_x1 << 1;
		
		random_set_seed(_seed + _x + xcenter);
		
		for (var _y = CHUNK_SIZE_Y - 1; _y >= 0; --_y)
		{
			var _ypos = chunk_ystart + _y;
			var _yinst = _ypos * TILE_SIZE;
			
			var _surface_biome = worldgen_get_surface_biome(_xpos, _ypos, _seed, _ysurface, _world_data, _realm);
			var _cave_biome    = worldgen_get_cave_biome(_xpos, _ypos, _seed, _ysurface, _world_data);
			var _sky_biome     = worldgen_get_sky_biome(_xpos, _ypos, _seed);
            
			var _index_xy = _x | (_y << CHUNK_SIZE_X_BIT);
			
			var _skip_layer = 0;
            
			if (_structure_inside_chunk_x) && (position_meeting(_xinst, _yinst, obj_Structure))
			{
				ds_list_clear(__list);
                
				var _length = instance_position_list(_xinst, _yinst, obj_Structure, __list, false);
				
				for (var i = 0; i < _length; ++i)
				{
					__array[@ i] = __list[| i];
				}
				
				array_resize(__array, _length);
				array_sort(__array, __sort);
				
				var _break = 0;
				
				for (var i = 0; i < _length; ++i)
				{
					var _inst = __array[i];
					
					var _id = _inst.structure_id;
                    
					var _xscale = _inst.image_xscale;
                    var _yscale = _inst.image_yscale;
                    
					var _rectangle = _xscale * _yscale;
                    
					var _data = _inst.data;
					var _natural = _inst.natural;
					
					var _ax = _xpos - ceil(_inst.bbox_left / TILE_SIZE);
					var _ay = _ypos - ceil(_inst.bbox_top  / TILE_SIZE);
					
					var _structure_index_xy = _ax + (_ay * _xscale);
					
					for (var j = CHUNK_SIZE_Z - 1; j >= 0; --j)
					{
						var _zbit = 1 << j;
						
						if (_break & _zbit) continue;
						
						var _tile = _data[_structure_index_xy + (j * _rectangle)];
                        
						if (_tile == STRUCTURE_VOID) continue;
                        
						_skip_layer |= (j == CHUNK_DEPTH_WALL ? 1 : 2);
						_break |= _zbit;
                        
						if (_tile == TILE_EMPTY) continue;
                        
						var _item_id = _tile.item_id;
						
						var _data2 = _item_data[$ _item_id];
						var _type = _data2.type;
                        
						if (_item_id == "phantasia:structure_loot")
						{
							var _loot_id = _tile[$ "variable.loot_id"];
                            
							var _container_id = choose_weighted(_loot_data[$ _loot_id].container).item_id;
                            
							if (_container_id == TILE_EMPTY) continue;
                            
							var _tile2 = new Tile(_container_id, _item_data);
							
							if (_item_data[$ _container_id].type & ITEM_TYPE_BIT.CONTAINER)
							{
								_tile2.set_loot(_loot_id);
							}
                            
                            delete _tile;
                            
                            _tile = _tile2;
						}
						
						surface_display |= _zbit;
						
						tile_instance_create(_xpos, _ypos, j, _tile, _item_data);
						
						if (_cache_draw_update[$ _item_id] != undefined)
						{
							is_on_draw_update |= _zbit;
						}
						
                        chunk_generate_anim_handler(_item_data[$ _item_id], _zbit, _y, _connected_x1, _connected_x2);
						
						if (_type & ITEM_TYPE_BIT.SOLID) && (_sun_rays_y > _ypos)
						{
							global.sun_rays_y[$ _xindex] = _ypos;
						}
                        
                        if (_natural)
                        {
                            chunk[@ _index_xy | (j << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] = _tile.set_id(_id);
                        }
                        else
                        {
                            chunk[@ _index_xy | (j << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] = variable_clone(_tile).set_id(_id);
                        }
					}
					
					if (++_inst.count >= _rectangle)
					{
						if (!_structure_data[$ _inst.structure].persistent)
						{
							instance_destroy(_inst);
						}
						else
						{
                            _inst.data = undefined;
						}
					}
				}
			}
			
			var _ybit = 1 << _y;
			
			if (_ypos >= _ysurface)
			{
				if ((_skip_layer & 1) == 0)
				{
					var _ = worldgen_wall(_xpos, _ypos, _seed_wall, _world_data, _biome_data, _surface_biome, _cave_biome, _ysurface);
                    
					if (_ != TILE_EMPTY)
					{
						var _item_id      = _[0];
						var _index_offset = _[1];
                        
                        var _tile = new Tile(_item_id, _item_data);
                        
						if (_index_offset != 0)
						{
							_tile.set_index_offset(is_array_irandom(_index_offset));
						}
						
						chunk[@ _index_xy | (CHUNK_DEPTH_WALL << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] = _tile;
						
						surface_display |= 1 << CHUNK_DEPTH_WALL;
						
						if (_cache_draw_update[$ _item_id] != undefined)
						{
							is_on_draw_update |= 1 << CHUNK_DEPTH_WALL;
						}
                        
                        chunk_generate_anim_handler(_item_data[$ _item_id], 1 << CHUNK_DEPTH_WALL, _y, _connected_x1, _connected_x2);
					}
				}
				
				if ((_skip_layer & 2) == 0) && ((_chunk_data & _ybit) == 0)
				{
					var _ = worldgen_base(_xpos, _ypos, _seed_base, _world_data, _biome_data, _surface_biome, _cave_biome, _ysurface);
					
					if (_ != TILE_EMPTY)
					{
						var _item_id      = _[0];
						var _index_offset = _[1];
                        
                        var _tile = new Tile(_item_id, _item_data);
                        
						if (_index_offset != 0)
						{
							_tile.set_index_offset(is_array_irandom(_index_offset));
						}
						
						chunk[@ _index_xy | (CHUNK_DEPTH_DEFAULT << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] = _tile;
						
						surface_display |= 1 << CHUNK_DEPTH_DEFAULT;
						
						if (_cache_draw_update[$ _item_id] != undefined)
						{
							is_on_draw_update |= 1 << CHUNK_DEPTH_DEFAULT;
						}
                        
                        chunk_generate_anim_handler(_item_data[$ _item_id], 1 << CHUNK_DEPTH_DEFAULT, _y, _connected_x1, _connected_x2);
					}
				}
			}
			
			if ((_skip_layer & 2) == 0) && ((_ypos == _ysurface - 1) || ((_cave_biome != -1) && (_chunk_data & _ybit) && ((_chunk_data & (_ybit << 1)) == 0)))
			{
				var _tile_surface = worldgen_base(_xpos, _ypos + 1, _seed_base, _world_data, _biome_data, _surface_biome, _cave_biome, _ysurface);
				var _tile_foliage = worldgen_foliage(_xpos, _ypos, _seed_foliage, _world_data, _biome_data, _surface_biome, _cave_biome, _tile_surface[0]);
				
				if (_tile_foliage != TILE_EMPTY)
				{
					var _z = CHUNK_DEPTH_PLANT;
					
					var _item_id      = _tile_foliage[0];
					var _index_offset = _tile_foliage[1];
                    
					var _tile = new Tile(_item_id, _item_data);
					
					if (_index_offset != 0)
					{
						_tile.set_index_offset(is_array_irandom(_index_offset));
					}
                    
                    var _zbit = 1 << _z;
					
					if (_cache_draw_update[$ _item_id] != undefined)
					{
						is_on_draw_update |= _zbit;
					}
					
					chunk[@ _index_xy | (_z << (CHUNK_SIZE_X_BIT + CHUNK_SIZE_Y_BIT))] = _tile;
					
					surface_display |= _zbit;
					
					if (_item_data[$ _item_id].boolean & ITEM_BOOLEAN.IS_PLANT_WAVEABLE)
					{
                        chunk_z_animated |= _zbit;
					}
				}
			}
		}
	}
	
	if (surface_display)
	{
        chunk_z_refresh |= surface_display;
	}
    
    debug_timer("chunk_generation", $"Chunk generated at ({chunk_xstart / CHUNK_SIZE_X}, {chunk_ystart / CHUNK_SIZE_Y})");
}