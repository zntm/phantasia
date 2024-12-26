function worldgen_base(_x, _y, _seed, _attributes, _biome_data, _surface_biome, _cave_biome, _ysurface)
{
	#region Cave Biome
	
	if (_cave_biome != -1)
	{
		var _tile_solid = _biome_data[$ _cave_biome].tiles_solid;
		var _tile_solid_id = _tile_solid[0];
		
		var _generation = _attributes.generation;
		var _length = (_attributes.value >> 32) & 0xff;
		
		for (var i = 0; i < _length; ++i)
		{
			var _ = _generation[i];
			var _value = _[0];
			
			var _range_min = _value & 0xffff;
			var _range_max = (_value >> 16) & 0xffff;
				
			if (_y <= _range_min) || (_y > _range_max) || ((_value & (1 << 58)) && ((_value & (1 << 59)) ? (!array_contains(_[1], _cave_biome)) : (_[1] != _cave_biome))) continue;
			
			var _noise = noise(_x, _y, (_value >> 32) & 0xff, _seed - (i << 8)) * 255;
				
			var _type = (_value >> 56) & 0b11;
				
			if (_type & (WORLD_CAVE_TYPE.TRIANGULAR << 56))
			{
				_noise *= normalize(_y, _range_min, _range_max);
			}
			else if (_type & (WORLD_CAVE_TYPE.FLIPPED_TRIANGULAR << 56))
			{
				_noise *= 1 - normalize(_y, _range_min, _range_max);
			}
				
			if (_noise > ((_value >> 40) & 0xff)) && (_noise <= ((_value >> 48) & 0xff))
			{
				var _replace = _[2];
				
				if (_replace == undefined) || (_replace == _tile_solid_id)
				{
					return ((_value & (1 << 60)) ? choose_weighted(_[3], _[4]) : _[3]);
				}
			}
		}
		
		return _tile_solid;
	}
		
	#endregion
		
	#region Surface Biome
	
	if (_y == _ysurface)
	{
		return _biome_data[$ _surface_biome].tiles_crust_top_solid;
	}
	
	if (_y <= _ysurface + 8)
	{
		return _biome_data[$ _surface_biome].tiles_crust_bottom_solid;
	}
	
	return _biome_data[$ _surface_biome].tiles_stone_solid;
	
	#endregion
}