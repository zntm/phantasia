function worldgen_get_cave_biome(_x, _y, _seed, _ysurface, _world_data)
{
	if (DEVELOPER_MODE) && (global.debug_settings.force_cave != "-1")
	{
		return global.debug_settings.force_cave;
	}
    
	var _length = _world_data.get_biome_cave_length();
	
	for (var i = 0; i < _length; ++i)
	{
		if (_y < _world_data.get_biome_cave_range_min(i)) || (_y >= _world_data.get_biome_cave_range_max(i)) continue;
        
        var _noise = noise(_x, _y, _world_data.get_cave_threshold_octave(i), _seed - (1024 * i)) * 255;
        
        if (_noise < _world_data.get_biome_cave_threshold_min(i)) || (_noise >= _world_data.get_biome_cave_threshold_max(i)) continue;
		
        return _world_data.get_biome_cave_id(i);
	}
	
	var _length2 = _world_data.get_default_cave_length();
	
	for (var i = 0; i < _length2; ++i)
	{
        var _range_min = _world_data.get_default_cave_range_min(i);
        
        if (_y < _range_min) continue;
        
        var _range_max = _world_data.get_default_cave_range_max(i);
        
		if (_y < _range_max)
		{
			return _world_data.get_default_cave_id(i);
        }
        
        var _type = _world_data.get_default_cave_transition_type(i);
		
		if (_type == "phantasia:linear")
		{
			if (_y >= _range_max + (noise(_x, _y, _world_data.get_default_cave_transition_octave(i), _seed - (1024 * i)) * _world_data.get_default_cave_transition_amplitude(i))) continue;
			
			return _world_data.get_default_cave_id(i);
		}
		
		if (_type == "phantasia:random")
		{
			if (_y >= _range_max + abs((((_seed + _x) * 4615.25) ^ ((_y - _seed) * 9182.5)) % _world_data.get_default_cave_transition_amplitude(i))) continue;
			
			return _world_data.get_default_cave_id(i);
		}
	}
    
    return 0;
}