function ctrl_structure_underground(_xstart, _xend, _ystart, _yend)
{
    debug_timer("timer_structure_cave");
    
    static __carve_cave = [];
    
	var _world = global.world;
	var _realm = _world.realm;
	
	var _biome_data = global.biome_data;
	var _structure_data = global.structure_data;
	var _world_data = global.world_data[$ _realm];
    
    var _cave_ystart = _world_data.get_cave_ystart();
    
    _yend = min(_yend, _world_data.get_world_height() - 1);
    
	var _seed = _world.seed;
    var _seed_half = round(_seed / 2);
	
	var _seed_cave = _seed + WORLDGEN_SALT.CAVE;
    
	for (var i = _xstart; i <= _xend; ++i)
	{
		var _ysurface  = worldgen_get_ysurface(i, _seed, _world_data);
		var _ysurface2 = _ysurface + _cave_ystart;
        
        if (_yend < _ysurface2) continue;
		
        var _ystart3 = max(_ystart, _ysurface2);
        
        var _generated = false;
        
        var _index = 1;
        
		for (var j = _ystart3; j <= _yend; ++j)
		{
			var _cave = worldgen_get_cave_biome(i, j, _seed, _ysurface, _world_data);
			
			if (_cave == 0)
            {
                ++_index;
                
                continue;
            }
            
            if (!_generated)
            {
                _generated = true;
                
                var _index2 = 0;
                
                for (var l = _ystart3 - 1; l <= _yend + 1; ++l)
                {
                    __carve_cave[@ _index2++] = (l > _ysurface2 ? worldgen_carve_cave(i, l, _seed_cave, _world_data, _ysurface) : false);
                }
            }
            
            if (__carve_cave[_index])
            {
                ++_index;
                
                continue;
            }
			
            var _empty_above = __carve_cave[_index - 1];
            var _empty_below = __carve_cave[_index + 1];
            
			var _structures = _biome_data[$ _cave].structures;
			var _structures_length = array_length(_structures);
			
			if (_structures_length <= 0)
            {
                ++_index;
                
                continue;
            }
            
			var _seed2 = round(round(_seed_half + (i * 312.25)) - (j * 140.125));
            
			random_set_seed(_seed2);
			
			var _xstructure = i * TILE_SIZE;
			var _ystructure = j * TILE_SIZE;
            
			for (var l = 0; l < _structures_length; ++l)
			{
				var _structure = _structures[l];
				
				if (!chance(_structure[0])) continue;
				
				if (i % _structure[1]) || (j % _structure[2]) continue;
				
				var _name = _structure[3];
				
				if (_structure[4])
				{
					var _inst = structure_create(_xstructure, _ystructure, _name, _seed, _seed2, _structure_data, _world_data, _empty_above, _empty_below, false);
                    
                    if (instance_exists(_inst)) break;
				}
                else
                {
                    var _exists = false;
                    
                    var _length = _structure[5];
                    
                    for (var m = 0; m < _length; ++m)
                    {
                        var _inst = structure_create(_xstructure, _ystructure, _name[m], _seed, _seed2, _structure_data, _world_data, _empty_above, _empty_below, false);
                        
                        if (instance_exists(_exists))
                        {
                            _exists = true;
                        }
                    }
                    
                    if (_exists) break;
                }
			}
            
            ++_index;
		}
	}
    
    debug_timer("timer_structure_cave", "Generated Cave Structures");
}