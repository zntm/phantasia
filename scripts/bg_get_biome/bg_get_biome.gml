function bg_get_biome(_x, _y)
{
	var _x2 = round(_x / TILE_SIZE);
	var _y2 = round(_y / TILE_SIZE);

	var _world = global.world;

	var _seed  = _world.seed;
	var _realm = _world.realm;

	var _ysurface = worldgen_get_ysurface(_x2, _seed);
	var _world_data = global.world_data[$ _realm];

	var _cave_biome = worldgen_get_biome_cave(_x2, _y2, _seed, _ysurface, _world_data);

	if (_cave_biome != -1)
	{
		return _cave_biome;
	}

	var _sky_biome = worldgen_get_biome_sky(_x2, _y2, _seed);

	if (_sky_biome != -1)
	{
		return _sky_biome;
	}
	
	return worldgen_get_biome_surface(_x2, 0, _seed, _ysurface, _world_data, _realm);
}