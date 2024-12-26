function worldgen_get_biome_cave(_x, _y, _seed, _ysurface, _world_data)
{
	var _cave = _world_data.biome.cave;
	
	if (_y <= _ysurface + _cave.start)
	{
		return -1;
	}
	
	if (DEVELOPER_MODE) && (global.debug_settings.force_cave != "-1")
	{
		return global.debug_settings.force_cave;
	}
	
	var _default = _cave[$ "default"];
	
	var _length = (_world_data.value >> 40) & 0xff;
	
	for (var i = 0; i < _length; ++i)
	{
		var _data = _default[i];
		var _value = _data[0];
		
		var _max = (_value >> 16) & 0xffff;
		
		if (_y < _max) && (_y >= (_value & 0xffff))
		{
			return _data[1];
		}
		
		if (_value & (WORLD_CAVE_TRANSITION.LINEAR << 48))
		{
			if (_y >= _max + (noise(_x, _y, (_value >> 40) & 0xff, _seed - (1024 * i)) * ((_value >> 32) & 0xff))) continue;
			
			return _data[1];
		}
		
		if (_value & (WORLD_CAVE_TRANSITION.RANDOM << 48))
		{
			if (_y >= _max + abs((((_seed + _x) * 4615.25) ^ ((_y - _seed) * 9182.5)) % ((_value >> 32) & 0xff))) continue;
			
			return _data[1];
		}
	}
}