function worldgen_carve_cave(_x, _y, _seed, _world_data, _world_value, _world_caves, _ysurface)
{
	if (_y <= _ysurface + _world_data.get_cave_ystart())
	{
		return false;
	}
	
	for (var i = _world_data.get_cave_length() - 1; i >= 0; --i)
	{
		if (_y > _world_data.get_cave_range_max(i)) || (_y <= _world_data.get_cave_range_min(i)) continue;
		
		var _noise = noise(_x, _y, _world_data.get_cave_threshold_octave(i), _seed - (i << 8)) * 255;
		
		if (_noise > _world_data.get_cave_threshold_max(i)) || (_noise <= _world_data.get_cave_threshold_min(i)) continue;
		
		return true;
	}
	
	return false;
}