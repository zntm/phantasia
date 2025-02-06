function ctrl_structure_underground(_xstart, _xend, _ystart, _yend)
{
	var _world = global.world;
	var _realm = _world.realm;
	
	var _biome_data = global.biome_data;
	var _structure_data = global.structure_data;
	var _world_data = global.world_data[$ _realm];
    
    _yend = min(_yend, _world_data.get_world_height());
    
	var _natural_structure_data = global.natural_structure_data;
	
	var _seed = _world.seed;
	
	var _seed_cave = _seed + WORLDGEN_SALT.CAVE;
    
	for (var i = _xstart; i <= _xend; ++i)
	{
		var _ysurface  = worldgen_get_ysurface(i, _seed, _world_data);
		var _ysurface2 = _ysurface + _world_data.get_cave_ystart();
        
        if (_ystart < _ysurface2) continue;
		
		for (var j = _ystart; j <= _yend; ++j)
		{
			if (j <= _ysurface2) continue;
			
			var _cave = worldgen_get_cave_biome(i, j, _seed, _ysurface, _world_data);
			
			if (_cave == -1) || (worldgen_carve_cave(i, j, _seed_cave, _world_data, _ysurface)) continue;
			
            var _empty_above = worldgen_carve_cave(i, j - 1, _seed_cave, _world_data, _ysurface);
            var _empty_below = worldgen_carve_cave(i, j + 1, _seed_cave, _world_data, _ysurface);
            
            if (_empty_above == _empty_below) continue;
            
			var _structures = _biome_data[$ _cave].structures;
			var _structures_length = array_length(_structures);
			
			if (_structures_length <= 0) continue;
            
			var _seed2 = _seed + i + j;
            
			random_set_seed(_seed2);
			
			var _xstructure = i * TILE_SIZE;
			var _ystructure = j * TILE_SIZE;
            
			for (var l = 0; l < _structures_length; ++l)
			{
				var _structure = _structures[l];
				
				if (_structure[0] < random(1))
				
				if (i % _structure[1]) || (j % _structure[2]) continue;
				
				var _name = _structure[3];
				
				if (_structure[4])
				{
					structure_create(_xstructure, _ystructure, _name, _seed, _seed2, _structure_data, _natural_structure_data, _world_data, _empty_above, _empty_below, false);
					
					break;
				}
				
				var _length = _structure[5];
				
				for (var m = 0; m < _length; ++m)
				{
					structure_create(_xstructure, _ystructure, _name[m], _seed, _seed2, _structure_data, _natural_structure_data, _world_data, _empty_above, _empty_below, false);
				}
				
				break;
			}
		}
	}
}