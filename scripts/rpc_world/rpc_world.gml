function rpc_world()
{
	var _x = round(obj_Player.x / TILE_SIZE);
	var _y = round(obj_Player.y / TILE_SIZE);
	
	/*
	var _inst = instance_nearest(_x, _y, obj_Boss);
		
	if (instance_exists(_inst))
	{
		var _data = global.boss_data[_inst.boss_id];
		var _type = _data.type;
			
		if (_data == BOSS_TYPE.SKY)
		{
			np_setpresence($"rpc.biome.sky.{_data.name}", global.world.info.name, _data.rpc_icon, "");
		}
		else if (_data == BOSS_TYPE.SURFACE)
		{
			np_setpresence($"rpc.biome.surface.{_data.name}", global.world.info.name, _data.rpc_icon, "");
		}
		else if (_data == BOSS_TYPE.CAVE)
		{
			np_setpresence($"rpc.biome.cave.{_data.name}", global.world.info.name, _data.rpc_icon, "");
		}
			
		exit;
	}
	*/
	
	var _world = global.world;
	
	var _seed  = _world.seed;
	var _realm = _world.realm;
	
	var _world_data = global.world_data[$ _realm];
	var _ysurface = worldgen_get_ysurface(_x, _seed, _world_data);
	
	/*
	static __sky = global.world_data[WORLD.PLAYGROUND].sky_biome;
		
	if (__sky != -1)
	{
		var _sky = __sky(_x, _y, _seed);
			
		if (_sky != -1)
		{
			var _data = global.sky_biome_data[_sky];
				
			np_setpresence(loca_translate($"rpc.biome.sky.{_data.name}"), _info.name, _data.rpc_icon, "");
				
			exit;
		}
	}
	*/
	
	static __rpc = function(_biome, _type)
	{
		var _data = global.biome_data[$ _biome];
		
		np_setpresence(loca_translate($"rpc.biome.{_type}.{string_split(_biome, ":")[1]}"), _biome, _data.rpc_icon, "");
	}
	
	var _cave = worldgen_get_biome_cave(_x, _y, _seed, _ysurface, _world_data);
	
	if (_cave != -1)
	{
		__rpc(_cave, "cave");
				
		exit;
	}
	
	__rpc(worldgen_get_biome_surface(_x, _y, _seed, _ysurface, _world_data, _realm), "surface");
}