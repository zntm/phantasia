function ctrl_structure_underground(_xstart, _xend)
{
	var _world = global.world;
	var _realm = _world.realm;
	
	var _biome_data = global.biome_data;
	var _structure_data = global.structure_data;
	var _world_data = global.world_data[$ _realm];
	
	var _world_value = _world_data.value;
	var _world_caves = _world_data.caves;
	
	var _start = _world_data.biome.cave.start;
	
	var _structure_data_function = global.structure_data_function;
	
	var _seed = _world.seed;
	
	var _seed_cave = _seed + WORLDGEN_SALT.CAVE;
    
	for (var i = _xstart; i <= _xend; ++i)
	{
		var _x2 = i * 16;
		var _xoffset = ((_seed + _x2) ^ 0x82af416f) * 1554.25;
		
		_x2 += (_xoffset & 7) * (((_xoffset ^ 0x71b0ef9) & 128) ? -1 : 1);
		
		var _ysurface  = worldgen_get_ysurface(_x2, _seed, _world_data);
		var _ysurface2 = _ysurface + _start;
		
		for (var j = _ysurface2; j <= _world_data.value & 0xffff; ++j)
		{
			var _y2 = j * 16;
			var _yoffset = ((_seed + _y2) ^ 0x82af416f) * 1077.25;
            
			_y2 += (_yoffset & 7) * (((_yoffset ^ 0x7ab04d81) & 256) ? -1 : 1);
			
			if (_y2 <= _ysurface2) continue;
			
			var _index = $"{i},{j}";
			
			var _cave = worldgen_get_cave_biome(_x2, _y2, _seed, _ysurface, _world_data);
			
			if (_cave == -1) || (worldgen_carve_cave(_x2, _y2, _seed_cave, _world_value, _world_caves, _ysurface)) || (!worldgen_carve_cave(_x2, _y2 - 1, _seed_cave, _world_value, _world_caves, _ysurface)) continue;
			
			var _structures = _biome_data[$ _cave].structures;
			var _structures_length = array_length(_structures);
			
			if (_structures_length <= 0) continue;
            
			var _seed2 = _seed + _x2 + _y2;
            
			random_set_seed(_seed2);
			
			var _xstructure = _x2 * TILE_SIZE;
			var _ystructure = _y2 * TILE_SIZE;
            
			for (var l = 0; l < _structures_length; ++l)
			{
				var _structure = _structures[l];
				
				if (_structure[0] < random(1))
				
				if (i % _structure[1]) || (j % _structure[2]) continue;
				
				var _name = _structure[3];
				
				if (_structure[4])
				{
					structure_create(_xstructure, _ystructure, _name, _seed, _seed2, _structure_data, _structure_data_function, _world_data, false);
					
					break;
				}
				
				var _length = _structure[5];
				
				for (var m = 0; m < _length; ++m)
				{
					structure_create(_xstructure, _ystructure, _name[m], _seed, _seed2, _structure_data, _structure_data_function, _world_data, false);
				}
				
				break;
			}
		}
	}
}