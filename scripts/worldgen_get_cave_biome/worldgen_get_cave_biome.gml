function worldgen_get_cave_biome(_x, _y, _seed, _ysurface, _world_data)
{
	var _cave = _world_data.biome.cave;
	
	if (_y <= _ysurface + _cave.get_cave_ystart())
	{
		return -1;
	}
	
	if (DEVELOPER_MODE) && (global.debug_settings.force_cave != "-1")
	{
		return global.debug_settings.force_cave;
	}
	
	var _default = _cave[$ "default"];
	
	var _length = _world_data.get_default_cave_length();
	
	for (var i = 0; i < _length; ++i)
	{
        var _range_min = _world_data.get_default_cave_range_min(i);
        var _range_max = _world_data.get_default_cave_range_max(i);
        
		if (_y < _range_max) && (_y >= _range_min)
		{
			return _world_data.get_default_cave_id(i);
        }
        
        var _type = _world_data.get_default_cave_type(i);
		
		if (_type == "phantasia:linear")
		{
			if (_y >= _range_max + (noise(_x, _y, (_value >> 40) & 0xff, _seed - (1024 * i)) * _world_data.get_default_cave_transition_amplitude(i))) continue;
			
			return _world_data.get_default_cave_id(i);
		}
		
		if (_type == "phantasia:random")
		{
			if (_y >= _range_max + abs((((_seed + _x) * 4615.25) ^ ((_y - _seed) * 9182.5)) % _world_data.get_default_cave_transition_amplitude(i))) continue;
			
			return _world_data.get_default_cave_id(i);
		}
	}
}