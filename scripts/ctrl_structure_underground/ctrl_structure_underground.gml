enum WORLDGEN_UNDERGROUND_STRUCTURE {
    CARVE_TOP = 0b100,
    CARVE_MID = 0b010,
    CARVE_BOT = 0b001
}

function ctrl_structure_underground(_xstart, _xend, _ystart, _yend)
{
    debug_timer("timer_structure_cave");
    
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
        
        var _xstructure = i * TILE_SIZE;
        
        var _seed2 = round(_seed_half + (i * 312.25));
        
        // NOTE: I know this is horrible, but it improved the performance of structure generation a bit. I hate it as well.
        var _carve =
            (worldgen_carve_cave(i, _ystart3 - 1, _seed_cave, _world_data, _ysurface) << 2) |
            (worldgen_carve_cave(i, _ystart3,     _seed_cave, _world_data, _ysurface) << 1) |
            (worldgen_carve_cave(i, _ystart3 + 1, _seed_cave, _world_data, _ysurface) << 0);
        
		for (var j = _ystart3; j <= _yend; ++j)
		{
            if (_carve & WORLDGEN_UNDERGROUND_STRUCTURE.CARVE_MID)
            {
                _carve = (_carve << 1) | worldgen_carve_cave(i, j + 1, _seed_cave, _world_data, _ysurface);
                
                continue;
            }
            
			var _cave = worldgen_get_cave_biome(i, j, _seed, _ysurface, _world_data);
			
			if (_cave == 0)
            {
                _carve = (_carve << 1) | worldgen_carve_cave(i, j + 1, _seed_cave, _world_data, _ysurface);
                
                continue;
            }
            
            var _data = _biome_data[$ _cave];
			
			var _structures_length = _data.structures_length;
			
			if (_structures_length <= 0)
            {
                _carve = (_carve << 1) | worldgen_carve_cave(i, j + 1, _seed_cave, _world_data, _ysurface);
                
                continue;
            }
            
            var _carve_top    = !!(_carve & WORLDGEN_UNDERGROUND_STRUCTURE.CARVE_TOP);
            var _carve_bottom = !!(_carve & WORLDGEN_UNDERGROUND_STRUCTURE.CARVE_BOT);
            
            var _structures = _data.structures;
            
			var _seed3 = round(_seed2 - (j * 140.125));
            
			random_set_seed(_seed3);
			
			var _ystructure = j * TILE_SIZE;
            
			for (var l = 0; l < _structures_length; ++l)
			{
				var _structure = _structures[l];
				
				if (!chance(_structure[0])) || (i % _structure[1]) || (j % _structure[2]) continue;
				
				var _name = _structure[3];
				
				if (_structure[4])
				{
					var _inst = structure_create(_xstructure, _ystructure, _name, _seed, _seed3, _structure_data, _world_data, _carve_top, _carve_bottom, false);
                    
                    if (instance_exists(_inst)) break;
				}
                else
                {
                    var _exists = false;
                    
                    var _length = _structure[5];
                    
                    for (var m = 0; m < _length; ++m)
                    {
                        var _inst = structure_create(_xstructure, _ystructure, _name[m], _seed, _seed3, _structure_data, _world_data, _carve_top, _carve_bottom, false);
                        
                        if (instance_exists(_exists))
                        {
                            _exists = true;
                        }
                    }
                    
                    if (_exists) break;
                }
			}
            
            _carve = (_carve << 1) | worldgen_carve_cave(i, j + 1, _seed_cave, _world_data, _ysurface);
		}
	}
    
    debug_timer("timer_structure_cave", "Generated Cave Structures");
}