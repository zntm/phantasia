function worldgen_foliage(_x, _y, _seed, _attributes, _biome_data, _surface_biome, _cave_biome, _tile_default)
{
	#region Cave Biome
	
	if (_cave_biome != -1)
	{
		var _foliage = _biome_data[$ _cave_biome].foliage;
		
		if (random(1) < _foliage[0]) && (array_contains(_foliage[1], _tile_default))
		{
			return choose_weighted(_foliage[2]);
		}
	}
	
	#endregion
	
	#region Surface Biome
	
	var _foliage = _biome_data[$ _surface_biome].foliage;
	
	if (random(1) < _foliage[0]) && (array_contains(_foliage[1], _tile_default))
	{
		return choose_weighted(_foliage[2]);
	}
	
	#endregion
	
	return TILE_EMPTY;
}