function world_spawn_player(_directory, _seed, _inst)
{
	if (directory_exists(_directory))
	{
		var _spawnpoint = $"{_directory}/Players/{_inst.uuid}/Spawnpoint.dat";
		
		if (file_exists(_spawnpoint))
		{
			var _buffer = buffer_load_decompressed(_spawnpoint);
			
			var _version_major = buffer_read(_buffer, buffer_u8);
			var _version_minor = buffer_read(_buffer, buffer_u8);
			var _version_patch = buffer_read(_buffer, buffer_u8);
			var _version_type  = buffer_read(_buffer, buffer_u8);
			
			var _realm = buffer_read(_buffer, buffer_string);
			
			if (global.world.realm == _realm)
			{
				_inst.x = buffer_read(_buffer, buffer_f64);
				_inst.y = buffer_read(_buffer, buffer_f64);
				
				_inst.xvelocity = buffer_read(_buffer, buffer_f16);
				_inst.yvelocity = buffer_read(_buffer, buffer_f16);
				
				_inst.ylast = buffer_read(_buffer, buffer_f64);
				
				buffer_delete(_buffer);
				
				exit;
			}
			
			buffer_delete(_buffer);
		}
	}
	
	if (FORCE_SPAWN_ON == -1) || (FORCE_SURFACE_BIOME != -1)
	{
		_inst.y = (worldgen_get_ysurface(0, _seed) - 1) * TILE_SIZE;
		_inst.ylast = _inst.y;
		
		exit;
	}
	
	var _realm = global.world.realm;
	var _data = global.world_data[$ _realm];
	
	for (var i = 1; i <= 127; ++i)
	{
		var _x = (i << CHUNK_SIZE_X_BIT) + CHUNK_SIZE_WIDTH_H;
		
		var _ysurface = worldgen_get_ysurface(_x, _seed, _data);
		
		if (worldgen_get_surface_biome(_x, 0, _seed, _ysurface, _data, _realm) == FORCE_SPAWN_ON)
		{
			_inst.x = _x * TILE_SIZE;
			
			_inst.y = (_ysurface - 1) * TILE_SIZE;
			_inst.ylast = _inst.y;
			
			exit;
		}
		
		var _ysurface2 = worldgen_get_ysurface(-_x, _seed, _data);
		
		if (worldgen_get_surface_biome(-_x, 0, _seed, _ysurface2, _data, _realm) == FORCE_SPAWN_ON)
		{
			_inst.x = -_x * TILE_SIZE;
			
			_inst.y = (_ysurface2 - 1) * TILE_SIZE;
			_inst.ylast = _inst.y;
			
			exit;
		}
	}
}